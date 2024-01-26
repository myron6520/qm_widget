import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/pub/scale_util.dart';

class WaitingWidget extends StatelessWidget {
  final Widget child;
  final bool waiting;
  const WaitingWidget({super.key, required this.child, this.waiting = true});

  @override
  Widget build(BuildContext context) {
    return [
      child.toCenter(),
      waiting
          .toWidget(() => AbsorbPointer(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.s,
                ),
              )
                  .applyBackground(
                    width: 16.s,
                    height: 16.s,
                  )
                  .applyUnconstrainedBox()
                  .applyBackground(color: Colors.black.applyOpacity(0.4)))
          .toPositionedFill(),
    ].toStack();
  }
}
