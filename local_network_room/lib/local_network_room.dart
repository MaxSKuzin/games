import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:get_it/get_it.dart';
import 'package:local_network_room/di.dart';

export 'domain/cubit/create_room_cubit/create_room_cubit.dart';
export 'domain/cubit/server_connect_cubit/server_connect_cubit.dart';
export 'domain/cubit/servers_list/servers_list_cubit.dart';
export 'domain/model/client_info/client_info.dart';
export 'domain/model/server_info/server_info.dart';
export 'data/repository/client_repository.dart';

class LocalNetworkRoom {
  static void setup(GetIt sl) {
    DI.initializeDependencies(sl);
    return DartPingIOS.register();
  }
}
