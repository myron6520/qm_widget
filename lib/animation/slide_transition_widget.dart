// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class SlideTransitionWidget extends StatefulWidget {
  final Widget Function() childBuilder;
  final Duration duration;
  SlideTransitionWidget(
      {Key? key,
      required this.childBuilder,
      this.duration = const Duration(milliseconds: 300)})
      : super(key: key);

  @override
  State<SlideTransitionWidget> createState() => _SlideTransitionWidgetState();
}

class _SlideTransitionWidgetState extends State<SlideTransitionWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: widget.childBuilder.call(),
    );
  }

  late AnimationController controller =
      AnimationController(duration: widget.duration, vsync: this);
  late Animation<Offset> animation =
      Tween(begin: Offset(0.0, 1.0), end: Offset.zero).animate(controller);
  @override
  void initState() {
    super.initState();
    controller.forward();
  }
}
