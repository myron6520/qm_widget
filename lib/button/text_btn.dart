// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:flutter/material.dart';

import 'base_button.dart';

class TextBtn extends StatelessWidget {
  const TextBtn(
      {Key? key,
      this.backgroundColor = Colors.transparent,
      this.highlightColor = Colors.transparent,
      this.borderRadius = 3,
      this.height = 44,
      this.width = 120,
      this.onClick,
      this.title,
      this.borderColor,
      this.alignment = Alignment.center,
      this.borderWidth = 1,
      this.textColor = const Color(0xff0E71FF),
      this.highlightTextColor = const Color(0xff8E9199),
      this.fontSize = 16,
      this.fontWeight = FontWeight.normal,
      this.padding})
      : super(key: key);
  final Color backgroundColor;
  final Color highlightColor;
  final double borderRadius;
  final AlignmentGeometry alignment;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Function()? onClick;
  final String? title;
  final Color textColor;
  final Color highlightTextColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      height: height,
      width: width,
      padding: padding,
      alignment: alignment,
      descBuilder: (state) {
        if (state == ButtonState.normal)
          return ButtonDesc(
              child: (title ?? "").toText(
                  color: textColor, fontSize: fontSize, fontWeight: fontWeight),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  border: borderColor != null
                      ? Border.all(color: borderColor!, width: borderWidth ?? 1)
                      : null,
                  borderRadius: BorderRadius.circular(borderRadius)));
        if (state == ButtonState.highlight)
          return ButtonDesc(
              child: (title ?? "").toText(
                  color: highlightTextColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight),
              decoration: BoxDecoration(
                  color: highlightColor,
                  border: borderColor != null
                      ? Border.all(color: borderColor!, width: borderWidth ?? 1)
                      : null,
                  borderRadius: BorderRadius.circular(borderRadius)));
        return null;
      },
      onClick: onClick,
    );
  }
}
