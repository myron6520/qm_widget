import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/net/net_resp.dart';
import 'package:qm_widget/pub/scale_util.dart';

import '../../style/qm_color.dart';

class WTFilterWidget extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final void Function(List<String>)? onChanged;
  final bool multiple;
  const WTFilterWidget({
    super.key,
    required this.title,
    required this.options,
    this.onChanged,
    this.multiple = false,
    this.selectedOptions = const [],
  });

  @override
  State<WTFilterWidget> createState() => _WTFilterWidgetState();
}

class _WTFilterWidgetState extends State<WTFilterWidget> {
  Widget buildItemWidget(String item) {
    return item
        .toText(
          color: _selectedItems.contains(item)
              ? QMColor.COLOR_00B276
              : QMColor.COLOR_8F92A1,
          fontSize: 14.fs,
          height: 20 / 14,
        )
        .applyBackground(
          height: 32.s,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.s),
            color: _selectedItems.contains(item)
                ? QMColor.COLOR_EBF9F4
                : QMColor.COLOR_F7F9FA,
          ),
        )
        .onTouch(onTap: () {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        if (widget.multiple) {
          _selectedItems.add(item);
        } else {
          _selectedItems.clear();
          _selectedItems.add(item);
        }
      }
      setState(() {});
      widget.onChanged?.call(_selectedItems);
    }).expanded;
  }

  Widget buildOptionsWidget() {
    const int numInRow = 4;
    int rowCount = widget.options.length ~/ numInRow;
    if (widget.options.length % numInRow > 0) {
      rowCount++;
    }
    List<Widget> widgets = [];
    for (int i = 0; i < rowCount; i++) {
      List<Widget> rowWidgets = [];
      for (int j = 0; j < numInRow; j++) {
        final index = i * numInRow + j;
        if (index < widget.options.length) {
          rowWidgets.add(buildItemWidget(widget.options[index]));
        } else {
          rowWidgets.add(Container().expanded);
        }
        rowWidgets.add(8.s.inRow);
      }
      rowWidgets.removeLast();
      widgets.add(rowWidgets.toRow());
      widgets.add(8.s.inColumn);
    }
    return widgets.toColumn();
  }

  @override
  Widget build(BuildContext context) {
    return [
      widget.title
          .toText(
            color: QMColor.COLOR_030319,
            fontSize: 14.fs,
            height: 20 / 14,
            fontWeight: FontWeight.w500,
          )
          .expanded
          .toRow(),
      12.s.inColumn,
      buildOptionsWidget(),
    ].toColumn();
  }

  final List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.options);
    if (!widget.multiple && _selectedItems.length > 1) {
      _selectedItems.removeRange(1, _selectedItems.length);
    }
  }
}
