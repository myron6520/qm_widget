import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/wetool/tree_widget/wt_tree_node.dart';

import '../../style/qm_color.dart';

class WTTreeContentWidget extends StatefulWidget {
  final WTTreeNode node;
  const WTTreeContentWidget({super.key, required this.node});

  @override
  State<WTTreeContentWidget> createState() => _WTTreeContentWidgetState();
}

class _WTTreeContentWidgetState extends State<WTTreeContentWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.node.nodes
        .map((el) => [
              (isSelected(el) ? QMColor.COLOR_00B276 : Colors.white)
                  .toContainer(
                width: 3.s,
                height: 16.s,
              ),
              11.s.inRow,
              "123"
                  .toText(
                    fontSize: 15.s,
                    height: 20 / 15,
                    fontWeight:
                        isSelected(el) ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected(el)
                        ? QMColor.COLOR_00B276
                        : QMColor.COLOR_8F92A1,
                  )
                  .expanded,
              28.s.inRow,
            ].toRow().applyBackground(
                  padding: EdgeInsets.symmetric(vertical: 14.s),
                  color: Colors.white,
                ))
        .toList()
        .toColumn();
  }

  bool isSelected(WTTreeNode node) => false;
}
