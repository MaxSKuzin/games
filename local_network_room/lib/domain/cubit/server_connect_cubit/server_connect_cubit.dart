import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_network_room/domain/model/client_info/client_info.dart';
import 'package:local_network_room/domain/model/room_event/room_event.dart';

import '../../../data/repository/client_repository.dart';
import '../../model/server_info/server_info.dart';

part 'server_connect_cubit.freezed.dart';

class ServerConnectCubit extends Cubit<ServerConnectState> {
  final ClientRepository _clientRepository;
  StreamSubscription? _streamSubscription;

  ServerConnectCubit(
    this._clientRepository,
  ) : super(const ServerConnectState.disconnected());

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _clientRepository.disconnectFromServer();

    return super.close();
  }

  Future<void> connect({
    required ServerInfo server,
    required String playerName,
  }) async {
    assert(state is ServerConnectStateDisconnected);
    emit(const ServerConnectState.loading());
    try {
      final clientInfo = await _clientRepository.connectToServer(
        address: server.ip,
        playerName: playerName,
      );
      _streamSubscription ??= _clientRepository.eventStream.listen((e) async {
        if (e is RoomEvent$Closed) {
          await _clientRepository.disconnectFromServer();
          _streamSubscription = null;
          emit(const ServerConnectState.disconnected());
        }
      });
      emit(ServerConnectState.connected(
        server,
        clientInfo,
      ));
    } catch (_) {
      emit(const ServerConnectState.disconnected());
    }
  }
}

@freezed
class ServerConnectState with _$ServerConnectState {
  const factory ServerConnectState.disconnected() = ServerConnectStateDisconnected;

  const factory ServerConnectState.loading() = ServerConnectStateLoading;

  const factory ServerConnectState.connected(ServerInfo server, ClientInfo clientInfo) = ServerConnectStateConnected;
}
