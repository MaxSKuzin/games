import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_network_room/domain/model/client_info/client_info.dart';

part 'server_info.freezed.dart';
part 'server_info.g.dart';

@freezed
class ServerInfo with _$ServerInfo {
  @JsonSerializable(explicitToJson: true)
  const factory ServerInfo({
    required String ip,
    required String name,
    required List<ClientInfo> players,
  }) = _ServerInfo;

  factory ServerInfo.fromJson(Map<String, dynamic> json) => _$ServerInfoFromJson(json);
}
