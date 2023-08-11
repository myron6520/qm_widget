import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/widgets/qm_app_bar.dart';

class WTScaffold extends StatelessWidget {
  final Widget? body;
  final Color backgroundColor;
  final String title;
  final SystemUiOverlayStyle? systemOverlayStyle;
  const WTScaffold(
      {super.key,
      this.body,
      this.backgroundColor = QMColor.COLOR_F7F9FA,
      this.title = "",
      this.systemOverlayStyle});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: QMAppBar(
          title: title,
          systemOverlayStyle: systemOverlayStyle ??
              SystemUiOverlayStyle.dark.copyWith(
                systemNavigationBarColor: QMColor.COLOR_F7F9FA,
              ),
          backgroundColor: QMColor.COLOR_F7F9FA,
        ),
        body: body,
      );
}
