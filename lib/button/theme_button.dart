// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

import 'base_button.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton(
      {Key? key,
      this.backgroundColor = Colors.white,
      this.highlightColor = const Color(0xffE5E5E5),
      this.disableColor = const Color(0xffE5E5E5),
      this.borderColor,
      this.highlightBorderColor,
      this.disableBorderColor,
      this.borderRadius = 3,
      this.borderWidth = 1,
      this.height,
      this.width,
      required this.childBuilder,
      this.onClick,
      this.controller,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      this.normalDecoration,
      this.highlightDecoration})
      : super(key: key);
  final Color backgroundColor;
  final Color highlightColor;
  final Decoration? normalDecoration;
  final Decoration? highlightDecoration;
  final Color disableColor;
  final Color? borderColor;
  final Color? highlightBorderColor;
  final Color? disableBorderColor;
  final double borderWidth;
  final double borderRadius;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Widget Function(ButtonState state) childBuilder;
  final Function()? onClick;
  final ButtonController? controller;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      height: height,
      width: width,
      controller: controller,
      padding: padding,
      descBuilder: (state) {
        if (state == ButtonState.normal)
          return ButtonDesc(
              child: childBuilder.call(state),
              decoration: normalDecoration ??
                  BoxDecoration(
                      color: backgroundColor,
                      border: borderColor == null
                          ? null
                          : Border.all(color: borderColor!, width: borderWidth),
                      borderRadius: BorderRadius.circular(borderRadius)));
        if (state == ButtonState.highlight)
          return ButtonDesc(
              child: childBuilder.call(state),
              decoration: highlightDecoration ??
                  BoxDecoration(
                      color: highlightColor,
                      border: highlightBorderColor == null
                          ? null
                          : Border.all(
                              color: highlightBorderColor!, width: borderWidth),
                      borderRadius: BorderRadius.circular(borderRadius)));
        if (state == ButtonState.disable)
          return ButtonDesc(
              child: childBuilder.call(state),
              decoration: BoxDecoration(
                  color: disableColor,
                  border: disableBorderColor == null
                      ? null
                      : Border.all(
                          color: disableBorderColor!, width: borderWidth),
                  borderRadius: BorderRadius.circular(borderRadius)));
        return null;
      },
      onClick: onClick,
    );
  }
}
