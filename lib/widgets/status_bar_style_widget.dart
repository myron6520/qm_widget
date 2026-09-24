import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 控制状态栏图标和文字颜色。
///
/// 深色背景页使用 [StatusBarStyleWidget.white]，
/// 浅色背景页使用 [StatusBarStyleWidget.black]。
class StatusBarStyleWidget extends StatelessWidget {
  final Widget child;

  /// true：白色图标和文字；false：黑色图标和文字
  final bool white;
  final Color statusBarColor;
  final Color navigationBarColor;

  const StatusBarStyleWidget({
    super.key,
    required this.child,
    this.white = false,
    this.statusBarColor = Colors.transparent,
    this.navigationBarColor = Colors.white,
  });

  /// 白色图标和文字，适合深色背景
  const StatusBarStyleWidget.white({
    super.key,
    required this.child,
    this.statusBarColor = Colors.transparent,
    this.navigationBarColor = Colors.white,
  }) : white = true;

  /// 黑色图标和文字，适合浅色背景
  const StatusBarStyleWidget.black({
    super.key,
    required this.child,
    this.statusBarColor = Colors.transparent,
    this.navigationBarColor = Colors.white,
  }) : white = false;

  static SystemUiOverlayStyle overlayStyle({
    required bool white,
    Color statusBarColor = Colors.transparent,
    Color navigationBarColor = Colors.white,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: white ? Brightness.light : Brightness.dark,
      statusBarBrightness: white ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: navigationBarColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  static void apply({
    required bool white,
    Color statusBarColor = Colors.transparent,
    Color navigationBarColor = Colors.white,
  }) {
    SystemChrome.setSystemUIOverlayStyle(overlayStyle(
      white: white,
      statusBarColor: statusBarColor,
      navigationBarColor: navigationBarColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final style = overlayStyle(
      white: white,
      statusBarColor: statusBarColor,
      navigationBarColor: navigationBarColor,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }
}
