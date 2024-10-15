import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';

class WTDatePicker extends StatefulWidget {
  ///yyyy-MM-dd
  final String dateStr;
  final void Function(int year, int month, int day)? onConfirm;

  const WTDatePicker({super.key, this.dateStr = "", this.onConfirm});

  @override
  State<WTDatePicker> createState() => _WTDatePickerState();
}

class _WTDatePickerState extends State<WTDatePicker> {
  //0 year 1 month 2 day
  Widget buildDatePicker(int type) {
    int dayCount = 31;
    if ([4, 6, 9, 11].contains(month)) {
      dayCount = 30;
    }
    if (month == 2) {
      if (year % 4 == 0 && year % 100 != 0) {
        dayCount = 29;
      } else {
        dayCount = 28;
      }
    }
    List<List<String>> datas = [
      List.generate(
          210, (index) => "${DateTime.now().year - 110 + index + 1}年"),
      List.generate(12, (index) => "${index + 1}月"),
      List.generate(dayCount, (index) => "${index + 1}日"),
    ];
    List<int> idxList = [
      year + 110 - 1 - DateTime.now().year,
      month - 1,
      day - 1,
    ];
    List funcList = [
      (idx) {
        year = idx + 1 + DateTime.now().year - 110;
        setState(() {});
      },
      (idx) {
        month = idx + 1;
        setState(() {});
      },
      (idx) {
        day = idx + 1;
      }
    ];
    return CupertinoPicker(
        itemExtent: 48.s,
        looping: true,
        scrollController:
            FixedExtentScrollController(initialItem: idxList[type]),
        onSelectedItemChanged: funcList[type],
        selectionOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal:
                    BorderSide(color: QMColor.COLOR_E0E0E0, width: 0.5.s)),
          ),
        ),
        children: datas[type]
            .map(
              (e) => e
                  .toText(
                    color: QMColor.COLOR_030319,
                    fontSize: 16.fs,
                    height: 24 / 16,
                  )
                  .applyBackground(
                    alignment: Alignment.center,
                    height: 48.s,
                  ),
            )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return [
      [
        buildDatePicker(0).expanded,
        buildDatePicker(1).expanded,
        buildDatePicker(2).expanded,
      ].toRow().applyBackground(
            height: 240.s,
            padding: EdgeInsets.symmetric(horizontal: 16.s),
            color: Colors.white,
          ),
    ].toColumn();
  }

  int year = 1990, month = 1, day = 3;
  @override
  void initState() {
    super.initState();

    ///解析日期
    List<String> list = widget.dateStr.split("-");

    if (list.length == 3) {
      year = int.tryParse(list[0]) ?? 1990;
      year = max(DateTime.now().year - 110 - 1, year);
      year = min(DateTime.now().year, year);

      month = int.tryParse(list[1]) ?? 1;
      month = max(1, month);
      month = min(12, month);

      int dayCount = 31;
      if ([4, 6, 9, 11].contains(month)) {
        dayCount = 30;
      }
      if (month == 2) {
        if (year % 4 == 0 && year % 100 != 0) {
          dayCount = 29;
        } else {
          dayCount = 28;
        }
      }

      day = int.tryParse(list[2]) ?? 1;
      day = max(1, day);
      day = min(dayCount, day);
    }
  }
}
