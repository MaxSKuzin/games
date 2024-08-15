import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_network_room/domain/model/server_info/server_info.dart';

import '../../../data/repository/server_repository.dart';
import '../../model/client_info/client_info.dart';

part 'create_room_cubit.freezed.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  final ServerRepository _repository;
  final _connectedPlayers = <ClientInfo>[];

  CreateRoomCubit(
    this._repository,
  ) : super(const CreateRoomState.initial());

  Future<void> start({
    required String serverName,
    required String playerName,
  }) async {
    emit(const CreateRoomState.loading());
    try {
      late ServerInfo server;
      server = await _repository.createRoom(
        serverName: serverName,
        connectedPlayers: _connectedPlayers,
        onConnected: (client) {
          if (_connectedPlayers.every((element) => element.ip != client.ip)) {
            _connectedPlayers.add(client);
          }
          emit(
            CreateRoomState.ready(
              server,
              _connectedPlayers.toList(),
            ),
          );
        },
        onDisconnected: (ip) {
          _connectedPlayers.removeWhere((player) => player.ip == ip);
          emit(
            CreateRoomState.ready(
              server,
              _connectedPlayers.toList(),
            ),
          );
        },
      );
      _connectedPlayers.add(
        ClientInfo(
          name: playerName,
          ip: server.ip,
        ),
      );
      emit(
        CreateRoomState.ready(
          server,
          _connectedPlayers.toList(),
        ),
      );
    } catch (err) {
      emit(
        CreateRoomState.error(
          err is Exception ? err : Exception(err),
        ),
      );
    }
  }

  Future<void> closeRoom() async {
    await _repository.closeRoom();
    emit(const CreateRoomStateInitial());
  }
}

@freezed
class CreateRoomState with _$CreateRoomState {
  const factory CreateRoomState.initial() = CreateRoomStateInitial;

  const factory CreateRoomState.loading() = CreateRoomStateLoading;

  const factory CreateRoomState.ready(
    ServerInfo host,
    List<ClientInfo> connectedPlayers,
  ) = CreateRoomStateReady;

  const factory CreateRoomState.error(Exception error) = CreateRoomStateError;
}
