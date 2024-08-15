import 'package:auto_route/auto_route.dart';
import 'package:bang/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:local_network_room/local_network_room.dart';

@RoutePage()
class StartGameScreen extends StatelessWidget {
  const StartGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: BlocBuilder<CreateRoomCubit, CreateRoomState>(
            builder: (context, state) => Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    transitionBuilder: (child, animation) => SizeTransition(
                      sizeFactor: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: state.maybeMap(
                      ready: (value) => ListView.builder(
                        itemCount: value.connectedPlayers.length,
                        itemBuilder: (context, index) {
                          final item = value.connectedPlayers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            child: Column(
                              children: [
                                Text(item.name),
                                const Gap(8),
                                Text(item.ip),
                              ],
                            ),
                          );
                        },
                      ),
                      orElse: () => const SizedBox(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: state.maybeMap(
                    ready: (value) => () async {
                      final bloc = context.read<CreateRoomCubit>();
                      await context.replaceRoute(
                        TicTacToeGameRoute(
                          isHost: true,
                          currentPlayer: value.connectedPlayers.firstWhere((e) => e.ip == value.host.ip),
                          otherPlayer: value.connectedPlayers.firstWhere((e) => e.ip != value.host.ip),
                        ),
                      );
                      bloc.closeRoom();
                    },
                    orElse: () => null,
                  ),
                  child: const Text('Start game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
