import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/tree_widget/wt_tree_widget.dart';
import 'package:qm_widget/wetool/wt_icon.dart';

class TreeNode<T> {
  final String title;
  final List<T> children;

  TreeNode(this.title, this.children);
}

class WTTreeWidget<T> extends StatefulWidget {
  final List<TreeNode<T>> nodes;
  final Widget Function(T, bool selected) childBuilder;
  final bool Function(T, bool)? willChangeSelectedStatus;
  final void Function(T, bool)? didChangeSelectedStatus;
  final void Function(TreeNode<T>, int, bool)? onExpansionChanged;
  const WTTreeWidget(
      {super.key,
      required this.nodes,
      required this.childBuilder,
      this.willChangeSelectedStatus,
      this.didChangeSelectedStatus,
      this.onExpansionChanged});

  @override
  State<WTTreeWidget<T>> createState() => _WTTreeWidgetState<T>();
}

class _WTTreeWidgetState<T> extends State<WTTreeWidget<T>> {
  Widget buildNodeWidget(TreeNode<T> node) => Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: node.title
            .toText(
              fontSize: 15.fs,
              height: 20 / 15,
              color: isExpanded(node)
                  ? QMColor.COLOR_030319
                  : QMColor.COLOR_8F92A1,
              fontWeight:
                  isExpanded(node) ? FontWeight.w500 : FontWeight.normal,
            )
            .applyPadding(EdgeInsets.only(left: 14.s)),
        collapsedBackgroundColor: QMColor.COLOR_F7F9FA,
        backgroundColor: Colors.white,
        clipBehavior: Clip.hardEdge,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: isExpanded(node),
        trailing: RotatedBox(
          quarterTurns: isExpanded(node) ? 2 : 0,
          child: node.children.isNotEmpty.toWidget(() => SvgPicture.string(
                WTIcon.ARROW_FILLED,
                width: 12.s,
                height: 12.s,
              )),
        ).applyBackground(width: 28.s, alignment: Alignment.center),
        children: node.children
            .map(
              (e) => StatefulBuilder(
                builder: (_, refFunc) => widget.childBuilder
                    .call(e, isSelected(e))
                    .onClick(click: () {
                  bool selected = isSelected(e);
                  if (widget.willChangeSelectedStatus?.call(e, selected) ??
                      true) {
                    selected = !selected;
                    selectedInfo[e] = selected;
                    refFunc.call(() {});
                    widget.didChangeSelectedStatus?.call(e, selected);
                    if (selected) {
                      selectedInfo.forEach((key, value) {
                        if (key != e && value) {
                          selectedInfo[key] = !value;
                          widget.didChangeSelectedStatus?.call(e, !value);
                        }
                      });
                      setState(() {});
                    }
                  }
                }),
              ),
            )
            .toList(),
        onExpansionChanged: (p) {
          widget.onExpansionChanged?.call(node, widget.nodes.indexOf(node), p);
          if (p) {
            expandedInfos[node] = p;

            expandedInfos.forEach((key, value) {
              if (node != key && value) {
                expandedInfos[key] = false;
              }
            });
          }
          setState(() {});
        },
      ));
  @override
  Widget build(BuildContext context) {
    return widget.nodes
        .map((e) => WTTreeNodeWidget(
            title: "title",
            children: ["123", "123", "345"],
            isExpanded: true,
            childBuilder: (name, idx, isSelected) => [
                  (isSelected ? QMColor.COLOR_00B276 : Colors.white)
                      .toContainer(
                    width: 3.s,
                    height: 16.s,
                  ),
                  11.s.inRow,
                  '${name}'
                      .toText(
                        fontSize: 15.s,
                        height: 20 / 15,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                        color: isSelected
                            ? QMColor.COLOR_00B276
                            : QMColor.COLOR_8F92A1,
                      )
                      .expanded,
                  28.s.inRow,
                ].toRow().applyBackground(
                      padding: EdgeInsets.symmetric(vertical: 14.s),
                      color: Colors.white,
                    )))
        .toList()
        .toColumn()
        .toScrollView();
  }

  // Map<TreeNode, ExpansionTileController> controllers = {};
  Map<TreeNode, bool> expandedInfos = {};
  bool isExpanded(TreeNode node) => expandedInfos[node] ?? false;

  Map<T, bool> selectedInfo = {};
  bool isSelected(T node) => selectedInfo[node] ?? false;
}
