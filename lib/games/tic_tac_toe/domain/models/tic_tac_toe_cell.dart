import 'package:bang/games/tic_tac_toe/domain/enum/tic_tac_toe_sign.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tic_tac_toe_cell.g.dart';

@JsonSerializable(explicitToJson: true)
class TicTacToeCell {
  final int row;
  final int col;
  final TicTacToeSign? sign;

  const TicTacToeCell({
    required this.row,
    required this.col,
    required this.sign,
  });

  bool get isOcupied => sign != null;

  bool equalsCell(TicTacToeCell other) => other.row == row && other.col == col;

  factory TicTacToeCell.fromJson(Map<String, dynamic> json) => _$TicTacToeCellFromJson(json);

  Map<String, dynamic> toJson() => _$TicTacToeCellToJson(this);
}
