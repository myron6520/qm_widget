import 'package:flutter/material.dart';

enum ButtonState { normal, highlight, selected, disable }

class ButtonDesc {
  final Widget? child;
  final Widget? left;
  final Widget? top;
  final Widget? right;
  final Widget? bottom;
  final Decoration? decoration;
  final Widget? Function(String? title)? childBuilder;

  ButtonDesc(
      {this.child,
      this.left,
      this.top,
      this.right,
      this.bottom,
      this.childBuilder,
      this.decoration});
  static ButtonDesc get normal => ButtonDesc(
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(5))));
}

class ButtonController extends ChangeNotifier {
  ButtonController(
      {Key? key, this.selected = false, this.enable = true, this.title})
      : super();
  bool selected = false;
  bool enable = true;
  String? title;
  void commit() {
    notifyListeners();
  }
}

class BaseButton extends StatefulWidget {
  BaseButton(
      {Key? key,
      required this.descBuilder,
      this.height,
      this.width,
      this.alignment = Alignment.center,
      this.controller,
      this.onClick,
      this.shouldChangeSelect,
      this.padding})
      : super(key: key);
  final ButtonDesc? Function(ButtonState state) descBuilder;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  final ButtonController? controller;
  final Function()? onClick;
  final bool Function(bool selected)? shouldChangeSelect;

  @override
  _BaseButtonState createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  @override
  Widget build(BuildContext context) {
    ButtonDesc? desc = widget.descBuilder.call(state);
    if (state == ButtonState.highlight) {
      desc = desc ?? currentDesc;
    } else {
      desc = desc ?? normalDesc;
    }
    currentDesc = desc;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: widget.padding,
        alignment: widget.alignment,
        decoration: currentDesc.decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            currentDesc.left ?? Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                currentDesc.top ?? Container(),
                currentDesc.childBuilder?.call(controller.title) ??
                    currentDesc.child ??
                    Container(),
                currentDesc.bottom ?? Container(),
              ],
            ),
            currentDesc.right ?? Container(),
          ],
        ),
      ),
      onTapDown: (_) {
        if (!controller.enable) return;
        state = ButtonState.highlight;
        refWidget();
      },
      onTapUp: (_) {
        if (!controller.enable) return;
        if (widget.shouldChangeSelect?.call(controller.selected) ?? true) {
          controller.selected = !controller.selected;
        }
        state = controller.selected ? ButtonState.selected : ButtonState.normal;
        refWidget();
        widget.onClick?.call();
      },
      onTapCancel: () {
        if (!controller.enable) return;
        state = controller.selected ? ButtonState.selected : ButtonState.normal;
        refWidget();
      },
    );
  }

  ButtonState state = ButtonState.normal;
  late ButtonController controller;
  ButtonDesc get normalDesc =>
      widget.descBuilder.call(ButtonState.normal) ?? ButtonDesc.normal;
  late ButtonDesc currentDesc;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ButtonController();
    controller.addListener(controllValueChanged);
    currentDesc = normalDesc;
    checkState();
  }

  @override
  void dispose() {
    controller.removeListener(controllValueChanged);
    super.dispose();
  }

  void refWidget() {
    setState(() {});
  }

  void checkState() {
    if (controller.enable) {
      if (controller.selected) {
        state = ButtonState.selected;
      } else {
        state = ButtonState.normal;
      }
    } else {
      state = ButtonState.disable;
    }
  }

  void controllValueChanged() {
    checkState();
    refWidget();
  }
}
