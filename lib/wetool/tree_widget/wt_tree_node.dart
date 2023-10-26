import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';

import '../../style/qm_color.dart';
import '../wt_icon.dart';

mixin WTTreeNode {
  String get title => "";
  List<WTTreeNode> get nodes => [];
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  set isSelected(bool value) => _isSelected = value;
  Color get collapsedBackgroundColor =>
      (isSelected || isExpanded) ? Colors.white : QMColor.COLOR_F7F9FA;
  Color get textColor =>
      (isExpanded || isSelected) ? QMColor.COLOR_030319 : QMColor.COLOR_8F92A1;
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;
  set isExpanded(bool value) => _isExpanded = value;
  Widget get trailing => nodes.isNotEmpty.toWidget(() => RotatedBox(
        quarterTurns: isExpanded ? 2 : 0,
        child: SvgPicture.string(
          WTIcon.ARROW_FILLED,
          width: 12.s,
          height: 12.s,
        ),
      ).applyBackground(
        width: 28.s,
        alignment: Alignment.center,
      ));
}
