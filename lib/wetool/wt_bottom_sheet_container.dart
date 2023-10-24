import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';

class WTBottomSheetContailer extends StatelessWidget {
  final String? title;
  final Widget child;
  const WTBottomSheetContailer({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return [
      12.s.inColumn,
      QMColor.COLOR_F2F2F2
          .toContainer(width: 36.s, height: 4.s)
          .applyRadius(10.s),
      8.s.inColumn,
      (title != null).toWidget(() => title!
          .toText(
            color: QMColor.COLOR_030319,
            fontSize: 18.fs,
            fontWeight: FontWeight.w500,
          )
          .applyBackground(padding: EdgeInsets.symmetric(vertical: 8.s))),
      child
    ].toColumn(mainAxisSize: MainAxisSize.min).toSafe().applyBackground(
            decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.s)),
        ));
  }

  Future<T?> show<T>(BuildContext context) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => this);
}
