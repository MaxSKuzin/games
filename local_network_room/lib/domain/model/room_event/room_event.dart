sealed class RoomEvent {
  const RoomEvent();
}

class RoomEvent$Closed extends RoomEvent {
  const RoomEvent$Closed();

  @override
  String toString() => 'RoomEvent\$Closed()';
}

class RoomEvent$NewData extends RoomEvent {
  final Object data;

  RoomEvent$NewData({required this.data});

  @override
  String toString() => 'RoomEvent\$NewData(data: $data)';
}
