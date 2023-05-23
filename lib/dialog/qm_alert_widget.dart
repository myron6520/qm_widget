
import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/style/qm_color.dart';

import '../button/theme_button.dart';

class SRHandleStyle {
  String title = '确定';
  Color backgroundColor = QMColor.COLOR_00B276;
  Color highlightColor = QMColor.COLOR_00B276.applyOpacity(0.4);
  double fontSize = 14;
  Color textColor = Colors.white;
  double textHeight = 24 / 16;
  SRHandleStyle.primary({this.title = "确定"});
  SRHandleStyle.cancel({this.title = "取消"}) {
    backgroundColor = QMColor.COLOR_F1FBF5;
    highlightColor = QMColor.COLOR_F1FBF5.applyOpacity(0.4);
    textColor = QMColor.COLOR_00B276;
  }
  SRHandleStyle.delete({this.title = "删除"}) {
    backgroundColor = QMColor.COLOR_FF3F3F;
    highlightColor = QMColor.COLOR_FF3F3F.applyOpacity(0.4);
  }
  SRHandleStyle.gray({this.title = "取消"}) {
    backgroundColor = QMColor.COLOR_F2F2F2;
    highlightColor = QMColor.COLOR_F2F2F2.applyOpacity(0.4);
    textColor = QMColor.COLOR_030319;
  }
}

class SRAlertWidget extends StatelessWidget {
  final void Function()? onConfirm;
  final void Function(int idx, SRHandleStyle style)? onHandleItemClick;
  final String title;
  final String message;
  final List<SRHandleStyle>? handles;
  const SRAlertWidget({
    Key? key,
    this.onConfirm,
    this.title = "完成认证",
    this.message = "是否已通过支付宝和微信支付的商户号认证",
    this.handles,
    this.onHandleItemClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      title.toText(
        color: QMColor.COLOR_030319,
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w500,
      ),
      12.inColumn,
      message
          .toText(
            color: QMColor.COLOR_8F92A1,
            fontSize: 14,
            height: 20 / 14,
            textAlign: TextAlign.center,
            maxLines: 5,
          )
          .expanded
          .toRow(),
      24.inColumn,
      (handles ?? []).isNotEmpty.toWidget(
            () => (handles!
                    .expand((el) => [
                          ThemeButton(
                            childBuilder: (_) => el.title.toText(
                              color: el.textColor,
                              fontSize: el.fontSize,
                              height: el.textHeight,
                            ),
                            height: 44,
                            backgroundColor: el.backgroundColor,
                            highlightColor: el.highlightColor,
                            borderRadius: 6,
                            onClick: () {
                              Navigator.of(context).pop();
                              onHandleItemClick?.call(handles!.indexOf(el), el);
                            },
                          ).expanded,
                          12.inRow
                        ])
                    .toList()
                  ..removeLast())
                .toRow(),
            falseBuilder: () => [
              ThemeButton(
                childBuilder: (_) => "取消".toText(
                  color: QMColor.COLOR_00B276,
                  fontSize: 16,
                  height: 24 / 16,
                ),
                height: 44,
                backgroundColor: QMColor.COLOR_F1FBF5,
                highlightColor: QMColor.COLOR_F1FBF5.applyOpacity(0.4),
                borderRadius: 6,
                onClick: () {
                  Navigator.of(context).pop();
                },
              ).expanded,
              12.inRow,
              ThemeButton(
                childBuilder: (_) => "已完成".toText(
                  color: Colors.white,
                  fontSize: 16,
                  height: 24 / 16,
                ),
                height: 44,
                backgroundColor: QMColor.COLOR_00B276,
                highlightColor: QMColor.COLOR_00B276.applyOpacity(0.4),
                borderRadius: 6,
                onClick: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ).expanded,
            ].toRow(),
          ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.center).applyBackground(
          padding: EdgeInsets.all(16),
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        );
  }
}
