import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

/*
* double top = (filterKey.currentContext?.findRenderObject() as RenderBox)
            ?.localToGlobal(Offset.zero)
            ?.dy ??
        0;
    MaskWidget.show
    * */
class MaskWidget extends StatelessWidget {
  const MaskWidget(
      {Key? key,
      this.childBuilder,
      this.barrierColor,
      this.margin = EdgeInsets.zero,
      this.padding = EdgeInsets.zero,
      this.barrierDismissible = true})
      : super(key: key);
  final bool barrierDismissible;
  final Widget Function()? childBuilder;
  final Color? barrierColor;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width - margin.left - margin.right;
    double h = MediaQuery.of(context).size.height - margin.top - margin.bottom;
    return Container(
            margin: margin,
            padding: padding,
            color: barrierColor ?? Colors.black.applyOpacity(0.4),
            height: h,
            width: w,
            alignment: Alignment.topCenter,
            child: childBuilder?.call() ?? Container())
        .onClick(click: () {
      if (barrierDismissible) Navigator.of(context).pop();
    }).applyUnconstrainedBox();
  }

  static Future<T?> show<T>(
    BuildContext context,
    Widget Function() childBuilder, {
    bool barrierDismissible = true,
    Color? barrierColor,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) => MaskWidget(
        padding: padding,
        margin: margin,
        barrierDismissible: barrierDismissible,
        childBuilder: childBuilder,
        barrierColor: barrierColor,
      ),
    );
  }

  static Future<T?> showWidget<T>(
    BuildContext context,
    Widget Function() childBuilder, {
    bool barrierDismissible = true,
    Color? barrierColor,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) => MaskWidget(
        margin: margin,
        padding: padding,
        barrierDismissible: barrierDismissible,
        childBuilder: childBuilder,
        barrierColor: barrierColor,
      ),
    );
  }
}
