import 'package:local_network_room/domain/model/client_info/client_info.dart';
import 'package:local_network_room/domain/model/room_event/room_event.dart';

import '../../domain/model/server_info/server_info.dart';
import '../network_source.dart';

class ClientRepository {
  final NetworkSource _networkSource;

  ClientRepository(this._networkSource);

  Future<List<ServerInfo>> getServersList() => _networkSource.getAvailableServers();

  Future<ClientInfo> connectToServer({
    required String address,
    required String playerName,
  }) =>
      _networkSource.connectToServer(
        address: address,
        playerName: playerName,
      );

  Future<void> disconnectFromServer() => _networkSource.disconnectFromServer();

  Stream<RoomEvent> get eventStream => _networkSource.eventStream;

  Future<void> sendData(Object data) => _networkSource.sendData(data);
}
