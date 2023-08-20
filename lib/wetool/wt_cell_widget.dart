import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/wetool/wt_icon.dart';

import '../style/qm_color.dart';

class WTCellWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String detail;
  final bool showBottomLine;
  final Widget? right;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? rightSpan;
  const WTCellWidget(
      {Key? key,
      required this.title,
      this.subTitle = "",
      this.detail = "",
      this.showBottomLine = true,
      this.right,
      this.padding,
      this.margin,
      this.rightSpan})
      : super(key: key);

  @override
  Widget build(BuildContext context) => [
        [
          [
            title.toText(
                color: QMColor.COLOR_030319, fontSize: 16.s, height: 24 / 16),
            subTitle.isNotEmpty.toWidget(
              () => subTitle
                  .toText(
                      color: QMColor.COLOR_BDBDBD,
                      fontSize: 14.fs,
                      height: 20 / 14)
                  .applyPadding(EdgeInsets.only(top: 4.s)),
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded,
          detail.toText(
            color: QMColor.COLOR_8F92A1,
            fontSize: 14.fs,
            height: 20 / 14,
          ),
          12.s.inRow,
        ].toRow().applyBackground(
            padding: padding ?? EdgeInsets.symmetric(vertical: 16.s),
            margin: margin ?? EdgeInsets.symmetric(horizontal: 16.s),
            decoration: BoxDecoration(
              color: Colors.white,
              border: showBottomLine
                  ? Border(
                      bottom:
                          BorderSide(color: QMColor.COLOR_F2F2F2, width: 0.5.s))
                  : null,
            )),
        (right ??
                SvgPicture.string(
                  WTIcon.ARROW_RIGHT_SMALL,
                  width: 24.s,
                  height: 24.s,
                  colorFilter:
                      ColorFilter.mode(QMColor.COLOR_E0E0E0, BlendMode.srcIn),
                ))
            .toPositioned(right: rightSpan ?? 16.s, top: 0, bottom: 0)
      ].toStack();
}
