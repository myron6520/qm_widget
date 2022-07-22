import 'package:flutter/material.dart';

extension NameExOnWidget on Widget {
  String get name {
    List<int> nameUnits = runtimeType.toString().codeUnits;
    List<int> codeUnits = [];
    for (var e in nameUnits) {
      if (64 < e && e < 91) {
        codeUnits.addAll("_".codeUnits);
        codeUnits.add(e + 32);
      } else {
        codeUnits.add(e);
      }
    }
    String name = String.fromCharCodes(codeUnits);
    if (name.startsWith("_")) return name.substring(1);
    return name;
  }
}

class App {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static Future<T?>? push<T extends Object?>(Widget page, {String? name}) =>
      pushRoute<T>(MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: name ?? page.name),
      ));

  static Future<T?>? pushRoute<T extends Object?>(Route<T> route) =>
      navigatorKey.currentState?.push<T>(route);

  static Future<T?>? replace<T extends Object?>(Widget page, {String? name}) =>
      replaceRoute<T>(MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: name ?? page.name),
      ));
  static Future<T?>? replaceRoute<T extends Object?>(Route<T> route) =>
      navigatorKey.currentState?.pushReplacement(route);
  static Future<T?>? pushAndRemoveAll<T extends Object?>(Widget page,
          {String? name}) =>
      pushRouteAndRemoveAll(MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: name ?? page.name),
      ));
  static Future<T?>? pushRouteAndRemoveAll<T extends Object?>(Route<T> route) =>
      navigatorKey.currentState
          ?.pushAndRemoveUntil(route, (Route<dynamic> route) => false);

  static void pop<T extends Object?>([T? data]) =>
      navigatorKey.currentState?.pop(data);
  static void tryToPop<T extends Object?>([T? data]) {
    if (canPop) {
      navigatorKey.currentState?.pop(data);
    }
  }

  static bool get canPop => navigatorKey.currentState?.canPop() ?? false;
  static void popUntil(String pageName) =>
      navigatorKey.currentState?.popUntil(ModalRoute.withName(pageName));
}
