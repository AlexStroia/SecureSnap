import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../di.dart';
import 'controller.dart';
import 'frame_binding_mixin.dart';

typedef ControllerCreate<T extends Controller> =
    T Function(BuildContext context, DependencyContext dependencyContext);

typedef RegistrarWidgetBuilder<T extends Controller> =
    Widget Function(BuildContext context, T controller, Widget? child);

typedef RegistrarWidgetListener<T extends Controller> =
    void Function(T controller);

class ControllerRegistrar<T extends Controller> extends StatelessWidget {
  const ControllerRegistrar({
    required this.create,
    required this.builder,
    this.child,
    this.listener,
    this.didRenderFrame,
    super.key,
  });

  final ControllerCreate<T> create;
  final RegistrarWidgetBuilder<T> builder;
  final Widget? child;
  final RegistrarWidgetListener<T>? listener;
  final RegistrarWidgetListener<T>? didRenderFrame;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) {
        return create(context, dependencyContext);
      },
      child: Consumer<T>(
        builder: (context, controller, child) {
          return _UpdateListener(
            controller: listener == null ? null : controller,
            onUpdate: () => listener?.call(controller),
            onRenderFrame: () => didRenderFrame?.call(controller),
            child: builder(context, controller, child),
          );
        },
        child: child,
      ),
    );
  }
}

class _UpdateListener extends StatefulWidget {
  const _UpdateListener({
    required this.controller,
    required this.onUpdate,
    required this.onRenderFrame,
    required this.child,
  });

  final Controller? controller;
  final VoidCallback onUpdate;
  final VoidCallback? onRenderFrame;
  final Widget child;

  @override
  State<_UpdateListener> createState() => _UpdateListenerState();
}

class _UpdateListenerState extends State<_UpdateListener> with FrameBinding {
  @override
  void didRenderFrame() {
    widget.controller?.addListener(_didUpdateControllerProxy);
    widget.onRenderFrame?.call();
    super.didRenderFrame();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_didUpdateControllerProxy);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _didUpdateControllerProxy() {
    if (!mounted) {
      return;
    }

    widget.onUpdate();
  }
}
