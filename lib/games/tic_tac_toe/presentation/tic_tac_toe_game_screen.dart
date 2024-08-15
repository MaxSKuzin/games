import 'package:auto_route/auto_route.dart';
import 'package:bang/games/tic_tac_toe/domain/tic_tac_toe_game_process_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_network_room/domain/model/client_info/client_info.dart';

@RoutePage()
class TicTacToeGameScreen extends StatefulWidget {
  final ClientInfo currentPlayer;
  final ClientInfo otherPlayer;
  final bool isHost;

  const TicTacToeGameScreen({
    super.key,
    required this.currentPlayer,
    required this.otherPlayer,
    required this.isHost,
  });

  @override
  State<TicTacToeGameScreen> createState() => _TicTacToeGameScreenState();
}

class _TicTacToeGameScreenState extends State<TicTacToeGameScreen> {
  late final _cubit = TicTacToeGameProcessCubit(
    isHost: widget.isHost,
    currentPlayer: widget.currentPlayer,
    otherPlayer: widget.otherPlayer,
  );

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<TicTacToeGameProcessCubit, TicTacToeGameProcessState>(
          builder: (context, state) {
            if (state is TicTacToeGameProcessState$Initial) {
              return const CircularProgressIndicator();
            }
            state as TicTacToeGameProcessState$Game;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Your sign ${state.currentSign.toString()}'),
                          Text('Next sign ${state.nextSign.toString()}'),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text('Scores'),
                          Text('${widget.currentPlayer.name}: ${state.winsCount[widget.currentPlayer]}'),
                          Text('${widget.otherPlayer.name}: ${state.winsCount[widget.otherPlayer]}'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          GridView(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: TicTacToeGameProcessCubit.colsCount,
                            ),
                            children: List.generate(
                              TicTacToeGameProcessCubit.rowsCount,
                              (r) => List.generate(
                                TicTacToeGameProcessCubit.colsCount,
                                (c) => GestureDetector(
                                  onTap: state.winnerSign == null ? () => _cubit.ocupyCell(col: c, row: r) : null,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            state.cells[r][c].cell.sign?.toString() ?? '',
                                            style: TextStyle(
                                              color: state.cells[r][c].order % 3 == state.nextIndex &&
                                                      state.currentSign == state.cells[r][c].cell.sign
                                                  ? Colors.amber
                                                  : Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 32,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).expand((e) => e).toList(),
                          ),
                          Positioned.fill(
                            child: AnimatedSwitcher(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              child: state.winnerSign != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.amber,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${state.winner!.name} wins'),
                                          if (widget.isHost) ...[
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            ElevatedButton(
                                              onPressed: _cubit.restart,
                                              child: const Text('Restart'),
                                            )
                                          ],
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
