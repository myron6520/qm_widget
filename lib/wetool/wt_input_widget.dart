import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/wt_icon.dart';

class WTInputWidget extends StatefulWidget {
  final String title;
  final Color titleColor;
  final Color tintColor;
  final Color textColor;
  final double? fontSize;
  final double? titleWidth;
  final Widget Function(String title)? titleBuilder;
  final String hint;
  final bool enable;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? right;
  final Widget? left;
  final Widget? clearWidget;
  final TextAlign textAlign;
  final void Function(String)? onInputChanged;
  final Color bottomBorderColor;
  final EdgeInsets? contentPadding;
  final bool showInputBottomBorder;
  final bool autofocus;
  final int lengthLimiting;
  final void Function(String)? onSubmitted;
  final bool showClearWhenNeeds;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  const WTInputWidget({
    super.key,
    this.title = "",
    this.hint = "",
    this.enable = true,
    this.controller,
    this.keyboardType,
    this.right,
    this.textAlign = TextAlign.left,
    this.onInputChanged,
    this.onSubmitted,
    this.bottomBorderColor = Colors.white,
    this.titleColor = QMColor.COLOR_030319,
    this.tintColor = QMColor.COLOR_BDBDBD,
    this.textColor = QMColor.COLOR_030319,
    this.titleWidth,
    this.contentPadding,
    this.left,
    this.clearWidget,
    this.showInputBottomBorder = true,
    this.titleBuilder,
    this.autofocus = false,
    this.obscureText = false,
    this.lengthLimiting = 0,
    this.fontSize,
    this.showClearWhenNeeds = true,
    this.inputFormatters,
    this.titleStyle,
    this.textStyle,
    this.hintStyle,
    this.focusNode,
  });

  @override
  State<WTInputWidget> createState() => _WTInputWidgetState();
}

class _WTInputWidgetState extends State<WTInputWidget> {
  Widget buildTextFiled() => TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: widget.enable,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        cursorColor: widget.textColor,
        style: widget.textStyle ??
            TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize ?? 16.fs,
            ),
        inputFormatters: widget.inputFormatters ??
            (widget.lengthLimiting > 0
                ? [
                    LengthLimitingTextInputFormatter(widget.lengthLimiting),
                  ]
                : null),
        textAlign: widget.textAlign,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: widget.contentPadding ?? EdgeInsets.zero,
          isDense: true,
          isCollapsed: true,
          hintText: widget.hint,
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: widget.tintColor,
                fontSize: widget.fontSize ?? 16.s,
              ),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (_) {
          widget.onInputChanged?.call(_);
          setState(() {});
        },
        onSubmitted: (str) => widget.onSubmitted?.call(str),
      ).expanded;
  @override
  Widget build(BuildContext context) {
    return [
      widget.title.isNotEmpty.toWidget(
        () =>
            widget.titleBuilder?.call(widget.title) ??
            widget.title
                .toText(
                  color: widget.titleColor,
                  fontSize: 16.fs,
                  height: 24 / 16,
                  style: widget.titleStyle,
                )
                .applyBackground(
                  width: widget.titleWidth ?? 88.s,
                  margin: EdgeInsets.only(right: 12.s),
                ),
      ),
      [
        [
          widget.left ?? Container(),
          buildTextFiled(),
          (widget.showClearWhenNeeds && controller.text.isNotEmpty && widget.enable && focusNode.hasFocus).toWidget(
            () => (widget.clearWidget ??
                    SvgPicture.string(
                      WTIcon.INPUT_CLEAR,
                      width: 24.s,
                      height: 24.s,
                    ))
                .onClick(
              click: () {
                controller.clear();
                widget.onInputChanged?.call("");
                setState(() {});
              },
            ),
          ),
        ].toRow().expanded
      ]
          .toRow()
          .applyBackground(
            decoration: BoxDecoration(
              border: widget.showInputBottomBorder ? Border(bottom: BorderSide(color: bottomBorderColor, width: 1.s)) : null,
            ),
          )
          .expanded,
      widget.right ?? Container(),
    ].toRow();
  }

  late TextEditingController controller = widget.controller ?? TextEditingController();
  late FocusNode focusNode = widget.focusNode ?? FocusNode();
  Color get bottomBorderColor => focusNode.hasFocus ? QMColor.COLOR_00B276 : widget.bottomBorderColor;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onInputStateChange);
  }

  void onInputStateChange() {
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.removeListener(onInputStateChange);
    super.dispose();
  }
}
