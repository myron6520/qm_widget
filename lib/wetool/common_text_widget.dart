import 'package:flutter/material.dart';
import 'package:qm_widget/qm_widget.dart';

///封装text
class CommonTextWidget {
  static Text text(
    String? text, {
    double size = 14,
    Color? color,
    FontWeight weight = FontWeight.normal,
    int line = 1,
    TextAlign align = TextAlign.start,
    TextDecoration decoration = TextDecoration.none,
    double letterSp = 1.0,
    bool soft = true,
    TextOverflow flow = TextOverflow.ellipsis,
    double h = 1.4,
    bool useTextAsKey = false,
  }) {
    return Text(text != null ? text : "",
        key: useTextAsKey ? ValueKey(text != null ? text : "") : null,

        // style: TextStyle(fontSize: ScreenAdaper.setSp(size),
        style: TextStyle(
            fontSize: size,
            color: color == null ? QMColor.COLOR_030319 : color,
            fontWeight: weight,
            decoration: decoration,

            ///绘制文本装饰:下划线（TextDecoration.underline）上划线（TextDecoration.overline）删除线（TextDecoration.lineThrough）letterSpacing: letterSp,
            height: h),
        textScaleFactor: 1.0,
        overflow: flow,

        ///如何处理视觉溢出: TextOverflow.clip 剪切溢出的文本以修复其容器。   TextOverflow.ellipsis 使用省略号表示文本已溢出。 TextOverflow.fade  将溢出的文本淡化为透明。
        maxLines: line,
        textAlign: align,

        ///文本对齐容器方位
        softWrap: soft

        ///某一行中文本过长，是否需要换行。默认为true，如果为false，则文本中的字形将被定位为好像存在无限的水平空间。
        );
  }
}
