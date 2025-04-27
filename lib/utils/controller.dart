import 'dart:async';

import 'package:flutter/foundation.dart';

import 'disposable.dart';

abstract interface class OneTimeEvent {
  const OneTimeEvent();
}

class OneTimeEventWithException<T extends Object> implements OneTimeEvent {
  const OneTimeEventWithException(this.exception);

  final T exception;
}

class Controller extends ChangeNotifier implements Disposable {
  Controller() {
    didCreateController();
  }

  @protected
  void tryNotifyListeners([Object? _, Object? _]) {
    if (hasListeners) {
      notifyListeners();
    }
  }

  @override
  @mustCallSuper
  FutureOr<void> dispose() async {
    super.dispose();
  }

  @protected
  @mustCallSuper
  Future<void> didCreateController() async {}

  @nonVirtual
  OneTimeEvent? _event;

  @protected
  @nonVirtual
  // ignore: avoid_setters_without_getters
  set event(OneTimeEvent? newValue) {
    _event = newValue;
  }

  bool get hasEvent => _event != null;

  @nonVirtual
  OneTimeEvent? removeEvent() {
    final event = _event;
    _event = null;
    return event;
  }

  void redirectEventFrom(Controller controller) {
    event = controller.removeEvent();
  }
}
