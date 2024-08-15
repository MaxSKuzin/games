import 'package:auto_route/auto_route.dart';
import 'package:bang/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:local_network_room/local_network_room.dart';

@RoutePage()
class GameStartPendingScreen extends StatefulWidget {
  final ServerInfo server;
  final ClientInfo clientInfo;

  const GameStartPendingScreen({
    super.key,
    required this.clientInfo,
    required this.server,
  });

  @override
  State<GameStartPendingScreen> createState() => _GameStartPendingScreenState();
}

class _GameStartPendingScreenState extends State<GameStartPendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: context.maybePop,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Connected to ${widget.server.name}',
          ),
          ElevatedButton(
            onPressed: () {
              context.replaceRoute(
                TicTacToeGameRoute(
                  isHost: false,
                  currentPlayer: widget.clientInfo,
                  otherPlayer: widget.server.players.firstWhere((e) => e.ip == widget.server.ip),
                ),
              );
            },
            child: const Text('Start game'),
          ),
        ],
      ),
    );
  }
}
