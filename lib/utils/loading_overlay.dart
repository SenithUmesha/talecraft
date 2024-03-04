import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay extends StatelessWidget {
  final OverlayEntry _overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.5)),
        Center(
          child: SpinKitFadingCube(color: Colors.white, size: 50.0),
        ),
      ],
    ),
  );

  void show(BuildContext context) {
    Overlay.of(context).insert(_overlayEntry);
  }

  void hide() {
    _overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
