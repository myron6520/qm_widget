import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:qm_widget/pub/scale_util.dart';
import 'package:qm_widget/qm_widget.dart';

class NetProvider<T> extends RespProvider {
  NetProvider({required this.loadFunc, this.dataChanged}) : super();
  final Future<NetResp<T?>> Function()? loadFunc;
  void Function(NetResp<T?> resp)? dataChanged;
  T? _data;
  T? get data => _data;
  set data(T? data) {
    _data = data;
    commit();
  }

  NetResp<T?>? _response;
  NetResp<T?>? get response => _response;
  Future<NetResp<T?>?> loadData() async {
    if (loadFunc == null) return null;
    Future<NetResp<T?>> future = loadFunc!.call();
    NetResp<T?> res = await future;
    _response = res;
    code = res.code;
    msg = res.msg;
    if (res.isOK) {
      _data = res.data;
      dataChanged?.call(res);
      status = RespStatus.ok;
    } else {
      _data = null;
      dataChanged?.call(res);
      status = RespStatus.error
        ..code = code
        ..msg = msg;
    }
    return res;
  }
}

class NetWidget<T> extends StatefulWidget {
  const NetWidget(
    this.loadFunc, {
    Key? key,
    this.didGetProvider,
    required this.builder,
    this.sliver = false,
    this.statusWidgetBuilder,
    this.dataChanged,
    this.autoLoad = true,
    this.refreshEnable = false,
    this.refreshColor = QMColor.COLOR_00B276,
    this.waterDropColor = Colors.white,
    this.refreshHeader,
  }) : super(key: key);
  final Future<NetResp<T>> Function()? loadFunc;
  final Function(NetProvider<T>)? didGetProvider;
  final Widget Function(BuildContext context, NetProvider<T> provider) builder;
  final bool sliver;
  final bool autoLoad;
  final Widget? Function(NetProvider<T>)? statusWidgetBuilder;
  final Function(NetResp<T?> resp)? dataChanged;
  final bool refreshEnable;
  final Widget? refreshHeader;
  final Color refreshColor;
  final Color waterDropColor;

  @override
  State<NetWidget<T>> createState() => _NetWidgetState<T>();
}

class _NetWidgetState<T> extends State<NetWidget<T>> {
  void _loadData(NetProvider<T> provider) {
    provider.status = RespStatus.loading;
    provider.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NetProvider<T>>(
      create: (_) {
        var p = NetProvider<T>(
            loadFunc: widget.loadFunc, dataChanged: widget.dataChanged);
        widget.didGetProvider?.call(p);
        if (widget.autoLoad) {
          _loadData(p);
        }
        return p;
      },
      child: Consumer<NetProvider<T>>(
        builder: (ctx, provider, __) => RespWidget(
          provider.status,
          sliver: widget.sliver,
          statusWidgetBuilder: widget.statusWidgetBuilder != null
              ? (_) => widget.statusWidgetBuilder?.call(provider)
              : null,
          builder: (_) => widget.refreshEnable
              ? SmartRefresher(
                  controller: controller,
                  enablePullUp: false,
                  enablePullDown: true,
                  header: widget.refreshHeader ??
                      WaterDropHeader(
                        waterDropColor: widget.waterDropColor,
                        idleIcon: Icon(
                          Icons.autorenew,
                          size: 16.s,
                          color: widget.refreshColor,
                        ),
                        refresh: SizedBox(
                          width: 20.s,
                          height: 20.s,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0.s,
                            color: widget.waterDropColor,
                          ),
                        ),
                        complete: Icon(
                          Icons.done,
                          color: widget.waterDropColor,
                          size: 20.s,
                        ),
                      ),
                  onRefresh: () async {
                    await provider.loadData();
                    controller.refreshCompleted(resetFooterState: true);
                  },
                  child: widget.builder.call(ctx, provider),
                )
              : widget.builder.call(ctx, provider),
          onTap: () => _loadData(provider),
        ),
      ),
    );
  }

  late RefreshController controller = RefreshController();
}
