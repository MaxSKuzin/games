import 'package:get_it/get_it.dart';
import 'package:local_network_room/data/network_source.dart';
import 'package:local_network_room/data/repository/client_repository.dart';
import 'package:local_network_room/data/repository/server_repository.dart';
import 'package:local_network_room/domain/cubit/create_room_cubit/create_room_cubit.dart';
import 'package:local_network_room/domain/cubit/server_connect_cubit/server_connect_cubit.dart';
import 'package:local_network_room/domain/cubit/servers_list/servers_list_cubit.dart';

abstract class DI {
  static Future<void> initializeDependencies(GetIt sl) async {
    _singletons(sl);

    _cubits(sl);
  }

  static void _singletons(GetIt sl) {
    final networkSource = NetworkSource();
    final clientRepository = ClientRepository(networkSource);
    final serverRepository = ServerRepository(networkSource);

    sl.registerSingleton<NetworkSource>(networkSource);
    sl.registerSingleton<ClientRepository>(clientRepository);
    sl.registerSingleton<ServerRepository>(serverRepository);
  }

  static void _cubits(GetIt sl) {
    sl.registerFactory<CreateRoomCubit>(() => CreateRoomCubit(sl<ServerRepository>()));
    sl.registerFactory<ServerConnectCubit>(() => ServerConnectCubit(sl<ClientRepository>()));
    sl.registerFactory<ServersListCubit>(() => ServersListCubit(sl<ClientRepository>()));
  }
}
