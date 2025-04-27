import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

mixin FrameBinding<T extends StatefulWidget> on State<T> {
  @protected
  @nonVirtual
  void runPostFrame(VoidCallback callback) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => callback());

  @override
  void initState() {
    super.initState();

    runPostFrame(didRenderFrame);
  }

  /// This method is called when the first frame is rendered. This is a safe place
  /// to access the [BuildContext] to get any available data from inherited widgets.
  /// It is also a good entry point for calling some operations that should be
  /// triggered when the widget appears.
  @protected
  @mustCallSuper
  void didRenderFrame() {}
}
