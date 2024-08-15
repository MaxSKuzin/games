import 'package:auto_route/auto_route.dart';
import 'package:bang/injection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_network_room/local_network_room.dart';

@RoutePage()
class CreateRoomFlow extends StatefulWidget {
  const CreateRoomFlow({super.key});

  @override
  State<CreateRoomFlow> createState() => _CreateRoomFlowState();
}

class _CreateRoomFlowState extends State<CreateRoomFlow> {
  final _cubit = getIt.get<CreateRoomCubit>();

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: AutoRouter(
        builder: (context, content) => BlocListener<CreateRoomCubit, CreateRoomState>(
          listener: (context, state) => state.mapOrNull(
            initial: (_) => context.maybePop(),
          ),
          child: content,
        ),
      ),
    );
  }
}
