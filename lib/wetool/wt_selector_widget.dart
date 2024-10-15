import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/wetool/wt_icon.dart';

import '../style/qm_color.dart';

class WTSelectorWidget extends StatelessWidget {
  final int length;
  final String Function(int)? getTitleFunc;
  final bool Function(int)? getIsSelectedFunc;
  final void Function(int)? onSelected;
  const WTSelectorWidget({
    super.key,
    required this.length,
    this.getTitleFunc,
    this.getIsSelectedFunc,
    this.onSelected,
  });
  Widget _buildItemWidget(int index, BuildContext context) => [
        (getTitleFunc?.call(index) ?? "")
            .toText(
              color: QMColor.COLOR_030319,
              fontSize: 16.fs,
              height: 24 / 16,
            )
            .expanded,
        (getIsSelectedFunc?.call(index) ?? false)
            .toWidget(() => SvgPicture.string(
                  WTIcon.CHECKED_ROUND,
                  width: 20.s,
                  height: 20.s,
                )),
      ]
          .toRow()
          .applyPadding(EdgeInsets.symmetric(horizontal: 24.s, vertical: 16.s))
          .onClick(click: () {
        Navigator.of(context).pop();
        onSelected?.call(index);
      });

  @override
  Widget build(BuildContext context) {
    return (List.generate(length, (index) => _buildItemWidget(index, context))
            .expand((e) => [
                  e,
                  QMColor.COLOR_F7F9FA
                      .toContainer(height: 1.s)
                      .applyPadding(EdgeInsets.symmetric(horizontal: 24.s)),
                ])
            .toList()
          ..removeLast())
        .toColumn(mainAxisSize: MainAxisSize.min);
  }
}
