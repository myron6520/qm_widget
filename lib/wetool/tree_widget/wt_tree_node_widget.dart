import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/wetool/tree_widget/wt_tree_node.dart';

import '../../style/qm_color.dart';
import '../wt_icon.dart';

class WTTreeNodeWidget extends StatefulWidget {
  final WTTreeNode node;
  final Widget? Function()? childBuilder;
  final void Function(int idx)? onItemClick;
  final WTTreeNodeController? controller;
  final void Function(WTTreeNodeController controller)? onCreate;
  final void Function(WTTreeNodeController controller)? onDestroy;
  final void Function(WTTreeNodeController controller)? onSelectedChanged;
  const WTTreeNodeWidget(
      {super.key,
      this.childBuilder,
      this.controller,
      required this.node,
      this.onCreate,
      this.onDestroy,
      this.onSelectedChanged,
      this.onItemClick});

  @override
  State<WTTreeNodeWidget> createState() => _WTTreeNodeWidgetState();
}

class WTTreeNodeController extends ChangeNotifier {
  int selectedIdx = -1;
  bool get isSelected => node.isSelected;
  set isSelected(val) => node.isSelected = val;
  bool get isExpanded => node.isExpanded;
  set isExpanded(val) => node.isExpanded = val;
  final WTTreeNode node;
  WTTreeNodeController({required this.node});
  void commit() => notifyListeners();
}

class _WTTreeNodeWidgetState extends State<WTTreeNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            collapsedBackgroundColor: widget.node.collapsedBackgroundColor,
          )),
      child: ExpansionTile(
        controller: tileController,
        title: widget.node.title
            .toText(
              fontSize: 15.fs,
              height: 20 / 15,
              color: (isSelected || isExpanded)
                  ? widget.node.selectedTextColor
                  : QMColor.COLOR_8F92A1,
              fontWeight: (isExpanded || isSelected)
                  ? FontWeight.w500
                  : FontWeight.normal,
            )
            .applyPadding(EdgeInsets.only(left: 14.s)),
        clipBehavior: Clip.hardEdge,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (val) {
          controller.isSelected = true;
          controller.isExpanded = val;
          if (val) {
            controller.selectedIdx = -1;
          }
          widget.onSelectedChanged?.call(controller);
          controller.commit();
          setState(() {});
        },
        trailing: widget.node.trailing,
        children: List.generate(
          1,
          // (idx) => widget.childBuilder?.call() ?? Container(),
          // (_) => WTTreeContentWidget(node: widget.node),
          (_) => StatefulBuilder(
            builder: (_, ref) => List.generate(
              widget.node.nodes.length,
              (index) => [
                (controller.selectedIdx == index
                        ? QMColor.COLOR_00B276
                        : Colors.white)
                    .toContainer(
                  width: 3.s,
                  height: 16.s,
                ),
                11.s.inRow,
                widget.node.nodes[index].title
                    .toText(
                      fontSize: 15.s,
                      height: 20 / 15,
                      fontWeight: controller.selectedIdx == index
                          ? FontWeight.w500
                          : FontWeight.normal,
                      color: controller.selectedIdx == index
                          ? QMColor.COLOR_00B276
                          : QMColor.COLOR_8F92A1,
                    )
                    .expanded,
                28.s.inRow,
              ]
                  .toRow()
                  .applyBackground(
                    padding: EdgeInsets.symmetric(vertical: 14.s),
                    color: Colors.white,
                  )
                  .onClick(click: () {
                controller.selectedIdx = index;
                widget.onItemClick?.call(index);
                controller.commit();
              }),
            ).toColumn().applyChangeNotifier(controller,
                onChanged: () async => ref.call(() {})),
          ),
        ),
      ).applyChangeNotifier(controller, onChanged: () async {
        setState(() {});
        if (controller.isExpanded != tileController.isExpanded) {
          if (controller.isExpanded) {
            tileController.expand();
          } else {
            tileController.collapse();
          }
        }
      }),
    );
  }

  late WTTreeNodeController controller =
      widget.controller ?? WTTreeNodeController(node: widget.node);
  late ExpansionTileController tileController = ExpansionTileController();
  bool get isExpanded => controller.isExpanded;
  bool get isSelected => controller.isSelected;
  @override
  void initState() {
    super.initState();
    widget.onCreate?.call(controller);
  }

  @override
  void dispose() {
    widget.onDestroy?.call(controller);
    debugPrint("WTTreeNodeWidget onDestroy");
    super.dispose();
  }
}
