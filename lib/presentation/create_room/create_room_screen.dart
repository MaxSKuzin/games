import 'package:auto_route/auto_route.dart';
import 'package:bang/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_network_room/local_network_room.dart';

@RoutePage()
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _serverNameController = TextEditingController();
  final _playerNameController = TextEditingController();

  @override
  void dispose() {
    _serverNameController.dispose();
    _playerNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRoomCubit, CreateRoomState>(
      listenWhen: (previous, current) => previous is! CreateRoomStateReady,
      listener: (context, state) {
        if (state is CreateRoomStateReady) {
          context.pushRoute(
            const StartGameRoute(),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: context.maybePop,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Server name'),
                    controller: _serverNameController,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Player name'),
                    controller: _playerNameController,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  BlocBuilder<CreateRoomCubit, CreateRoomState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.maybeMap(
                          initial: (value) => _start,
                          error: (value) => _start,
                          orElse: () => null,
                        ),
                        child: const Text('Start'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _start() async {
    context.read<CreateRoomCubit>().start(
          serverName: _serverNameController.text,
          playerName: _playerNameController.text,
        );
  }
}
