import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/wetool.dart';

import '../button/base_button.dart';
import '../button/theme_button.dart';

enum KeyboardKeyType {
  normal,
  switcher,
  confirm,
  del,
  dot,
}

enum KeyboardType {
  number,
  alphabet,
}

class WTKeyboardWidget extends StatefulWidget {
  final bool showSwitcher;
  final bool showDot;
  final KeyboardType type;
  final String? confirmTitle;
  final void Function()? onConfirm;
  final String Function(String)? willChanged;
  final bool Function(String)? onChanged;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int decimal;
  final double? maxWidth;
  final Color? backgroundColor;
  final double screenScale;
  const WTKeyboardWidget({
    Key? key,
    this.showDot = false,
    this.showSwitcher = true,
    this.type = KeyboardType.number,
    this.confirmTitle,
    this.onConfirm,
    this.controller,
    this.focusNode,
    this.willChanged,
    this.onChanged,
    this.decimal = 2,
    this.maxWidth,
    this.backgroundColor,
    this.screenScale = 1,
  }) : super(key: key);

  @override
  State<WTKeyboardWidget> createState() => _WTKeyboardWidgetState();
}

class _WTKeyboardWidgetState extends State<WTKeyboardWidget> {
  Widget buildItemContentWidget(String value, KeyboardKeyType keyType) {
    if (keyType == KeyboardKeyType.del) {
      return SvgPicture.string(
        WTIcon.KEYBOARD_DEL,
        width: 48.s * widget.screenScale,
        height: 48.s * widget.screenScale,
      );
    }
    if (keyType == KeyboardKeyType.dot) {
      return QMColor.COLOR_141615.toContainer(
        width: 8.s * widget.screenScale,
        height: 8.s * widget.screenScale,
      );
    }
    return value.toText(
      fontSize: type == KeyboardType.number
          ? 40.fs * widget.screenScale
          : 32.fs * widget.screenScale,
      fontWeight: FontWeight.w500,
      color: QMColor.COLOR_141615,
    );
  }

  Widget buildItemWidget(String value, KeyboardKeyType keyType,
          {double? width}) =>
      ThemeButton(
        childBuilder: (state) => buildItemContentWidget(value, keyType),
        height: 96.s * widget.screenScale,
        width: width,
        backgroundColor:
            (type == KeyboardType.alphabet && keyType != KeyboardKeyType.normal)
                ? QMColor.COLOR_F5F5F5
                : Colors.white,
        highlightColor: QMColor.COLOR_D7D9D8,
        borderColor: ((type == KeyboardType.alphabet &&
                    keyType != KeyboardKeyType.normal) ||
                widget.backgroundColor == Colors.white)
            ? QMColor.COLOR_D7D9D8
            : Colors.white,
        highlightBorderColor: ((type == KeyboardType.alphabet &&
                    keyType != KeyboardKeyType.normal) ||
                widget.backgroundColor == Colors.white)
            ? QMColor.COLOR_D7D9D8
            : Colors.white,
        borderRadius: 8.s * widget.screenScale,
        borderWidth: 1.s * widget.screenScale,
        padding: EdgeInsets.zero,
        onClick: () {
          onKeyClick(value, keyType);
        },
      );
  Widget buildConfirmWidget(BoxConstraints constraints) => ThemeButton(
        childBuilder: (state) => (widget.confirmTitle ?? "确定").toText(
          fontSize: 40.fs * widget.screenScale,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        backgroundColor: QMColor.COLOR_00B276,
        highlightColor: QMColor.COLOR_009764,
        disableColor: QMColor.COLOR_91DEC4,
        borderRadius: 8,
        width: (constraints.maxWidth -
                24.s * widget.screenScale * 2 -
                16.s * widget.screenScale * 3) /
            4,
        padding: EdgeInsets.zero,
        onClick: () {
          widget.onConfirm?.call();
        },
        controller: confirmController,
      );
  Widget buildLineWidget(List<List<dynamic>> datas, {double? itemWidth}) =>
      (datas
              .expand((e) => [
                    (itemWidth == null).toWidget(
                      () => buildItemWidget("${e[0]}", e[1] as KeyboardKeyType)
                          .expanded,
                      falseBuilder: () => buildItemWidget(
                          "${e[0]}", e[1] as KeyboardKeyType,
                          width: itemWidth),
                    ),
                    (16.s * widget.screenScale).inRow
                  ])
              .toList()
            ..removeLast())
          .toRow(mainAxisAlignment: MainAxisAlignment.center);
  Widget buildAlphabetWidget(BoxConstraints constraints) {
    double minWidget =
        (constraints.maxWidth - 24.s * widget.screenScale * 2 - 16 * 9) / 10;
    return [
      buildLineWidget([
        ["Q", KeyboardKeyType.normal],
        ["W", KeyboardKeyType.normal],
        ["E", KeyboardKeyType.normal],
        ["R", KeyboardKeyType.normal],
        ["T", KeyboardKeyType.normal],
        ["Y", KeyboardKeyType.normal],
        ["U", KeyboardKeyType.normal],
        ["I", KeyboardKeyType.normal],
        ["O", KeyboardKeyType.normal],
        ["P", KeyboardKeyType.normal],
      ]),
      16.inColumn,
      buildLineWidget([
        ["A", KeyboardKeyType.normal],
        ["S", KeyboardKeyType.normal],
        ["D", KeyboardKeyType.normal],
        ["F", KeyboardKeyType.normal],
        ["G", KeyboardKeyType.normal],
        ["H", KeyboardKeyType.normal],
        ["J", KeyboardKeyType.normal],
        ["K", KeyboardKeyType.normal],
        ["L", KeyboardKeyType.normal],
      ], itemWidth: minWidget),
      16.inColumn,
      buildLineWidget([
        ["123", KeyboardKeyType.switcher],
        ["Z", KeyboardKeyType.normal],
        ["X", KeyboardKeyType.normal],
        ["C", KeyboardKeyType.normal],
        ["V", KeyboardKeyType.normal],
        ["B", KeyboardKeyType.normal],
        ["N", KeyboardKeyType.normal],
        ["M", KeyboardKeyType.normal],
        ["", KeyboardKeyType.del],
      ]),
      (16.s * widget.screenScale).inColumn,
      buildConfirmWidget(constraints),
    ].toColumn();
  }

  Widget buildBottomLineWidget(BoxConstraints constraints) {
    double minWidget = (constraints.maxWidth -
            24.s * widget.screenScale * 2 -
            16.s * widget.screenScale * 3) /
        4;
    switch (type) {
      case KeyboardType.number:
        {
          if (widget.showSwitcher) {
            if (widget.showDot) {
              return buildLineWidget([
                ["abc", KeyboardKeyType.switcher],
                ["0", KeyboardKeyType.normal],
                [".", KeyboardKeyType.dot],
              ]);
            } else {
              return [
                buildItemWidget("abc", KeyboardKeyType.switcher,
                    width: minWidget),
                (16.s * widget.screenScale).inRow,
                buildItemWidget("0", KeyboardKeyType.normal).expanded,
              ].toRow();
            }
          } else {
            if (widget.showDot) {
              return [
                buildItemWidget("0", KeyboardKeyType.normal).expanded,
                (16.s * widget.screenScale).inRow,
                buildItemWidget(".", KeyboardKeyType.dot, width: minWidget)
              ].toRow();
            } else {
              return buildLineWidget([
                ["0", KeyboardKeyType.normal],
              ]);
            }
          }
        }
      case KeyboardType.alphabet:
        return buildLineWidget([
          ["0", KeyboardKeyType.normal],
        ]);
    }
  }

  Widget buildNumberWidget(BoxConstraints constraints) => [
        buildLineWidget([
          ["7", KeyboardKeyType.normal],
          ["8", KeyboardKeyType.normal],
          ["9", KeyboardKeyType.normal],
          ["", KeyboardKeyType.del]
        ]),
        (16.s * widget.screenScale).inColumn,
        IntrinsicHeight(
          child: [
            [
              buildLineWidget([
                ["4", KeyboardKeyType.normal],
                ["5", KeyboardKeyType.normal],
                ["6", KeyboardKeyType.normal],
              ]),
              (16.s * widget.screenScale).inColumn,
              buildLineWidget([
                ["1", KeyboardKeyType.normal],
                ["2", KeyboardKeyType.normal],
                ["3", KeyboardKeyType.normal],
              ]),
              (16.s * widget.screenScale).inColumn,
              buildBottomLineWidget(constraints),
            ].toColumn().expanded,
            (16.s * widget.screenScale).inRow,
            buildConfirmWidget(constraints),
          ].toRow(),
        )
      ].toColumn();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, BoxConstraints constraints) =>
            (type == KeyboardType.alphabet)
                .toWidget(() => buildAlphabetWidget(constraints),
                    falseBuilder: () => buildNumberWidget(constraints))
                .applyBackground(
                    color: widget.backgroundColor ?? QMColor.COLOR_F5F5F5,
                    padding: EdgeInsets.all(24.s * widget.screenScale)),
      );

  late KeyboardType type = widget.type;
  late TextEditingController controller =
      widget.controller ?? TextEditingController();
  bool shouldClear = true;
  late ButtonController confirmController = ButtonController(
      enable: widget.onChanged?.call(controller.text) ?? false);
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(textChanged);
  }

  void textChanged() {
    bool enable = widget.onChanged?.call(controller.text) ?? false;
    if (confirmController.enable != enable) {
      confirmController.enable = enable;
      confirmController.commit();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(textChanged);
    super.dispose();
  }

  void onKeyClick(String value, KeyboardKeyType keyType) {
    if (keyType == KeyboardKeyType.switcher) {
      if (type == KeyboardType.alphabet) {
        type = KeyboardType.number;
      } else {
        type = KeyboardType.alphabet;
      }
      setState(() {});
      return;
    }

    // widget.onKeyClick?.call(value, keyType);

    String str = controller.text;
    if (keyType == KeyboardKeyType.del) {
      if (str.isNotEmpty) {
        str = str.substring(0, str.length - 1);
        setText(str);
        return;
      }
    }
    if (shouldClear) {
      shouldClear = false;
      str = "";
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 0);
    }
    if (keyType == KeyboardKeyType.normal) {
      int index = controller.selection.baseOffset;
      if (index >= controller.text.length) {
        str = str + value;
      } else {
        String left = str.substring(0, index);
        String right = str.substring(index);
        str = left + value + right;
      }
    }
    if (keyType == KeyboardKeyType.dot) {
      if (str.contains(".")) {
        return;
      }
      str = "$str.";
    }
    if (str.startsWith(".")) {
      str = "0$str";
    }
    while (str.startsWith("00")) {
      str = str.substring(1);
    }
    int index = str.indexOf(".");
    if (index >= 0) {
      String decimal = str.substring(index);
      if (decimal.length > widget.decimal + 1) {
        String integer = str.substring(0, index);
        str = integer + decimal.substring(0, widget.decimal + 1);
      }
    } else {
      if (str.length > 1 && str.startsWith("0")) {
        str = str.substring(1);
      }
    }
    setText(str);
  }

  void setText(String str) {
    controller.text = widget.willChanged?.call(str) ?? str;
    final length = controller.text.length;
    controller.selection =
        TextSelection(baseOffset: length, extentOffset: length);
    widget.focusNode?.requestFocus();
  }
}
