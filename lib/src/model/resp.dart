import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

abstract class BaseResp {
  const BaseResp({
    required this.ret,
    this.msg,
  });

  /// 网络请求成功发送至服务器，并且服务器返回数据格式正确
  /// 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
  static const int RET_SUCCESS = 0;

  /// 网络异常，或服务器返回的数据格式不正确导致无法解析
  static const int RET_FAILED = 1;

  static const int RET_COMMON = -1;

  static const int RET_USERCANCEL = -2;

  @JsonKey(
    defaultValue: RET_SUCCESS,
  )
  final int ret;
  final String? msg;

  bool get isSuccessful => ret == RET_SUCCESS;

  bool get isCancelled => ret == RET_USERCANCEL;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class LoginResp extends BaseResp {
  const LoginResp({
    required int ret,
    String? msg,
    this.openid,
    this.accessToken,
    this.expiresIn,
    this.createAt,
  }) : super(ret: ret, msg: msg);

  factory LoginResp.fromJson(Map<String, dynamic> json) =>
      _$LoginRespFromJson(json);

  final String? openid;
  final String? accessToken;
  final int? expiresIn;
  final int? createAt;

  bool? get isExpired => isSuccessful
      ? DateTime.now().millisecondsSinceEpoch - createAt! >= expiresIn! * 1000
      : null;

  @override
  Map<String, dynamic> toJson() => _$LoginRespToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class ShareMsgResp extends BaseResp {
  const ShareMsgResp({
    required int ret,
    String? msg,
  }) : super(
          ret: ret,
          msg: msg,
        );

  factory ShareMsgResp.fromJson(Map<String, dynamic> json) =>
      _$ShareMsgRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShareMsgRespToJson(this);
}
