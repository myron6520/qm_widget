import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';

import '../animation/slide_transition_widget.dart';

class OverlayManager {
  static Map<BuildContext, List<OverlayEntry>> _overlays = {};
  static OverlayEntry showOverlay(
    BuildContext context, {
    required Widget Function() overlayBuilder,
    Widget Function(Widget)? builder,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    late OverlayEntry overlayRef;
    OverlayEntry overlay = OverlayEntry(
      builder: (_) => (builder ?? (p) => p).call(
        [
          Container().onClick(click: () {
            overlayRef.remove();
          }).expanded,
          SlideTransitionWidget(
            duration: duration,
            childBuilder: overlayBuilder,
          )
        ].toColumn(),
      ),
    );
    Overlay.of(context).insert(overlay);
    overlay.markNeedsBuild();
    overlayRef = overlay;
    return overlay;
  }
}
