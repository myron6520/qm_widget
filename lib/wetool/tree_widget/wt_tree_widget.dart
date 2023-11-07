import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/tree_widget/wt_tree_content_widget.dart';
import 'package:qm_widget/wetool/tree_widget/wt_tree_node.dart';
import 'package:qm_widget/wetool/tree_widget/wt_tree_node_widget.dart';
import 'package:qm_widget/wetool/wt_icon.dart';

class WTTreeWidget extends StatefulWidget {
  final List<WTTreeNode> nodes;
  // final Widget Function(T, bool selected) childBuilder;
  // final bool Function(T, bool)? willChangeSelectedStatus;
  // final void Function(T, bool)? didChangeSelectedStatus;
  // final void Function(TreeNode<T>, int, bool)? onExpansionChanged;
  final void Function(WTTreeNode node, int idx)? onNodeClick;
  const WTTreeWidget({
    super.key,
    required this.nodes,
    this.onNodeClick,
    // required this.childBuilder,
    // this.willChangeSelectedStatus,
    // this.didChangeSelectedStatus,
    // this.onExpansionChanged,
  });

  @override
  State<WTTreeWidget> createState() => _WTTreeWidgetState();
}

class _WTTreeWidgetState extends State<WTTreeWidget> {
  // Widget buildNodeWidget(TreeNode<T> node) => Theme(
  //     data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //     child: ExpansionTile(
  //       title: node.title
  //           .toText(
  //             fontSize: 15.fs,
  //             height: 20 / 15,
  //             color: isExpanded(node)
  //                 ? QMColor.COLOR_030319
  //                 : QMColor.COLOR_8F92A1,
  //             fontWeight:
  //                 isExpanded(node) ? FontWeight.w500 : FontWeight.normal,
  //           )
  //           .applyPadding(EdgeInsets.only(left: 14.s)),
  //       collapsedBackgroundColor: QMColor.COLOR_F7F9FA,
  //       backgroundColor: Colors.white,
  //       clipBehavior: Clip.hardEdge,
  //       tilePadding: EdgeInsets.zero,
  //       childrenPadding: EdgeInsets.zero,
  //       initiallyExpanded: isExpanded(node),
  //       trailing: RotatedBox(
  //         quarterTurns: isExpanded(node) ? 2 : 0,
  //         child: node.children.isNotEmpty.toWidget(() => SvgPicture.string(
  //               WTIcon.ARROW_FILLED,
  //               width: 12.s,
  //               height: 12.s,
  //             )),
  //       ).applyBackground(width: 28.s, alignment: Alignment.center),
  //       children: node.children
  //           .map(
  //             (e) => StatefulBuilder(
  //               builder: (_, refFunc) => widget.childBuilder
  //                   .call(e, isSelected(e))
  //                   .onClick(click: () {
  //                 bool selected = isSelected(e);
  //                 if (widget.willChangeSelectedStatus?.call(e, selected) ??
  //                     true) {
  //                   selected = !selected;
  //                   selectedInfo[e] = selected;
  //                   refFunc.call(() {});
  //                   widget.didChangeSelectedStatus?.call(e, selected);
  //                   if (selected) {
  //                     selectedInfo.forEach((key, value) {
  //                       if (key != e && value) {
  //                         selectedInfo[key] = !value;
  //                         widget.didChangeSelectedStatus?.call(e, !value);
  //                       }
  //                     });
  //                     setState(() {});
  //                   }
  //                 }
  //               }),
  //             ),
  //           )
  //           .toList(),
  //       onExpansionChanged: (p) {
  //         widget.onExpansionChanged?.call(node, widget.nodes.indexOf(node), p);
  //         if (p) {
  //           expandedInfos[node] = p;
  //
  //           expandedInfos.forEach((key, value) {
  //             if (node != key && value) {
  //               expandedInfos[key] = false;
  //             }
  //           });
  //         }
  //         setState(() {});
  //       },
  //     ));
  @override
  Widget build(BuildContext context) {
    return widget.nodes
        .map(
          (e) => WTTreeNodeWidget(
            node: e,
            childBuilder: () => WTTreeContentWidget(node: e),
            onCreate: (p) {
              p.addListener(treeNodeControllerOnChanged);
              controllers[e] = p;
            },
            onDestroy: (p) {
              p.removeListener(treeNodeControllerOnChanged);
              controllers.remove(e);
            },
            onSelectedChanged: (p) {
              current = p;
              widget.onNodeClick?.call(p.node, -1);
              onSelectedChanged(p);
            },
            onItemClick: (idx) {
              widget.onNodeClick?.call(e, idx);
            },
          ),
        )
        .toList()
        .toColumn()
        .toScrollView();
  }

  WTTreeNodeController? current;
  void onSelectedChanged(WTTreeNodeController controller) {
    for (var element in controllers.values) {
      if (element != current) {
        element.selectedIdx = -1;
        element.isSelected = false;
        element.isExpanded = false;
        element.commit();
      }
    }
  }

  void treeNodeControllerOnChanged() {
    for (var element in controllers.values) {
      // if (!element.isSelected) {
      //   element.selectedIdx = -1;
      //   element.isExpanded = false;
      //   element.commit();
      // }
    }
  }

  void onSelectedIdxChanged(WTTreeNodeController controller) {
    for (var element in controllers.values) {
      if (element != controller) {
        element.selectedIdx = -1;
        element.commit();
      }
    }
  }

  // void onSelectedChanged(WTTreeNodeController controller, bool val) {
  //   if (!val) return;
  //   for (var element in controllers.values) {
  //     if (element != controller) {
  //       element.isSelected = false;
  //       element.commit();
  //     }
  //   }
  // }

  void onExpansionChanged(WTTreeNodeController controller, bool val) {
    if (!val) return;
    for (var element in controllers.values) {
      if (element != controller) {
        element.isExpanded = false;
        element.commit();
      }
    }
  }

  Map<WTTreeNode, WTTreeNodeController> controllers = {};
  // Map<TreeNode, ExpansionTileController> controllers = {};
  // Map<TreeNode, bool> expandedInfos = {};
  // bool isExpanded(TreeNode node) => expandedInfos[node] ?? false;
  //
  // Map<T, bool> selectedInfo = {};
  // bool isSelected(T node) => selectedInfo[node] ?? false;
}
