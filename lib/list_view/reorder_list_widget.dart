// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/list_view/sort_list_view.dart';

import 'order_list_widget.dart';

class ReorderListWidget extends StatefulWidget {
  ReorderListWidget({Key? key}) : super(key: key);

  @override
  State<ReorderListWidget> createState() => _ReorderListWidgetState();
}

class _ReorderListWidgetState extends State<ReorderListWidget> {
  Widget buildChildWidget(int index, List<Item> children) => OrderListWidget(
        key: ValueKey(children.length),
        items: children,
        onDragStarted: (childIndex) => dragingIndex = index,
        onDragCompleted: (childIndex) {
          Item item = children[childIndex];
          Item superItem = items[dragInIndex];
          Item oldSuperItem = items[index];
          if (index == dragInIndex) {
            superItem.children.remove(item);
            item.superTitle = "";
            items.insert(index, item);
          } else {
            oldSuperItem.children.remove(item);
            item.superTitle = superItem.title;
            List<Item> children = List.from(superItem.children);
            children.insert(0, item);
            superItem.children = children;
            superItem.open = true;
          }
          dragInIndex = -1;
          dragingIndex = -1;
          setState(() {});
        },
      );
  Widget buildItemWidget(int index) => [
        DragTarget(
          builder: (_, __, ___) => [
            LongPressDraggable(
                axis: Axis.vertical,
                onDragStarted: () => dragingIndex = index,
                onDragCompleted: () {
                  if (dragInIndex != dragingIndex) {
                    Item item = items[dragingIndex];
                    if (item.children.isEmpty) {
                      Item superItem = items[dragInIndex];
                      items.remove(item);
                      item.superTitle = superItem.title;
                      List<Item> children = List.from(superItem.children);
                      children.insert(0, item);
                      superItem.children = children;
                      superItem.open = true;
                    } else {}
                  }
                  dragInIndex = -1;
                  dragingIndex = -1;
                  setState(() {});
                },
                child: [items[index].title.toText().expanded]
                    .toRow()
                    .applyBackground(
                      padding: EdgeInsets.all(16),
                      color: dragInIndex == index
                          ? (dragInIndex == dragingIndex
                              ? Colors.amber
                              : Colors.blue)
                          : Colors.white,
                    ),
                feedback: [items[index].title.toText().expanded]
                    .toRow()
                    .applyBackground(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                    )).expanded,
            Container(
              width: 120,
              height: 40,
              color: Colors.amber,
            )
          ].toRow().onClick(click: () {
            items[index].open = !items[index].open;
            setState(() {});
          }),
          onWillAccept: (_) {
            dragInIndex = index;
            setState(() {});
            return true;
          },
        ),
        (items[index].children.isNotEmpty && items[index].open)
            .toWidget(() => buildChildWidget(index, items[index].children)),
      ].toColumn().applyBackground(
            key: ValueKey(
                "${items[index].title}_${items[index].children.length}"),
          );
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        key: ValueKey(items.length),
        itemBuilder: (_, idx) => buildItemWidget(idx),
        itemCount: items.length,
        // proxyDecorator: _proxyDecorator,
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex > newIndex) {
            items.insert(newIndex, items.removeAt(oldIndex));
          } else {
            items.insert(newIndex - 1, items.removeAt(oldIndex));
          }
        });
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          child: [items[index].title.toText().expanded].toRow().applyBackground(
                padding: EdgeInsets.all(16),
                color: Colors.red,
              ),
        );
      },
      child: [items[index].title.toText().expanded].toRow().applyBackground(
            padding: EdgeInsets.all(16),
            color: Colors.red,
          ),
    );
  }

  List<Item> items = [
    Item(title: "BTC", children: [
      Item(title: "SOL", superTitle: "BTC"),
      Item(title: "PEOPLE", superTitle: "BTC"),
      Item(title: "LUNA", superTitle: "BTC"),
      Item(title: "ATOM", superTitle: "BTC"),
      Item(title: "BUSD", superTitle: "BTC"),
      Item(title: "BNB", superTitle: "BTC"),
      Item(title: "JDT", superTitle: "BTC"),
    ]),
    Item(title: "ETH"),
    Item(title: "USDT"),
    Item(title: "USDC"),
    Item(title: "FIL"),
    Item(title: "DOT"),
    Item(title: "TRX"),
  ];
  int dragInIndex = -1;
  int dragingIndex = -1;
}
