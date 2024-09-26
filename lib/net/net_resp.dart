// ignore_for_file: unnecessary_overrides, prefer_initializing_formals

import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:qm_widget/pub/widget_default_builder.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

class NetResp<T> {
  static const int RESP_OK = 200;
  T? data;
  int code = -1;
  String msg = "通讯异常";
  Map<dynamic, dynamic>? originalData;
  bool Function(int code, String msg) respCheckFunc = ((c, _) => c == RESP_OK);
  bool get isOK => respCheckFunc.call(code, msg);
  String get info => "$msg {code:$code}";
  NetResp(
      {T? data,
      int code = -1,
      String msg = "network error",
      Map<dynamic, dynamic>? originalData,
      bool Function(int code, String msg)? respCheckFunc}) {
    this.data = data;
    this.code = code;
    this.msg = msg;
    this.originalData = originalData;
    if (respCheckFunc != null) this.respCheckFunc = respCheckFunc;
  }
}

enum _RespStatus { ready, loading, ok, empty, error }

class RespStatus extends Object {
  static RespStatus ready = RespStatus(_RespStatus.ready, msg: "ready");
  static RespStatus loading = RespStatus(_RespStatus.loading, msg: "loading");
  static RespStatus ok = RespStatus(_RespStatus.ok, msg: "success");
  static RespStatus empty = RespStatus(_RespStatus.empty, msg: "no data");
  static RespStatus error = RespStatus(_RespStatus.error, msg: "network error");
  final _RespStatus status;
  String msg = "";
  int code = 0;

  RespStatus(this.status, {this.msg = ""});
  @override
  operator ==(Object other) {
    if (other is RespStatus) {
      return other.status == status;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class RespProvider extends ChangeNotifier {
  RespStatus _status = RespStatus.ready;
  String _msg = "";
  int _code = 0;

  RespStatus get status => _status;
  set status(RespStatus status) {
    this._status = status;
    notifyListeners();
  }

  String get msg => _msg;
  set msg(value) => _msg = value;
  int get code => _code;
  set code(value) => _code = value;

  void commit() {
    notifyListeners();
  }
}

class RespWidget extends StatelessWidget {
  const RespWidget(this.status,
      {Key? key,
      this.sliver = false,
      this.builder,
      this.statusWidgetBuilder,
      this.onTap,
      this.statusBuilder})
      : super(key: key);
  final bool sliver;
  final Widget Function(BuildContext context)? builder;
  final RespStatus status;
  @Deprecated("use statusBuilder instead")
  final Widget? Function(RespStatus status)? statusWidgetBuilder;
  final Widget? Function(RespStatus status, void Function()? onRefresh)?
      statusBuilder;
  final void Function()? onTap;

  Widget buildStatusWidget() =>
      WidgetDefaultBuilder.statusWidgetBuilder.call(status, onTap) ??
      WidgetDefaultBuilder.respStatusWidgetBuilder.call(status) ??
      Container();
  @override
  Widget build(BuildContext context) {
    if (status == RespStatus.ok) {
      return builder?.call(context) ?? Container();
    }
    var child = statusBuilder?.call(status, onTap) ??
        statusWidgetBuilder?.call(status) ??
        buildStatusWidget();
    var finalChild = sliver ? SliverToBoxAdapter(child: child) : child;
    if (status == RespStatus.loading) {
      return finalChild;
    }
    if (onTap != null) {
      finalChild = finalChild.onClick(click: onTap!);
    }
    return finalChild;
  }
}
