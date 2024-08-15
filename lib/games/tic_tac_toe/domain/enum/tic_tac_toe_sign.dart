enum TicTacToeSign {
  cross,
  zero;

  TicTacToeSign switchValue() => switch (this) {
        cross => zero,
        zero => cross,
      };

  @override
  String toString() => switch (this) {
        cross => 'x',
        zero => 'o',
      };
}
