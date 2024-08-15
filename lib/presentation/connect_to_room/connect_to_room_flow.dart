import 'package:auto_route/auto_route.dart';
import 'package:bang/injection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_network_room/local_network_room.dart';

@RoutePage()
class ConnectToRoomFlow extends StatefulWidget {
  const ConnectToRoomFlow({super.key});

  @override
  State<ConnectToRoomFlow> createState() => _ConnectToRoomFlowState();
}

class _ConnectToRoomFlowState extends State<ConnectToRoomFlow> {
  final _connectCubit = getIt<ServerConnectCubit>();

  @override
  void dispose() {
    _connectCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _connectCubit,
      child: AutoRouter(
        builder: (context, content) => BlocListener<ServerConnectCubit, ServerConnectState>(
          listener: (context, state) => state.mapOrNull(
            disconnected: (_) => context.maybePop(),
          ),
          child: content,
        ),
      ),
    );
  }
}
