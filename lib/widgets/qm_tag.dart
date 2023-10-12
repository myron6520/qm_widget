import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/qm_widget.dart';

class QMTagStyle {
  Color? fillColor;
  Color? borderColor;
  double? borderWidth;
  EdgeInsets? contentPadding;
  double? borderRadius;

  QMTagStyle({
    this.fillColor,
    this.borderColor,
    this.borderWidth,
    this.contentPadding,
    this.borderRadius,
  });
  QMTagStyle.filled(
    this.fillColor, {
    this.contentPadding,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.borderRadius = 2,
  });
  QMTagStyle.border(
    this.borderColor, {
    this.contentPadding,
    this.fillColor = Colors.transparent,
    this.borderWidth = 1,
    this.borderRadius = 2,
  });
}

class QMTag extends StatelessWidget {
  final String tag;
  final Color textColor;
  final double fontSize;
  final String? fontFamily;
  final double textHeight;
  final FontWeight fontWeight;
  final QMTagStyle? tagStyle;
  const QMTag(
      {super.key,
      required this.tag,
      this.textColor = Colors.white,
      this.fontSize = 10,
      this.textHeight = 1.3,
      this.fontFamily,
      this.fontWeight = FontWeight.normal,
      this.tagStyle});

  @override
  Widget build(BuildContext context) {
    return tag
        .toText(
          color: textColor,
          fontSize: fontSize,
          height: textHeight,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
        )
        .applyBackground(
          padding: tagStyle?.contentPadding ??
              EdgeInsets.symmetric(horizontal: 4.s, vertical: 2.s),
          decoration: BoxDecoration(
            color: tagStyle?.fillColor ?? QMColor.COLOR_FF3F3F,
            borderRadius: BorderRadius.circular(tagStyle?.borderRadius ?? 2.s),
            border: Border.all(
                color: tagStyle?.borderColor ?? Colors.transparent,
                width: tagStyle?.borderWidth ?? 1.s),
          ),
        );
  }
}
