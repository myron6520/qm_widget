// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/list_view/sort_list_view.dart';

class OrderListWidget extends StatefulWidget {
  final List<Item> items;
  final void Function(int)? onDragStarted;
  final void Function(int)? onDragCompleted;

  OrderListWidget(
      {Key? key, required this.items, this.onDragCompleted, this.onDragStarted})
      : super(key: key);

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  Widget buildItemWidget(int index) => [
        LongPressDraggable(
          child: items[index].title.toText().applyPadding(
                EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
          axis: Axis.vertical,
          feedback: items[index].title.toText().applyBackground(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                color: Colors.red,
              ),
          onDragCompleted: () {
            widget.onDragCompleted?.call(index);
            setState(() {});
          },
          onDragStarted: () => widget.onDragStarted?.call(index),
        ).expanded,
        Container(
          width: 120,
          height: 40,
          color: Colors.green,
        )
      ].toRow().applyBackground(
            key: ValueKey("${items[index].title}_${items.length}"),
            color: Colors.white,
          );
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        itemBuilder: (_, idx) => buildItemWidget(idx),
        itemCount: items.length,
        shrinkWrap: true,
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex > newIndex) {
            items.insert(newIndex, items.removeAt(oldIndex));
          } else {
            items.insert(newIndex - 1, items.removeAt(oldIndex));
          }
        });
  }

  late List<Item> items = widget.items;
}
