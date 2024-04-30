import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Widget? leftDrawable;
  final Widget? topDrawable;
  final Widget? rightDrawable;
  final Widget? bottomDrawable;
  final EdgeInsets leftDrawablePadding;
  final EdgeInsets topDrawablePadding;
  final EdgeInsets rightDrawablePadding;
  final EdgeInsets bottomDrawablePadding;
  final Color? color;
  final double? fontSize;
  final double? height;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextStyle? style;
  final Widget? Function(Widget text)? textBuilder;
  const TextWidget({
    super.key,
    required this.text,
    this.leftDrawable,
    this.topDrawable,
    this.rightDrawable,
    this.bottomDrawable,
    this.leftDrawablePadding = EdgeInsets.zero,
    this.topDrawablePadding = EdgeInsets.zero,
    this.rightDrawablePadding = EdgeInsets.zero,
    this.bottomDrawablePadding = EdgeInsets.zero,
    this.color,
    this.fontSize,
    this.height,
    this.textAlign,
    this.decoration,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontFamily,
    this.style,
    this.textBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = text.toText(
      color: color ?? QMColor.COLOR_030319,
      fontSize: fontSize ?? 16.fs,
      fontFamily: fontFamily,
      height: height,
      textAlign: textAlign,
      decoration: decoration,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      fontWeight: fontWeight ?? FontWeight.normal,
      style: style,
    );
    return [
      (topDrawable != null).toWidget(() => topDrawable!.applyPadding(topDrawablePadding)),
      [
        (leftDrawable != null).toWidget(() => leftDrawable!.applyPadding(leftDrawablePadding)),
        textBuilder?.call(textWidget) ?? textWidget,
        (rightDrawable != null).toWidget(() => rightDrawable!.applyPadding(rightDrawablePadding)),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      (bottomDrawable != null).toWidget(() => bottomDrawable!.applyPadding(bottomDrawablePadding)),
    ].toColumn(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center);
  }
}

extension TextWidgetEx on String {
  TextWidget toTextWidget({
    Key? key,
    Color? color,
    double? fontSize,
    double? height,
    TextAlign? textAlign,
    double? textScaleFactor,
    TextDecoration? decoration,
    int? maxLines,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    String? fontFamily,
    TextStyle? style,
    Widget? leftDrawable,
    Widget? topDrawable,
    Widget? rightDrawable,
    Widget? bottomDrawable,
    EdgeInsets leftDrawablePadding = EdgeInsets.zero,
    EdgeInsets topDrawablePadding = EdgeInsets.zero,
    EdgeInsets rightDrawablePadding = EdgeInsets.zero,
    EdgeInsets bottomDrawablePadding = EdgeInsets.zero,
    Widget? Function(Widget text)? textBuilder,
  }) =>
      TextWidget(
        text: this,
        key: key,
        color: color,
        fontSize: fontSize,
        height: height,
        textAlign: textAlign,
        decoration: decoration,
        maxLines: maxLines,
        overflow: overflow,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        style: style,
        leftDrawable: leftDrawable,
        topDrawable: topDrawable,
        rightDrawable: rightDrawable,
        bottomDrawable: bottomDrawable,
        leftDrawablePadding: leftDrawablePadding,
        topDrawablePadding: topDrawablePadding,
        rightDrawablePadding: rightDrawablePadding,
        bottomDrawablePadding: rightDrawablePadding,
        textBuilder: textBuilder,
      );
}
