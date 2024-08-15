import 'package:bang/games/tic_tac_toe/domain/enum/tic_tac_toe_sign.dart';
import 'package:bang/games/tic_tac_toe/domain/models/tic_tac_toe_cell.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tic_tac_toe_event.freezed.dart';
part 'tic_tac_toe_event.g.dart';

@Freezed(unionKey: 'type')
class TicTacToeEvent with _$TicTacToeEvent {
  @JsonSerializable(explicitToJson: true)
  const factory TicTacToeEvent.role({
    required TicTacToeSign applyedSign,
  }) = _TicTacToeEventRole;

  @JsonSerializable(explicitToJson: true)
  const factory TicTacToeEvent.move({
    required TicTacToeCell addedCell,
    required TicTacToeCell? removedCell,
  }) = _TicTacToeEventMove;

  @JsonSerializable(explicitToJson: true)
  const factory TicTacToeEvent.finish({
    required TicTacToeSign winnerSign,
  }) = _TicTacToeEventFinish;

  @JsonSerializable(explicitToJson: true)
  const factory TicTacToeEvent.restart() = _TicTacToeEventRestart;

  factory TicTacToeEvent.fromJson(Map<String, dynamic> json) => _$TicTacToeEventFromJson(json);
}
