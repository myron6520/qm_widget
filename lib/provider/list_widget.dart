// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

import 'package:qm_widget/net/net_resp.dart';
import 'package:qm_widget/provider/page_widget.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/widgets/ref_status_widget.dart';

import '../style/qm_color.dart';

class ListWidget<T> extends StatefulWidget {
  const ListWidget({
    Key? key,
    required this.loadFunc,
    required this.itemBuilder,
    this.separatorBuilder,
    this.autoLoad = true,
    this.didGetProvider,
    this.contentPadding = EdgeInsets.zero,
    this.pageSize = 10,
    this.dataChanged,
    this.appendDataFunc,
    this.refreshController,
    this.enablePullUp = true,
    this.enablePullDown = true,
    this.statusWidgetBuilder,
    this.waterDropColor = QMColor.COLOR_00B276,
  }) : super(key: key);
  final Future<NetResp<List<T>>> Function(int page, int pageSize) loadFunc;
  final Widget Function(BuildContext context, int index, T itemData) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Function(NetResp<List<T>> resp)? dataChanged;

  final List<T> Function(List<T>, NetResp<List<T>> resp)? appendDataFunc;
  final bool autoLoad;
  final Function(PageProvider<T> provider)? didGetProvider;
  final EdgeInsetsGeometry? contentPadding;
  final int pageSize;

  final RefreshController? refreshController;
  final bool enablePullUp;
  final bool enablePullDown;
  final Widget? Function(PageProvider<T>)? statusWidgetBuilder;
  final Color waterDropColor;

  @override
  _ListWidgetState<T> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends State<ListWidget<T>> with AutomaticKeepAliveClientMixin<ListWidget<T>> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageRefWidget<T>(
      widget.loadFunc,
      refreshController: widget.refreshController,
      statusWidgetBuilder: widget.statusWidgetBuilder,
      pageSize: widget.pageSize,
      autoLoad: widget.autoLoad,
      didGetProvider: widget.didGetProvider,
      dataChanged: widget.dataChanged,
      enablePullUp: widget.enablePullUp,
      enablePullDown: widget.enablePullDown,
      appendDataFunc: widget.appendDataFunc,
      waterDropColor: widget.waterDropColor,
      builder: (_, provider) => ListView.separated(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: widget.contentPadding,
          itemBuilder: (ctx, index) => (index < provider.data.length).toWidget(
                () => widget.itemBuilder.call(ctx, index, provider.data[index]),
                falseBuilder: widget.enablePullUp
                    ? null
                    : () => "已加载完全部"
                        .toText(
                          color: QMColor.COLOR_BDBDBD,
                          fontSize: 14.fs,
                          height: 20 / 14,
                          textAlign: TextAlign.center,
                        )
                        .expanded
                        .toRow(),
              ),
          separatorBuilder: (ctx, idx) => widget.separatorBuilder?.call(ctx, idx) ?? Container(),
          itemCount: provider.data.length + (provider.isEnd && widget.enablePullUp ? 1 : 0)),
    );
  }

  @override
  bool get wantKeepAlive => true;
  late ScrollController controller = ScrollController();
}

class ListRefWidget<T> extends StatefulWidget {
  ListRefWidget({
    Key? key,
    required this.loadFunc,
    required this.itemBuilder,
    required this.refStatus,
    this.separatorBuilder,
    this.autoLoad = true,
    this.didGetProvider,
    this.pageSize = 10,
    this.dataChanged,
    this.enablePullUp = true,
  }) : super(key: key);
  final ValueNotifier<RefStatus> refStatus;
  final Future<NetResp<List<T>>> Function(int page, int pageSize) loadFunc;
  final Widget Function(BuildContext context, int index, T itemData) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Function(NetResp<List<T>> resp)? dataChanged;
  final bool autoLoad;
  final Function(PageProvider<T> provider)? didGetProvider;
  final int pageSize;
  final bool enablePullUp;

  @override
  _ListRefWidgetState createState() => _ListRefWidgetState<T>();
}

class _ListRefWidgetState<T> extends State<ListRefWidget<T>> with AutomaticKeepAliveClientMixin<ListRefWidget<T>> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListWidget<T>(
      enablePullUp: widget.enablePullUp,
      loadFunc: widget.loadFunc,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: widget.separatorBuilder,
      autoLoad: widget.autoLoad,
      pageSize: widget.pageSize,
      dataChanged: widget.dataChanged,
      didGetProvider: (p) => provider = p,
    ).applyRefStatus(widget.refStatus, () async => provider?.reloadData());
  }

  PageProvider<T>? provider;

  @override
  bool get wantKeepAlive => true;
}
