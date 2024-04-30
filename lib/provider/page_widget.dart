// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/net/net_resp.dart';
import 'package:qm_widget/pub/scale_util.dart';

import '../style/qm_color.dart';

class PageProvider<T> extends RespProvider {
  PageProvider(
    this.loadFunc, {
    this.dataChanged,
    this.appendDataFunc,
    this.isEndCheckFunc,
    this.startPage = 1,
    this.pageSize = 10,
    this.checkNoData = true,
  }) : super();
  final Future<NetResp<List<T>>> Function(int page, int pageSize) loadFunc;
  final int startPage;
  final int pageSize;
  final bool checkNoData;
  final List<T> Function(List<T>, NetResp<List<T>> resp)? appendDataFunc;
  Function(NetResp<List<T>> resp)? dataChanged;
  bool Function(NetResp<List<T>> resp)? isEndCheckFunc;

  NetResp<List<T>>? resp;
  bool isEnd = true;
  List<T> data = [];
  int? _page;
  int? get page => _page;
  Future<void> reloadData() async {
    _page = startPage;
    await _loadData();
  }

  Future<void> loadMore() async {
    if (_page == null) {
      await reloadData();
      return;
    }
    _page = _page! + 1;
    await _loadData();
  }

  Future<NetResp<List<T>>> _loadData() async {
    Future<NetResp<List<T>>> future = loadFunc.call(_page ?? startPage, pageSize);
    NetResp<List<T>> res = await future;
    _loadDataFinished(res);
    return res;
  }

  void _loadDataFinished(NetResp<List<T>> res) {
    resp = res;
    code = res.code;
    msg = res.msg;
    if (res.isOK) {
      if (_page == 1) {
        data.clear();
      }
      if (res.data == null) {
        status = RespStatus.error;
      } else {
        int len = data.length;
        data = (appendDataFunc ?? (container, resp) => container..addAll(resp.data ?? [])).call(data, res);
        int appendLen = data.length - len;
        // data.addAll(res.data ?? []);
        if (checkNoData && data.isEmpty) {
          isEnd = true;
          status = RespStatus.empty;
        } else {
          isEnd = isEndCheckFunc?.call(res) ?? (appendLen < pageSize);
          status = RespStatus.ok;
        }
      }
    } else {
      status = RespStatus.error
        ..code = code
        ..msg = msg;
    }
    dataChanged?.call(res);
  }

  void removeItemAtIndex(int index) {
    if (index < data.length) {
      data.removeAt(index);
      if (data.isEmpty) {
        if (isEnd) {
          status = RespStatus.empty;
        } else {
          status = RespStatus.loading;
          reloadData();
        }
      } else {
        commit();
      }
    }
  }
}

class PageWidget<T> extends StatelessWidget {
  const PageWidget(
    this.loadFunc, {
    Key? key,
    required this.builder,
    this.sliver = false,
    this.autoLoad = true,
    this.didGetProvider,
    this.statusWidgetBuilder,
    this.onStatusWidgetClick,
    this.dataChanged,
    this.checkNoData = true,
    this.pageSize = 10,
    this.appendDataFunc,
    this.isEndCheckFunc,
  }) : super(key: key);
  final Future<NetResp<List<T>>> Function(int page, int pageSize) loadFunc;
  final Widget Function(BuildContext context, PageProvider<T> provinder) builder;
  final bool sliver;
  final bool autoLoad;
  final int pageSize;
  final Function(PageProvider<T> provider)? didGetProvider;
  final Widget? Function(PageProvider<T>)? statusWidgetBuilder;
  final Function(PageProvider<T>)? onStatusWidgetClick;
  final Function(NetResp<List<T>> resp)? dataChanged;
  final bool checkNoData;
  final List<T> Function(List<T>, NetResp<List<T>> resp)? appendDataFunc;
  final bool Function(NetResp<List<T>> resp)? isEndCheckFunc;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageProvider<T>>(
      create: (_) {
        var p = PageProvider<T>(loadFunc, dataChanged: dataChanged, checkNoData: checkNoData, appendDataFunc: appendDataFunc, isEndCheckFunc: isEndCheckFunc, pageSize: pageSize);
        didGetProvider?.call(p);
        if (autoLoad) {
          p.status = RespStatus.loading;
          p.reloadData();
        }
        return p;
      },
      child: Consumer<PageProvider<T>>(
        builder: (ctx, provider, __) => RespWidget(
          provider.status,
          sliver: sliver,
          statusWidgetBuilder: statusWidgetBuilder != null ? (_) => statusWidgetBuilder!.call(provider) : null,
          builder: (_) => builder.call(ctx, provider),
          onTap: () {
            if (onStatusWidgetClick != null) {
              onStatusWidgetClick?.call(provider);
            } else {
              provider.status = RespStatus.loading;
              provider.reloadData();
            }
          },
        ),
      ),
    );
  }
}

class PageRefWidget<T> extends StatelessWidget {
  const PageRefWidget(this.loadFunc, {Key? key, required this.builder, this.sliver = false, this.autoLoad = true, this.didGetProvider, this.statusWidgetBuilder, this.onStatusWidgetClick, this.dataChanged, this.checkNoData = true, this.pageSize = 10, this.refreshColor = Colors.white, this.waterDropColor = QMColor.COLOR_00B276, this.refreshHeader, this.appendDataFunc, this.refreshController, this.enablePullUp = true}) : super(key: key);
  final Future<NetResp<List<T>>> Function(int page, int pageSize) loadFunc;
  final Widget Function(BuildContext context, PageProvider<T> provider) builder;
  final bool sliver;
  final bool autoLoad;
  final Function(PageProvider<T> provider)? didGetProvider;
  final Widget? Function(PageProvider<T>)? statusWidgetBuilder;
  final Function(PageProvider<T>)? onStatusWidgetClick;
  final Function(NetResp<List<T>> resp)? dataChanged;
  final List<T> Function(List<T>, NetResp<List<T>> resp)? appendDataFunc;
  final bool checkNoData;
  final int pageSize;
  final Widget? refreshHeader;
  final Color refreshColor;
  final Color waterDropColor;
  final RefreshController? refreshController;
  final bool enablePullUp;

  @override
  Widget build(BuildContext context) {
    RefreshController controller = refreshController ?? RefreshController();
    return PageWidget<T>(
      loadFunc,
      sliver: sliver,
      autoLoad: autoLoad,
      didGetProvider: didGetProvider,
      statusWidgetBuilder: statusWidgetBuilder,
      onStatusWidgetClick: onStatusWidgetClick,
      dataChanged: dataChanged,
      checkNoData: checkNoData,
      appendDataFunc: appendDataFunc,
      pageSize: pageSize,
      builder: (ctx, provider) => SmartRefresher(
        controller: controller,
        // enablePullUp:enablePullUp,
        enablePullDown: true,
        enablePullUp: enablePullUp && !provider.isEnd,
        footer: ClassicFooter(
          loadingText: "",
          noDataText: "",
          outerBuilder: (child) => child,
          noMoreIcon: "已加载完全部".toText(
            color: QMColor.COLOR_BDBDBD,
            fontSize: 14.fs,
            height: 20 / 14,
          ),
          loadingIcon: SizedBox(
            width: 20.s,
            height: 20.s,
            child: CircularProgressIndicator(
              strokeWidth: 2.0.s,
              color: waterDropColor,
            ),
          ),
        ),
        header: refreshHeader ??
            WaterDropHeader(
              waterDropColor: waterDropColor,
              idleIcon: Icon(
                Icons.autorenew,
                size: 16.s,
                color: refreshColor,
              ),
              refresh: SizedBox(
                width: 20.s,
                height: 20.s,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0.s,
                  color: waterDropColor,
                ),
              ),
              complete: Icon(
                Icons.done,
                color: waterDropColor,
                size: 20.s,
              ),
            ),
        onRefresh: () async {
          await provider.reloadData();
          controller.refreshCompleted(resetFooterState: true);
        },
        onLoading: provider.isEnd
            ? null
            : () async {
                await provider.loadMore();
                controller.loadComplete();
              },
        child: builder.call(ctx, provider),
      ),
    );
  }
}
