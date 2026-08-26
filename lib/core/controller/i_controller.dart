import 'dart:async';

abstract class IControllerEvent {
  const IControllerEvent();
}

abstract class IController {
  Future<void> init();
  Future<void> dispose() async {
    await _con.close();
  }

  void addEvent(IControllerEvent event) {
    _con.add(event);
  }

  final _con = StreamController<IControllerEvent>.broadcast();
  Stream<IControllerEvent> get events => _con.stream;
}

class ControllerManager {
  static final _map = <Type, IController>{};

  static void register(IController controller) {
    final old = _map[controller.runtimeType];
    if (old != null) {
      throw Exception('controller already exists!');
    }
    _map[controller.runtimeType] = controller;
  }

  static T read<T extends IController>() {
    final old = _map[T];
    if (old == null) {
      throw Exception('`$T`: controller need to register!');
    }
    return old as T;
  }
}
