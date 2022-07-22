import 'package:flutter/material.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/app.dart';

import 'animation/slide_transition_widget.dart';

class QM {
  static void showLoading({BuildContext? context, String? msg}) {
    if (_loadingShowing) return;
    BuildContext? ctx = context ?? App.navigatorKey.currentContext;
    if (ctx == null) return;
    _loadingShowing = true;
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: ctx,
      builder: (_) => [
        const CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ).applyBackground(height: 20, width: 20),
        ((msg ?? "").isNotEmpty).toWidget(
          () => msg!
              .toText(color: Colors.white, fontSize: 12)
              .applyPadding(const EdgeInsets.only(top: 10)),
        ),
      ]
          .toColumn(mainAxisSize: MainAxisSize.min)
          .applyBackground(
            height: 90,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.applyOpacity(0.7),
              borderRadius: BorderRadius.circular(5),
            ),
          )
          .applyUnconstrainedBox(),
    ).then((value) => _loadingShowing = false);
  }

  static bool _loadingShowing = false;
  static void dismissLoading({BuildContext? context}) {
    if (_loadingShowing) {
      App.pop();
      _loadingShowing = false;
    }
  }

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

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
          Container().onClick(() {
            overlayRef.remove();
          }).expanded,
          SlideTransitionWidget(
            duration: duration,
            childBuilder: overlayBuilder,
          )
        ].toColumn(),
      ),
    );
    Overlay.of(context)?.insert(overlay);
    overlay.markNeedsBuild();
    overlayRef = overlay;
    return overlay;
  }
}
