import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repository/client_repository.dart';
import '../../model/server_info/server_info.dart';

part 'servers_list_cubit.freezed.dart';

class ServersListCubit extends Cubit<ServersListState> {
  final ClientRepository _clientRepository;

  ServersListCubit(
    this._clientRepository,
  ) : super(
          const ServersListState.initial(),
        );

  Future<void> getList() async {
    try {
      emit(const ServersListState.loading());
      final list = await _clientRepository.getServersList();
      emit(ServersListState.ready(list));
    } catch (err) {
      emit(
        ServersListState.error(
          err is Exception ? err : Exception(err),
        ),
      );
    }
  }
}

@freezed
class ServersListState with _$ServersListState {
  const factory ServersListState.initial() = ServersListStateInitial;

  const factory ServersListState.loading() = ServersListStateLoading;

  const factory ServersListState.ready(List<ServerInfo> servers) = ServersListStateReady;

  const factory ServersListState.error(Exception error) = ServersListStateError;
}
