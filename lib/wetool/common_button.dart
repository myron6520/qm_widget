import 'package:flutter/material.dart';
import 'package:qm_widget/qm_widget.dart';
import './common_text_widget.dart';

class CommonButton extends StatefulWidget {
  final double? width;
  final double? height;
  final double? textHeight;

  final Color textColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final String text;
  final VoidCallback? pressed; //点击事件
  // final double margin;
  final double? radius;
  final Color bgColor;
  final BorderSide? border;

  const CommonButton(
      {Key? key,
      this.width,
      this.height,
      this.textColor = Colors.white,
      this.text = "",
      this.pressed,
      this.radius,
      this.bgColor = QMColor.COLOR_00B276,
      this.fontSize,
      this.fontWeight = FontWeight.w600,
      this.textHeight,
      this.border})
      : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? double.maxFinite,
        height: widget.height,
        constraints: BoxConstraints(minHeight: 44.s),
        child: ElevatedButton(
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: widget.border ?? BorderSide.none,
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.radius ?? 6.s)),
            ),
            backgroundColor: widget.bgColor,
            elevation: 0,
          ),

          child: CommonTextWidget.text(widget.text,
              color: widget.textColor,
              size: widget.fontSize ?? 16.fs,
              h: widget.textHeight ?? 1.4,
              weight: widget.fontWeight),
          onPressed: widget.pressed,
        ));
  }
}
