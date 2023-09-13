import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';

import '../../style/qm_color.dart';
import '../wt_icon.dart';

class WTTreeNodeWidget extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final bool showRightArrow;
  final Widget? Function()? childBuilder;
  const WTTreeNodeWidget(
      {super.key,
      required this.title,
      this.isExpanded = false,
      this.childBuilder,
      this.showRightArrow = true});

  @override
  State<WTTreeNodeWidget> createState() => _WTTreeNodeWidgetState();
}

class _WTTreeNodeWidgetState extends State<WTTreeNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: widget.title
            .toText(
              fontSize: 15.fs,
              height: 20 / 15,
              color: isExpanded ? QMColor.COLOR_030319 : QMColor.COLOR_8F92A1,
              fontWeight: isExpanded ? FontWeight.w500 : FontWeight.normal,
            )
            .applyPadding(EdgeInsets.only(left: 14.s)),
        collapsedBackgroundColor: QMColor.COLOR_F7F9FA,
        backgroundColor: Colors.white,
        clipBehavior: Clip.hardEdge,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (val) {
          isExpanded = val;
          setState(() {});
        },
        trailing: widget.showRightArrow.toWidget(() => RotatedBox(
              quarterTurns: isExpanded ? 2 : 0,
              child: SvgPicture.string(
                WTIcon.ARROW_FILLED,
                width: 12.s,
                height: 12.s,
              ),
            ).applyBackground(width: 28.s, alignment: Alignment.center)),
        children: List.generate(
          1,
          (idx) => widget.childBuilder?.call() ?? Container(),
        ),
      ),
    );
  }

  late bool isExpanded = widget.isExpanded;
  int index = -1;
}
