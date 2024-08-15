import 'dart:async';
import 'dart:math';

import 'package:bang/games/tic_tac_toe/domain/enum/tic_tac_toe_sign.dart';
import 'package:bang/games/tic_tac_toe/domain/models/tic_tac_toe_cell.dart';
import 'package:bang/games/tic_tac_toe/domain/models/tic_tac_toe_event.dart';
import 'package:bang/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_network_room/data/repository/client_repository.dart';
import 'package:local_network_room/domain/model/client_info/client_info.dart';
import 'package:local_network_room/domain/model/room_event/room_event.dart';

class TicTacToeGameProcessCubit extends Cubit<TicTacToeGameProcessState> {
  final ClientRepository _clientRepository;
  late final StreamSubscription _streamSubscription;

  static const rowsCount = 3;
  static const colsCount = 3;

  late int _occupiedCells;

  late List<List<({TicTacToeCell cell, int order})>> _cells;

  TicTacToeSign? _currentSign;
  late TicTacToeSign _nextSign = TicTacToeSign.cross;
  final bool isHost;

  final ClientInfo currentPlayer;
  final ClientInfo otherPlayer;

  TicTacToeGameProcessCubit({
    required this.isHost,
    required this.currentPlayer,
    required this.otherPlayer,
  })  : _clientRepository = getIt<ClientRepository>(),
        super(const TicTacToeGameProcessState$Initial()) {
    _init();
    _streamSubscription = _clientRepository.eventStream.listen(_onEvent);
  }

  late final Map<ClientInfo, int> _winsCount = {
    currentPlayer: 0,
    otherPlayer: 0,
  };

  void _init() {
    _nextSign = TicTacToeSign.cross;
    _currentSign = null;
    _cells = List.generate(
      rowsCount,
      (r) => List.generate(
        colsCount,
        (c) => (
          cell: TicTacToeCell(
            row: r,
            col: c,
            sign: null,
          ),
          order: 0,
        ),
      ),
    );
    _occupiedCells = 0;
    if (isHost) {
      _currentSign = TicTacToeSign.values[Random().nextInt(TicTacToeSign.values.length)];
      final event = TicTacToeEvent.role(
        applyedSign: _currentSign!.switchValue(),
      );
      _clientRepository.sendData(event.toJson());
    }
  }

  void restart() {
    const event = TicTacToeEvent.restart();
    _clientRepository.sendData(event.toJson());
  }

  void _onEvent(RoomEvent event) {
    if (event is RoomEvent$Closed) {
      return;
    }
    event as RoomEvent$NewData;

    final data = TicTacToeEvent.fromJson(event.data as Map<String, dynamic>);

    data.when(
      role: (role) {
        _currentSign ??= role;
        emit(
          TicTacToeGameProcessState$Game(
            cells: _cells.toList(),
            currentSign: _currentSign!,
            nextSign: _nextSign,
            winsCount: _winsCount,
            nextIndex: _occupiedCells % 3,
          ),
        );
      },
      move: _onFieldChange,
      finish: (winnerSign) {
        final ClientInfo winner;
        if (winnerSign == _currentSign) {
          _winsCount[currentPlayer] = _winsCount[currentPlayer]! + 1;
          winner = currentPlayer;
        } else {
          _winsCount[otherPlayer] = _winsCount[otherPlayer]! + 1;
          winner = otherPlayer;
        }
        emit(
          TicTacToeGameProcessState$Game(
            cells: _cells.toList(),
            currentSign: _currentSign!,
            nextSign: _nextSign,
            winnerSign: winnerSign,
            winsCount: _winsCount,
            winner: winner,
            nextIndex: _occupiedCells % 3,
          ),
        );
      },
      restart: () {
        _init();
      },
    );
  }

  void _onFieldChange(TicTacToeCell addedCell, TicTacToeCell? removedCell) {
    _cells[addedCell.row][addedCell.col] = (cell: addedCell, order: _occupiedCells % 3);
    if (addedCell.sign == _currentSign) {
      _occupiedCells++;
    }
    if (removedCell != null) {
      _cells[removedCell.row][removedCell.col] = (
        cell: TicTacToeCell(
          row: removedCell.row,
          col: removedCell.row,
          sign: null,
        ),
        order: 0,
      );
    }
    if (isHost) {
      final winnerSign = checkWinner();
      if (winnerSign != null) {
        final event = TicTacToeEvent.finish(winnerSign: winnerSign);
        _clientRepository.sendData(event.toJson());
        return;
      }
    }
    _nextSign = _nextSign.switchValue();

    emit(
      TicTacToeGameProcessState$Game(
        cells: _cells.toList(),
        currentSign: _currentSign!,
        nextSign: _nextSign,
        winsCount: _winsCount,
        nextIndex: _occupiedCells % 3,
      ),
    );
  }

  TicTacToeSign? checkWinner() {
    TicTacToeSign? winnerSign;

    bool mainDiagonalEquality = true;
    for (int i = 0; i < rowsCount - 1; i++) {
      mainDiagonalEquality = mainDiagonalEquality && _cells[i][i].cell.sign == _cells[i + 1][i + 1].cell.sign;
    }
    if (mainDiagonalEquality) {
      winnerSign = _cells[0][0].cell.sign;
    }

    if (winnerSign != null) {
      return winnerSign;
    }

    bool secondaryDiagonalEquality = true;
    for (int i = 0; i < rowsCount - 1; i++) {
      secondaryDiagonalEquality = secondaryDiagonalEquality &&
          _cells[i][colsCount - 1 - i].cell.sign == _cells[i + 1][colsCount - 2 - i].cell.sign;
    }
    if (secondaryDiagonalEquality) {
      winnerSign = _cells[0][colsCount - 1].cell.sign;
    }

    if (winnerSign != null) {
      return winnerSign;
    }

    for (int r = 0; r < rowsCount; r++) {
      bool rowEquality = true;
      for (var c = 0; c < colsCount - 1; c++) {
        rowEquality = rowEquality && _cells[r][c].cell.sign == _cells[r][c + 1].cell.sign;
      }
      if (rowEquality) {
        winnerSign = _cells[r][0].cell.sign;
        break;
      }
    }
    if (winnerSign != null) {
      return winnerSign;
    }

    for (int c = 0; c < colsCount; c++) {
      bool colEquality = true;
      for (var r = 0; r < rowsCount - 1; r++) {
        colEquality = colEquality && _cells[r][c].cell.sign == _cells[r + 1][c].cell.sign;
      }
      if (colEquality) {
        winnerSign = _cells[0][c].cell.sign;
        break;
      }
    }

    return winnerSign;
  }

  Future<void> ocupyCell({
    required int row,
    required int col,
  }) async {
    if (_currentSign == null || _currentSign != _nextSign) {
      return;
    }

    if (_cells[row][col].cell.sign != null) {
      return;
    }

    if (_occupiedCells < 3) {
      final event = TicTacToeEvent.move(
        addedCell: TicTacToeCell(
          row: row,
          col: col,
          sign: _currentSign,
        ),
        removedCell: null,
      );
      await _clientRepository.sendData(event.toJson());
    } else {
      final cellToRemoveOrder = _occupiedCells % 3;
      final cellToRemove =
          _cells.expand((e) => e).firstWhere((e) => e.cell.sign == _currentSign && e.order == cellToRemoveOrder);
      final event = TicTacToeEvent.move(
        addedCell: TicTacToeCell(
          row: row,
          col: col,
          sign: _currentSign,
        ),
        removedCell: cellToRemove.cell,
      );
      await _clientRepository.sendData(event.toJson());
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();

    return super.close();
  }
}

sealed class TicTacToeGameProcessState {
  const TicTacToeGameProcessState();
}

class TicTacToeGameProcessState$Initial extends TicTacToeGameProcessState {
  const TicTacToeGameProcessState$Initial();
}

class TicTacToeGameProcessState$Game extends TicTacToeGameProcessState {
  final List<List<({TicTacToeCell cell, int order})>> cells;
  final TicTacToeSign currentSign;
  final TicTacToeSign nextSign;
  final TicTacToeSign? winnerSign;
  final ClientInfo? winner;
  final Map<ClientInfo, int> winsCount;
  final int nextIndex;

  const TicTacToeGameProcessState$Game({
    required this.nextIndex,
    required this.cells,
    required this.currentSign,
    required this.nextSign,
    required this.winsCount,
    this.winnerSign,
    this.winner,
  });
}
