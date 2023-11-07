// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

enum RefStatus { unload, normal, load }

class RefStatusWidget extends StatefulWidget {
  RefStatusWidget(
      {Key? key,
      required this.refStatus,
      required this.loadFunc,
      required this.builder})
      : super(key: key);

  final ValueNotifier<RefStatus> refStatus;
  final Future<void> Function() loadFunc;
  final Widget Function() builder;
  @override
  _RefStatusWidgetState createState() => _RefStatusWidgetState();
}

class _RefStatusWidgetState extends State<RefStatusWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder.call();
  }

  @override
  void initState() {
    super.initState();
    widget.refStatus.addListener(_refStatusChanged);
    _refStatusChanged();
  }

  void refWidget() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.refStatus.removeListener(_refStatusChanged);
    super.dispose();
  }

  void _refStatusChanged() {
    if (widget.refStatus.value == RefStatus.load) {
      widget.loadFunc.call().then((_) {
        widget.refStatus.value = RefStatus.normal;
        refWidget();
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}

extension RefStatusWidgetExOnWidget on Widget {
  RefStatusWidget applyRefStatus(ValueNotifier<RefStatus> refStatus,
          Future<void> Function() loadFunc) =>
      RefStatusWidget(
        refStatus: refStatus,
        loadFunc: loadFunc,
        builder: () => this,
      );
}
