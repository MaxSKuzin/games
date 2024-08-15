import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:local_network_room/domain/model/room_event/room_event.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:rxdart/subjects.dart';

import '../domain/model/client_info/client_info.dart';
import '../domain/model/server_info/server_info.dart';

enum EventType {
  connect,
  data;

  factory EventType.fromName(String name) => switch (name) {
        'connect' => EventType.connect,
        'data' => EventType.data,
        _ => throw Exception('No such event type'),
      };
}

class NetworkSource {
  static const _httpPort = 8000;
  static const _socketPort = 4000;
  HttpServer? _httpServer;
  ServerSocket? _socketServer;
  Socket? _clientConnection;
  final _sockets = <Socket>[];
  StreamSubscription? _httpSubscription;
  StreamSubscription? _serverSubscription;

  BehaviorSubject<RoomEvent>? _eventsController;

  Stream<RoomEvent> get eventStream {
    if (_eventsController == null) {
      throw const SocketException('There is no connection to receive events');
    }
    return _eventsController!.stream;
  }

  Future<ServerInfo> createRoom({
    required String serverName,
    required Function(ClientInfo client) onConnected,
    required Function(String clientIp) onDisconnected,
    required List<ClientInfo> connectedPlayers,
  }) async {
    var wifiIP = await (NetworkInfo().getWifiIP());
    if (wifiIP == null) {
      throw const SocketException('Failed to receive host IP');
    }

    await _httpServer?.close();
    final ip = await InternetAddress.lookup(wifiIP).then(
      (value) => value.first,
    );
    _httpServer = await HttpServer.bind(
      ip,
      _httpPort,
      shared: true,
    );

    _httpSubscription = _httpServer!.listen(
      (request) => _serverInfoRequestListener(
        request: request,
        ip: ip.address,
        players: connectedPlayers,
        serverName: serverName,
      ),
    );

    _socketServer = await ServerSocket.bind(
      ip,
      _socketPort,
      shared: true,
    );

    _serverSubscription = _socketServer!.listen(
      (socket) {
        final clientAddress = socket.remoteAddress.address;
        _sockets.add(socket);
        _eventsController ??= BehaviorSubject();
        socket.listen(
          (event) {
            final stringData = const Utf8Decoder().convert(event);
            final data = jsonDecode(stringData) as Map<String, dynamic>;
            final eventType = EventType.fromName(data['eventType']);
            switch (eventType) {
              case EventType.connect:
                if (EventType.fromName(data['eventType']) == EventType.connect) {
                  final client = ClientInfo.fromJson(
                    data['data'],
                  );
                  onConnected(client);
                }
              case EventType.data:
                _eventsController!.add(RoomEvent$NewData(data: data['data']));
            }
          },
          onDone: () {
            onDisconnected(clientAddress);
            _eventsController!.add(const RoomEvent$Closed());
            _eventsController = null;
            _sockets.remove(socket);
          },
        );
      },
    );

    return ServerInfo(
      name: serverName,
      ip: ip.address,
      players: [],
    );
  }

  Future<void> closeRoom() async {
    await _httpSubscription?.cancel();
    await _serverSubscription?.cancel();
    await _httpServer?.close();
    await _socketServer?.close();
    for (var element in _sockets) {
      element.close();
    }
    _sockets.clear();
    _socketServer = null;
    _httpServer = null;
  }

  void _serverInfoRequestListener({
    required HttpRequest request,
    required String serverName,
    required List<ClientInfo> players,
    required String ip,
  }) {
    if (request.requestedUri.path == '/server/info') {
      final data = ServerInfo(
        ip: ip,
        name: serverName,
        players: players,
      ).toJson();

      request.response
        ..write(jsonEncode(data))
        ..close();
    } else {
      request.response
        ..addError('Unknown method')
        ..close();
    }
  }

  Future<List<ServerInfo>> getAvailableServers() async {
    final ips = await _getLocalNetworkIps();

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 2);
    client.idleTimeout = const Duration(seconds: 2);
    final availableHosts = await Future.wait(
      ips.map(
        (ip) async {
          try {
            var request = await client.get(ip, _httpPort, 'server/info');
            request.headers.contentType = ContentType(
              "text",
              "plain",
              charset: "utf-8",
            );

            final response = await request.close();
            final data = await response.transform(utf8.decoder).join().then(
                  (value) => jsonDecode(value) as Map<String, dynamic>,
                );

            return ServerInfo.fromJson(data);
          } catch (err) {
            return null;
          }
        },
      ),
    ).then(
      (value) => value.whereNotNull().toList(),
    );
    return availableHosts;
  }

  Future<ClientInfo> connectToServer({
    required String address,
    required String playerName,
  }) async {
    var wifiIP = await (NetworkInfo().getWifiIP());
    await _clientConnection?.close();
    _clientConnection = await Socket.connect(
      InternetAddress(
        address,
        type: InternetAddressType.IPv4,
      ),
      _socketPort,
    );
    final playerInfo = ClientInfo(
      name: playerName,
      ip: wifiIP!,
    );
    _clientConnection!.add(
      const Utf8Encoder().convert(jsonEncode({
        'eventType': EventType.connect.name,
        'data': playerInfo.toJson(),
      })),
    );
    _eventsController ??= BehaviorSubject();
    _clientConnection!.listen(
      _receiveServerEvent,
      onDone: () {
        _eventsController!.add(const RoomEvent$Closed());
        _eventsController = null;
      },
    );
    return playerInfo;
  }

  void _receiveServerEvent(List<int> event) {
    final stringData = const Utf8Decoder().convert(event);
    final data = jsonDecode(stringData);

    _eventsController!.add(RoomEvent$NewData(data: data));
  }

  Future<void> disconnectFromServer() async {
    await _clientConnection?.close();
    _clientConnection = null;
  }

  Future<List<String>> _getLocalNetworkIps() async {
    var wifiIP = await (NetworkInfo().getWifiIP());

    if (wifiIP == null) {
      return [];
    }
    var subnet = _ipToCSubnet(wifiIP);

    return _quickIcmpScan(subnet).then(
      (value) => value.whereNot((element) => element == wifiIP).toList(),
    );
  }

  Future<List<String>> _quickIcmpScan(
    String subnet, {
    int firstIP = 1,
    int lastIP = 255,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final hostFutures = <Future<String?>>[];

    for (var currAddr = firstIP; currAddr <= lastIP; ++currAddr) {
      final hostToPing = '$subnet.$currAddr';

      hostFutures.add(
        _pingHost(
          hostToPing,
          timeout: timeout.inSeconds,
        ),
      );
    }

    final resolvedHosts = await Future.wait(hostFutures);

    return resolvedHosts.whereNotNull().toList();
  }

  Future<String?> _pingHost(
    String target, {
    required int timeout,
  }) async {
    late Ping pingRequest;
    pingRequest = Ping(target, count: 1, timeout: timeout, forceCodepage: true);

    await for (final data in pingRequest.stream) {
      if (data.response != null && data.error == null) {
        return data.response?.ip;
      } else {
        return null;
      }
    }
    return null;
  }

  String _ipToCSubnet(String ip) {
    if (!ip.contains('.')) {
      throw Exception('Invalid or empty string has been provided: $ip');
    }

    return ip.substring(0, ip.lastIndexOf('.'));
  }

  Future<void> sendData(Object data) async {
    if (_clientConnection != null) {
      _clientConnection!.add(
        const Utf8Encoder().convert(jsonEncode(
          {
            'eventType': EventType.data.name,
            'data': data,
          },
        )),
      );
    } else {
      for (var socket in _sockets) {
        socket.add(
          const Utf8Encoder().convert(jsonEncode(data)),
        );
      }
    }
    _eventsController?.add(RoomEvent$NewData(data: data));
  }
}
