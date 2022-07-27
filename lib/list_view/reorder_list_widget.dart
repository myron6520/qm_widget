// ignore_for_file: prefer_const_constructors

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
          }
          dragInIndex = -1;
          dragingIndex = -1;
          setState(() {});
        },
      );
  Widget buildItemWidget(int index) => [
        DragTarget(
          builder: (_, __, ___) => [items[index].title.toText().expanded]
              .toRow()
              .applyBackground(
                padding: EdgeInsets.all(16),
                color: dragInIndex == index
                    ? (dragInIndex == dragingIndex ? Colors.amber : Colors.blue)
                    : Colors.white,
              ),
          onWillAccept: (_) {
            dragInIndex = index;
            setState(() {});
            return true;
          },
        ),
        items[index]
            .children
            .isNotEmpty
            .toWidget(() => buildChildWidget(index, items[index].children)),
      ].toColumn().applyBackground(
            key: ValueKey("${items[index].title}_${items.length}"),
          );
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        itemBuilder: (_, idx) => buildItemWidget(idx),
        itemCount: items.length,
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex > newIndex) {
            items.insert(newIndex, items.removeAt(oldIndex));
          } else {
            items.insert(newIndex - 1, items.removeAt(oldIndex));
          }
        });
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
