// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/net/net_resp.dart';

typedef RespStatusWidgetBuilder = Widget? Function(RespStatus status);

class WidgetDefaultBuilder {
  static String _respStatusDesc(RespStatus status) => status.msg;

  @Deprecated("use statusWidgetBuilder instead")
  static RespStatusWidgetBuilder respStatusWidgetBuilder = (status) =>
      _respStatusDesc(status).toText(color: Color(0xff666666), fontSize: 13);
  static Widget? Function(RespStatus status, void Function()? onRefresh)
      statusWidgetBuilder = (status, void Function()? onRefresh) =>
          _respStatusDesc(status)
              .toText(color: Color(0xff666666), fontSize: 13)
              .onTouch(onTap: () => onRefresh?.call());
}
