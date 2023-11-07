import 'package:flutter/material.dart';

class NotificationCenter {
  static Map<String, List<Function(dynamic object)>> _events = {};
  static void register(String name, Function(dynamic object) selector) {
    debugPrint("register:$name");
    List<Function(dynamic object)> targets = _events[name] ?? [];
    targets.add(selector);
    _events[name] = targets;
  }

  static void unregister(String name, Function(dynamic object) selector) {
    debugPrint("unregister:$name");
    List<Function(dynamic object)> targets = _events[name] ?? [];
    if (targets.isNotEmpty) {
      targets.removeWhere((element) => element == selector);
    }
  }

  static void post(String name, {dynamic object}) {
    List targets = _events[name] ?? [];
    for (var e in targets) {
      e?.call(object);
    }
  }

  static int targetNum(String name) => (_events[name] ?? []).length;
}
