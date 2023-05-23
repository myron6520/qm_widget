import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/style/qm_icon.dart';

class QMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final SystemUiOverlayStyle systemOverlayStyle;
  final Widget? leading;
  final Color tintColor;
  final Widget? titleWidget;
  const QMAppBar(
      {Key? key,
      this.title = "",
      this.backgroundColor = QMColor.COLOR_F7F9FA,
      this.tintColor = QMColor.COLOR_030319,
      this.systemOverlayStyle = SystemUiOverlayStyle.dark,
      this.actions,
      this.titleWidget,
      this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      actions: actions,
      systemOverlayStyle: systemOverlayStyle,
      title: titleWidget ??
          title.toText(
            color: tintColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 24 / 18,
          ),
      centerTitle: true,
      leading: leading ??
          SvgPicture.string(
            QMIcon.POP,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(tintColor, BlendMode.srcIn),
          )
              .applyBackground(
            width: 44,
            height: 44,
            alignment: Alignment.center,
          )
              .onClick(click: () {
            Navigator.of(context).pop();
          }),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}