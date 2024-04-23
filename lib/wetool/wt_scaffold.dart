import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/widgets/qm_app_bar.dart';

class WTScaffold extends StatelessWidget {
  final Widget? body;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final String title;
  final Color tintColor;
  final Widget? titleWidget;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final List<Widget>? actions;
  final Widget? footer;
  final Color footerBackgroundColor;
  final Widget? leading;
  const WTScaffold({
    super.key,
    this.body,
    this.backgroundColor = QMColor.COLOR_F7F9FA,
    this.tintColor = QMColor.COLOR_030319,
    this.title = "",
    this.systemOverlayStyle,
    this.actions,
    this.appBarBackgroundColor = QMColor.COLOR_F7F9FA,
    this.footer,
    this.footerBackgroundColor = Colors.white,
    this.leading,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: QMAppBar(
          titleWidget: titleWidget,
          title: title,
          tintColor: tintColor,
          leading: leading,
          systemOverlayStyle: systemOverlayStyle ??
              SystemUiOverlayStyle.dark.copyWith(
                systemNavigationBarColor: backgroundColor,
              ),
          backgroundColor: appBarBackgroundColor,
          actions: actions,
        ),
        body: [
          (body ?? Container()).expanded,
          (footer != null).toWidget(() => footer!.toSafe().applyBackground(
                padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 8.s),
                color: footerBackgroundColor,
              ))
        ].toColumn(),
      );
}
