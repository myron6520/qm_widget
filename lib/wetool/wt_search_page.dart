// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/net/net_resp.dart';
import 'package:qm_widget/provider/list_widget.dart';
import 'package:qm_widget/provider/page_widget.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/style/qm_color.dart';
import 'package:qm_widget/wetool/wetool.dart';

class WTSearchPage<T> extends StatefulWidget {
  final String searchHint;
  final void Function()? onCancel;
  final Future<NetResp<List<T>>> Function(
      int page, int pageSize, String keyword) loadFunc;
  final Widget Function(BuildContext context, int index, T itemData)
      itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  final Widget? Function(PageProvider<T>)? statusWidgetBuilder;
  const WTSearchPage(
      {super.key,
      this.searchHint = "搜索",
      this.onCancel,
      required this.loadFunc,
      required this.itemBuilder,
      this.separatorBuilder,
      this.statusWidgetBuilder});

  @override
  State<WTSearchPage<T>> createState() => _WTSearchPageState();
}

class _WTSearchPageState<T> extends State<WTSearchPage<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: [
        [
          16.s.inRow,
          WTInputWidget(
            hint: widget.searchHint,
            controller: keywordController,
            contentPadding: EdgeInsets.symmetric(vertical: 8.s),
            showInputBottomBorder: false,
            left: SvgPicture.string(WTIcon.SEARCH, width: 20.s, height: 20.s)
                .applyPadding(EdgeInsets.only(right: 4.s)),
            onSubmitted: (str) => doSearch(),
            onInputChanged: (str) => doSearch(),
          )
              .applyBackground(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.s,
                  ),
                  decoration: BoxDecoration(
                    color: QMColor.COLOR_F7F9FA,
                    borderRadius: BorderRadius.circular(4.s),
                  ))
              .expanded,
          "取消"
              .toText(
                color: QMColor.COLOR_00B276,
                fontSize: 16.fs,
                height: 24 / 16,
              )
              .applyPadding(EdgeInsets.symmetric(horizontal: 16.s))
              .onClick(click: () => widget.onCancel?.call()),
        ]
            .toRow()
            .applyBackground(
              padding: EdgeInsets.symmetric(vertical: 8.s),
            )
            .toSafe()
            .applyBackground(
              color: Colors.white,
            ),
        8.s.inColumn,
        ListWidget<T>(
          loadFunc: (page, pageSize) => widget.loadFunc.call(
            page,
            pageSize,
            keywordController.text,
          ),
          didGetProvider: (p) => provider = p,
          statusWidgetBuilder: widget.statusWidgetBuilder,
          itemBuilder: widget.itemBuilder,
          separatorBuilder: widget.separatorBuilder,
        ).expanded,
      ].toColumn(),
    );
  }

  StreamSubscription<void>? listener;
  late PageProvider<T> provider;
  late TextEditingController keywordController = TextEditingController();
  void doSearch() {
    listener?.cancel();
    Future future = Future.delayed(Duration(milliseconds: 200));
    listener = future.asStream().listen((_) {
      provider.reloadData();
    });
  }
}
