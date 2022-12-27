import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class OverlayWidgets extends StatelessWidget {
  final Widget child;

  const OverlayWidgets({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (ctx, childWidget) {
          return Transform(
            transform: notifier.value,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
