import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/wetool.dart';
import 'package:qm_widget/wetool/wt_icon.dart';
import 'package:qm_widget/wetool/wt_keyboard_widget.dart';

class WTStepper extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;
  const WTStepper({
    super.key,
    this.value = 1,
    this.min = 1,
    this.max = 99,
    this.onChanged,
  });

  @override
  State<WTStepper> createState() => _WTStepperState();
}

class _WTStepperState extends State<WTStepper> {
  late int value = widget.value.clamp(widget.min, widget.max);
  late final TextEditingController controller =
      TextEditingController(text: "$value");

  @override
  void initState() {
    super.initState();
    controller.addListener(_onInputChanged);
  }

  @override
  void didUpdateWidget(covariant WTStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max) {
      value = widget.value.clamp(widget.min, widget.max);
      if (controller.text != "$value") {
        controller.text = "$value";
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onInputChanged);
    controller.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return [
      _buildHandle(
        icon: WTIcon.STEPPER_SUBTRACT,
        enabled: value > widget.min,
        onClick: () => _setValue(value - 1),
      ),
      _buildInput(),
      _buildHandle(
        icon: WTIcon.STEPPER_ADD,
        enabled: value < widget.max,
        onClick: () => _setValue(value + 1),
      ),
    ].toRow(mainAxisSize: MainAxisSize.min);
  }

  Widget _buildHandle({
    required String icon,
    required bool enabled,
    required VoidCallback onClick,
  }) {
    Widget child = SvgPicture.string(
      icon,
      width: 24.s,
      height: 24.s,
      colorFilter: ColorFilter.mode(
        QMColor.COLOR_141615,
        BlendMode.srcIn,
      ),
    )
        .applyUnconstrainedBox()
        .applyOpacity(enabled ? 1 : 0.3)
        .applyPadding(EdgeInsets.all(8.s));
    if (!enabled) return child;
    return child.onClick(click: onClick);
  }

  Widget _buildInput() => controller.text
      .toText(
        fontSize: 16.fs,
        fontWeight: FontWeight.w500,
        color: QMColor.COLOR_141615,
        height: 24 / 16,
        textAlign: TextAlign.center,
      )
      .applyBackground(
        constraints: BoxConstraints(minWidth: 20.s),
        alignment: Alignment.center,
      )
      .applyBackground(
        height: 24.s,
        padding: EdgeInsets.symmetric(horizontal: 8.s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: QMColor.COLOR_EBEDEC,
          borderRadius: BorderRadius.circular(2.s),
        ),
      )
      .applyUnconstrainedBox()
      .applyBackground(
        constraints: BoxConstraints(minWidth: 44.s, minHeight: 44.s),
        alignment: Alignment.center,
      )
      .onClick(click: _showKeyboard);

  void _setValue(int next) {
    final int v = next.clamp(widget.min, widget.max);
    if (controller.text != "$v") {
      controller.text = "$v";
    }
    if (v == value) return;
    value = v;
    setState(() {});
    widget.onChanged?.call(v);
  }

  void _showKeyboard() {
    final int origin = value;
    controller.text = "$value";
    bool confirmed = false;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WTBottomSheetContailer(
        child: WTKeyboardWidget(
          controller: controller,
          showSwitcher: false,
          screenScale: 0.5,
          showDot: false,
          type: KeyboardType.number,
          onChanged: (str) {
            final int? v = int.tryParse(str);
            return v != null && v >= widget.min && v <= widget.max;
          },
          willChanged: (str) {
            if (str.isEmpty) return str;
            final int? v = int.tryParse(str);
            if (v == null || v > widget.max) return controller.text;
            return str;
          },
          onConfirm: () {
            confirmed = true;
            final int? v = int.tryParse(controller.text);
            if (v != null) _setValue(v);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    ).whenComplete(() {
      if (!confirmed) {
        controller.text = "$origin";
      }
    });
  }
}
