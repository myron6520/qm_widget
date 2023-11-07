// ignore_for_file: prefer_const_constructors_in_immutables, camel_case_extensions, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

import '../style/qm_color.dart';

class TapWidget extends StatefulWidget {
  final Widget child;
  final Color normalColor;
  final Color highlightColor;
  final void Function()? onClick;
  TapWidget({
    Key? key,
    required this.child,
    this.normalColor = Colors.white,
    this.highlightColor = QMColor.COLOR_F8FAF9,
    this.onClick,
  }) : super(key: key);

  @override
  State<TapWidget> createState() => _TapWidgetState();
}

class _TapWidgetState extends State<TapWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child.applyBackground(
        color: highlight ? widget.highlightColor : widget.normalColor,
      ),
      onTapUp: (_) {
        highlight = false;
        setState(() {});
        widget.onClick?.call();
      },
      onTapDown: (_) {
        highlight = true;
        setState(() {});
      },
      onTapCancel: () {
        highlight = false;
        setState(() {});
      },
    );
  }

  bool highlight = false;
}

extension tapWidgetExOnWidget on Widget {
  TapWidget applyTapWidget({
    Color normalColor = Colors.white,
    Color highlightColor = QMColor.COLOR_F8FAF9,
    void Function()? onClick,
  }) =>
      TapWidget(
        child: this,
        normalColor: normalColor,
        highlightColor: highlightColor,
        onClick: onClick,
      );
}
