import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/wt_scaffold.dart';
import 'package:qm_widget/widgets/status_bar_style_widget.dart';

/// 顶部渐变背景包装容器
class WTGradientBackground extends StatefulWidget {
  final Widget child;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double? gradientHeight;
  final Color backgroundColor;
  final bool whiteStatus;
  final Color? navigationBarColor;

  const WTGradientBackground({
    super.key,
    required this.child,
    this.gradientStartColor = QMColor.COLOR_E3F7F3,
    this.gradientEndColor = QMColor.COLOR_F7F9FA,
    this.gradientHeight,
    this.backgroundColor = QMColor.COLOR_F7F9FA,
    this.whiteStatus = false,
    this.navigationBarColor,
  });

  @override
  State<WTGradientBackground> createState() => _WTGradientBackgroundState();
}

class _WTGradientBackgroundState extends State<WTGradientBackground> {
  Color get _navColor =>
      widget.navigationBarColor ?? widget.backgroundColor;

  @override
  void initState() {
    super.initState();
    StatusBarStyleWidget.apply(
      white: widget.whiteStatus,
      navigationBarColor: _navColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarStyleWidget(
      white: widget.whiteStatus,
      navigationBarColor: _navColor,
      child: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: widget.gradientHeight ?? 300.s,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.gradientStartColor,
                  widget.gradientEndColor,
                ],
              ),
            ),
          ),
        ),
        widget.child,
      ].toStack(fit: StackFit.expand).applyBackground(
            color: widget.backgroundColor,
          ),
    );
  }
}

/// 自带顶部渐变背景的 WeTool 页面脚手架
class WTGradientScaffold extends StatelessWidget {
  final Widget? body;
  final String title;
  final Widget? titleWidget;
  final Color tintColor;
  final List<Widget>? actions;
  final Widget? footer;
  final Color footerBackgroundColor;
  final Widget? leading;
  final void Function()? doBack;
  final Widget? endDrawer;
  final Widget? drawer;
  final bool resizeToAvoidBottomInset;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double? gradientHeight;
  final Color backgroundColor;
  final bool whiteStatus;
  final Color? navigationBarColor;

  const WTGradientScaffold({
    super.key,
    this.body,
    this.title = "",
    this.titleWidget,
    this.tintColor = QMColor.COLOR_030319,
    this.actions,
    this.footer,
    this.footerBackgroundColor = Colors.white,
    this.leading,
    this.doBack,
    this.endDrawer,
    this.drawer,
    this.resizeToAvoidBottomInset = false,
    this.gradientStartColor = QMColor.COLOR_E3F7F3,
    this.gradientEndColor = QMColor.COLOR_F7F9FA,
    this.gradientHeight,
    this.backgroundColor = QMColor.COLOR_F7F9FA,
    this.whiteStatus = false,
    this.navigationBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveNavColor = navigationBarColor ??
        (footer != null ? footerBackgroundColor : backgroundColor);

    return WTGradientBackground(
      gradientStartColor: gradientStartColor,
      gradientEndColor: gradientEndColor,
      gradientHeight: gradientHeight,
      backgroundColor: backgroundColor,
      whiteStatus: whiteStatus,
      navigationBarColor: effectiveNavColor,
      child: WTScaffold(
        title: title,
        titleWidget: titleWidget,
        tintColor: tintColor,
        actions: actions,
        leading: leading,
        doBack: doBack,
        endDrawer: endDrawer,
        drawer: drawer,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: Colors.transparent,
        appBarBackgroundColor: Colors.transparent,
        footer: footer,
        footerBackgroundColor: footerBackgroundColor,
        body: body,
      ),
    );
  }
}
