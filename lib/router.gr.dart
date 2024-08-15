// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:bang/games/tic_tac_toe/presentation/tic_tac_toe_game_screen.dart'
    as _i8;
import 'package:bang/presentation/connect_to_room/connect_to_room_flow.dart'
    as _i1;
import 'package:bang/presentation/connect_to_room/game_start_pending_screen.dart'
    as _i4;
import 'package:bang/presentation/connect_to_room/server_list_screen.dart'
    as _i5;
import 'package:bang/presentation/create_room/create_room_flow.dart' as _i2;
import 'package:bang/presentation/create_room/create_room_screen.dart' as _i3;
import 'package:bang/presentation/create_room/start_game_screen.dart' as _i6;
import 'package:bang/presentation/start_screen/start_screen.dart' as _i7;
import 'package:flutter/material.dart' as _i10;
import 'package:local_network_room/domain/model/client_info/client_info.dart'
    as _i12;
import 'package:local_network_room/local_network_room.dart' as _i11;

/// generated route for
/// [_i1.ConnectToRoomFlow]
class ConnectToRoomFlow extends _i9.PageRouteInfo<void> {
  const ConnectToRoomFlow({List<_i9.PageRouteInfo>? children})
      : super(
          ConnectToRoomFlow.name,
          initialChildren: children,
        );

  static const String name = 'ConnectToRoomFlow';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.ConnectToRoomFlow();
    },
  );
}

/// generated route for
/// [_i2.CreateRoomFlow]
class CreateRoomFlow extends _i9.PageRouteInfo<void> {
  const CreateRoomFlow({List<_i9.PageRouteInfo>? children})
      : super(
          CreateRoomFlow.name,
          initialChildren: children,
        );

  static const String name = 'CreateRoomFlow';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateRoomFlow();
    },
  );
}

/// generated route for
/// [_i3.CreateRoomScreen]
class CreateRoomRoute extends _i9.PageRouteInfo<void> {
  const CreateRoomRoute({List<_i9.PageRouteInfo>? children})
      : super(
          CreateRoomRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateRoomRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.CreateRoomScreen();
    },
  );
}

/// generated route for
/// [_i4.GameStartPendingScreen]
class GameStartPendingRoute
    extends _i9.PageRouteInfo<GameStartPendingRouteArgs> {
  GameStartPendingRoute({
    _i10.Key? key,
    required _i11.ClientInfo clientInfo,
    required _i11.ServerInfo server,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          GameStartPendingRoute.name,
          args: GameStartPendingRouteArgs(
            key: key,
            clientInfo: clientInfo,
            server: server,
          ),
          initialChildren: children,
        );

  static const String name = 'GameStartPendingRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameStartPendingRouteArgs>();
      return _i4.GameStartPendingScreen(
        key: args.key,
        clientInfo: args.clientInfo,
        server: args.server,
      );
    },
  );
}

class GameStartPendingRouteArgs {
  const GameStartPendingRouteArgs({
    this.key,
    required this.clientInfo,
    required this.server,
  });

  final _i10.Key? key;

  final _i11.ClientInfo clientInfo;

  final _i11.ServerInfo server;

  @override
  String toString() {
    return 'GameStartPendingRouteArgs{key: $key, clientInfo: $clientInfo, server: $server}';
  }
}

/// generated route for
/// [_i5.ServerListScreen]
class ServerListRoute extends _i9.PageRouteInfo<void> {
  const ServerListRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ServerListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServerListRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i5.ServerListScreen();
    },
  );
}

/// generated route for
/// [_i6.StartGameScreen]
class StartGameRoute extends _i9.PageRouteInfo<void> {
  const StartGameRoute({List<_i9.PageRouteInfo>? children})
      : super(
          StartGameRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartGameRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.StartGameScreen();
    },
  );
}

/// generated route for
/// [_i7.StartScreen]
class StartRoute extends _i9.PageRouteInfo<void> {
  const StartRoute({List<_i9.PageRouteInfo>? children})
      : super(
          StartRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.StartScreen();
    },
  );
}

/// generated route for
/// [_i8.TicTacToeGameScreen]
class TicTacToeGameRoute extends _i9.PageRouteInfo<TicTacToeGameRouteArgs> {
  TicTacToeGameRoute({
    _i10.Key? key,
    required _i12.ClientInfo currentPlayer,
    required _i12.ClientInfo otherPlayer,
    required bool isHost,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          TicTacToeGameRoute.name,
          args: TicTacToeGameRouteArgs(
            key: key,
            currentPlayer: currentPlayer,
            otherPlayer: otherPlayer,
            isHost: isHost,
          ),
          initialChildren: children,
        );

  static const String name = 'TicTacToeGameRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TicTacToeGameRouteArgs>();
      return _i8.TicTacToeGameScreen(
        key: args.key,
        currentPlayer: args.currentPlayer,
        otherPlayer: args.otherPlayer,
        isHost: args.isHost,
      );
    },
  );
}

class TicTacToeGameRouteArgs {
  const TicTacToeGameRouteArgs({
    this.key,
    required this.currentPlayer,
    required this.otherPlayer,
    required this.isHost,
  });

  final _i10.Key? key;

  final _i12.ClientInfo currentPlayer;

  final _i12.ClientInfo otherPlayer;

  final bool isHost;

  @override
  String toString() {
    return 'TicTacToeGameRouteArgs{key: $key, currentPlayer: $currentPlayer, otherPlayer: $otherPlayer, isHost: $isHost}';
  }
}
