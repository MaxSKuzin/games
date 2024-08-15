import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_info.freezed.dart';
part 'client_info.g.dart';

@freezed
class ClientInfo with _$ClientInfo {
  const factory ClientInfo({
    required String name,
    required String ip,
  }) = _ClientInfo;

  factory ClientInfo.fromJson(Map<String, dynamic> json) =>
      _$ClientInfoFromJson(json);
}
