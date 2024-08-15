import '../../domain/model/client_info/client_info.dart';
import '../../domain/model/server_info/server_info.dart';
import '../network_source.dart';

class ServerRepository {
  final NetworkSource _networkSource;

  ServerRepository(this._networkSource);

  Future<ServerInfo> createRoom({
    required String serverName,
    required Function(ClientInfo client) onConnected,
    required Function(String clientIp) onDisconnected,
    required List<ClientInfo> connectedPlayers,
  }) =>
      _networkSource.createRoom(
        serverName: serverName,
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        connectedPlayers: connectedPlayers,
      );

  Future<void> closeRoom() => _networkSource.closeRoom();
}
