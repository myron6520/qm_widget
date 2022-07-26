// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

class SortListView extends StatefulWidget {
  SortListView({Key? key}) : super(key: key);

  @override
  State<SortListView> createState() => _SortListViewState();
}

class _SortListViewState extends State<SortListView> {
  Widget buildItemWidget(int idx) => DragTarget(
        key: _keys[idx] ??= GlobalKey(),
        onWillAccept: ((data) {
          Item item = fullItems[idx];
          if (item.superTitle.isNotEmpty) {
            return false;
          }
          index = idx;
          setState(() {});
          return true;
        }),
        onAccept: (data) {
          if (dragIndex == idx) return;
          print("drag:$dragIndex  index:$idx");
          Item old = fullItems[dragIndex];
          if (old.children.isNotEmpty) {
            return;
          }
          Item newItem = fullItems[idx];
          if (old.superTitle.isEmpty) {
            old.superTitle = newItem.title;
            newItem.children = [old, ...newItem.children];
            newItem.open = true;
            items.removeAt(dragIndex);
          } else {
            String superTitle = old.superTitle;
            if (superTitle == newItem.title) {
              old.superTitle = "";
              newItem.children.remove(old);
              int nId = items.indexOf(newItem);
              items.insert(nId, old);
            } else {
              for (var item in items) {
                if (item.title == superTitle) {
                  item.children.removeWhere((e) => e.title == old.title);
                  break;
                }
              }
              old.superTitle = newItem.title;
              newItem.children = [old, ...newItem.children];
              newItem.open = true;
            }
          }
          setState(() {});
        },
        onMove: (details) {
          // print("offset:${details.offset.dy}");
          // if (moveOffset.dy > details.offset.dy) {
          //   up = false;
          // } else {
          //   up = true;
          // }
          // moveOffset = details.offset;
          // double dh =
          //     ((_keys[idx]?.currentContext?.findRenderObject()) as RenderBox?)
          //             ?.size
          //             .height ??
          //         0;
          // double dy = moveOffset.dy + (up ? 0 : dh);
          // double minDy = 0;
          // double maxDy = 0;
          // for (var e in _keys.keys) {
          //   GlobalKey key = _keys[e]!;
          //   RenderBox? box =
          //       key.currentContext?.findRenderObject() as RenderBox?;
          //   double y = box?.localToGlobal(Offset.zero).dy ?? 0;
          //   double h = box?.size.height ?? 0;
          //   if (dy >= y && dy <= (y + h)) {
          //     index = e;
          //     minDy = y;
          //     maxDy = y + h;
          //     setState(() {});
          //     break;
          //   }
          // }
          // if (up) {
          //   if (dy > (maxDy + minDy) / 2) {
          //     margin = 0;
          //   } else {
          //     margin = 0;
          //   }
          // } else {
          //   if (dy > (maxDy + minDy) / 2) {
          //     margin = 0;
          //   } else {
          //     margin = 0;
          //   }
          // }

          // setState(() {});
        },
        builder: (_, __, ___) {
          return [
            LongPressDraggable(
              onDragCompleted: () {
                index = -1;
                setState(() {});
              },
              onDragStarted: () => dragIndex = idx,
              axis: Axis.vertical,
              data: index,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                alignment: Alignment.centerLeft,
                child: fullItems[idx]
                    .title
                    .toText(fontSize: 16, color: Color(0xFF333333))
                    .applyPadding(EdgeInsets.only(
                        left: fullItems[idx].superTitle.isEmpty ? 0 : 32)),
                decoration: BoxDecoration(
                    color: index == idx ? Colors.blue : Colors.green,
                    border: Border(
                        bottom: BorderSide(
                            color: Color(
                              0xFFefefef,
                            ),
                            width: 1))),
              ),
              feedback: getFeedback(idx),
            ).expanded,
            Container(
              width: 80,
              height: 44,
              color: Colors.orange,
            )
          ].toRow();
        },
      );
  @override
  Widget build(BuildContext context) {
    // return fullItems
    //     .map((e) => buildItemWidget(fullItems.indexOf(e)).expanded.toRow())
    //     .toList()
    //     .toColumn();
    return ReorderableListView.builder(
        itemBuilder: (_, idx) => buildItemWidget(idx),
        itemCount: fullItems.length,
        onReorderEnd: (index) {
          print("onReorderEnd:$index");
        },
        onReorderStart: (index) {
          print("onReorderStart:$index");
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex > newIndex) {
            fullItems.insert(newIndex, fullItems.removeAt(oldIndex));
          } else {
            fullItems.insert(newIndex - 1, fullItems.removeAt(oldIndex));
          }
        });
  }

  Widget getFeedback(int idx) {
    Item item = fullItems[idx];
    if (item.superTitle.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: item.title.toText(fontSize: 16, color: Color(0xFF333333)),
        decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    color: Color(
                      0xFFefefef,
                    ),
                    width: 1))),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: item.title
            .toText(fontSize: 16, color: Color(0xFF333333))
            .applyPadding(EdgeInsets.only(left: 32)),
        decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    color: Color(
                      0xFFefefef,
                    ),
                    width: 1))),
      );
    }
  }

  Map<int, GlobalKey> _keys = {};
  Offset moveOffset = Offset.zero;
  bool up = false;
  int index = -1;
  int dragIndex = -1;
  List<Item> items = [
    Item(title: "BTC"),
    Item(title: "ETH"),
    Item(title: "USDT"),
    Item(title: "USDC"),
    Item(title: "FIL"),
    Item(title: "DOT"),
    Item(title: "TRX"),
  ];
  List<Item> get fullItems => items.expand((e) {
        if (e.open) {
          return [e, ...e.children];
        }
        return [e];
      }).toList();
}

class Item {
  final String title;
  String superTitle;
  bool open = false;
  List<Item> children = [];

  Item({this.title = "", this.superTitle = ""});
}
