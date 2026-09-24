// ignore_for_file: sort_child_properties_last, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

import 'ref_status_widget.dart';

enum ChangeState {
  began,
  end,
}

class TabWidget extends StatefulWidget {
  TabWidget({
    Key? key,
    required this.bodyBuilder,
    required this.loadFunc,
    this.tabBuilder,
    this.index = 0,
    required this.tabs,
    this.labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    this.unselectedLabelStyle = const TextStyle(
      fontSize: 14,
    ),
    this.tabIndicator,
    this.tabHeight = 44,
    this.labelColor = const Color(0xFF0080FF),
    this.unselectedLabelColor,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.indicatorWeight = 2,
    this.tabPadding = EdgeInsets.zero,
    this.labelPadding = EdgeInsets.zero,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicatorColor,
    this.shouldLoad,
    this.reversed = false,
    this.isScrollable = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onIndexChanged,
    this.onCreated,
    this.disableAutoScroll = true,
    this.tabAlignment,
    this.physics,
  }) : super(key: key);
  final int index;
  final List<Widget> tabs;
  final TextStyle labelStyle;
  final Color labelColor;
  final Color? unselectedLabelColor;
  final TextStyle unselectedLabelStyle;
  final Decoration? tabIndicator;
  final TabBarIndicatorSize indicatorSize;
  final double indicatorWeight;
  final Color? indicatorColor;
  final EdgeInsets tabPadding;
  final EdgeInsets labelPadding;
  final EdgeInsets indicatorPadding;
  final double tabHeight;
  final Widget Function(int index) bodyBuilder;
  final Widget Function(TabBar tab)? tabBuilder;
  final Future<void> Function(int index) loadFunc;
  final bool Function(int index, RefStatus status)? shouldLoad;
  final bool reversed;
  final bool isScrollable;
  final CrossAxisAlignment crossAxisAlignment;
  final void Function(int index, ChangeState state)? onIndexChanged;
  final void Function(TabController controller)? onCreated;
  final bool disableAutoScroll;
  final TabAlignment? tabAlignment;
  final ScrollPhysics? physics;

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

/// 禁止由程序驱动的滚动（例如 TabBar 点击时内部触发的 DrivenScrollActivity 居中滚动），
/// 同时保留用户手势拖拽滑动能力
class NoProgrammaticScrollPhysics extends ScrollPhysics {
  const NoProgrammaticScrollPhysics({super.parent});

  @override
  NoProgrammaticScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NoProgrammaticScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (position is ScrollPosition) {
      final activity = (position as dynamic).activity;
      if (activity is DrivenScrollActivity) {
        return value - position.pixels;
      }
    }
    return super.applyBoundaryConditions(position, value);
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // 增加滑动距离的阈值
    return offset * 0.05;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // 当用户停止拖动时，调整滚动速度
    if (velocity.abs() < 300.0) {
      return super.createBallisticSimulation(position, velocity * 0.2);
    }
    return super.createBallisticSimulation(position, velocity);
  }
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) return Container();
    TabBar tab = TabBar(
      isScrollable: widget.isScrollable,
      tabAlignment: widget.tabAlignment ??
          (widget.isScrollable ? TabAlignment.start : null),
      physics: widget.physics ??
          (widget.disableAutoScroll
              ? const NoProgrammaticScrollPhysics()
              : null),
      labelPadding: widget.labelPadding,
      indicatorSize: widget.indicatorSize,
      indicatorPadding: widget.indicatorPadding,
      labelStyle: widget.labelStyle,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      indicator: widget.tabIndicator,
      indicatorWeight: widget.indicatorWeight,
      tabs: widget.tabs,
      controller: tabController,
      indicatorColor: widget.indicatorColor,
      padding: widget.tabPadding,
    );
    return [
      (widget.tabBuilder != null).toWidget(() => widget.tabBuilder!.call(tab),
          falseWidget: tab.applyBackground(height: widget.tabHeight)),
      TabBarView(
        physics: NeverScrollableScrollPhysics(),
        // physics: CustomScrollPhysics(),
        children: List.generate(
            widget.tabs.length,
            (index) => RefStatusWidget(
                  refStatus: refs[index],
                  loadFunc: () => widget.loadFunc.call(index),
                  builder: () => widget.bodyBuilder.call(index),
                )),
        controller: tabController,
      ).expanded
    ].toColumn(
        reversed: widget.reversed,
        crossAxisAlignment: widget.crossAxisAlignment);
  }

  late TabController tabController;
  late List<ValueNotifier<RefStatus>> refs;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        vsync: this,
        length: widget.tabs.length,
        initialIndex: widget.index,
        animationDuration: Duration.zero);
    refs = List.generate(
        widget.tabs.length,
        (index) => ValueNotifier(
              index == widget.index ? RefStatus.load : RefStatus.unload,
            ));
    tabController.addListener(indexChanged);
    widget.onCreated?.call(tabController);
  }

  int _lastIndex = -1;
  void indexChanged() {
    int index = tabController.index;
    if (index != _lastIndex) {
      var status = refs[index];
      if (widget.shouldLoad?.call(index, status.value) ?? true) {
        refs[index].value = RefStatus.load;
      }
    }
    widget.onIndexChanged?.call(
      tabController.index,
      index == _lastIndex ? ChangeState.end : ChangeState.began,
    );
    _lastIndex = index;
  }

  @override
  void dispose() {
    tabController.removeListener(indexChanged);
    tabController.dispose();
    super.dispose();
  }
}
