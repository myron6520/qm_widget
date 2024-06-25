import 'package:flutter/cupertino.dart';
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
  static bool useCupertinoPageRoute = true;
  static NavigatorState? findNavigatorState({BuildContext? context}) => context == null ? navigatorKey.currentState : Navigator.of(context);
  static Future<T?>? push<T extends Object?>(Widget page, {String? name, BuildContext? context}) => pushRoute<T>(
        useCupertinoPageRoute
            ? CupertinoPageRoute(
                builder: (_) => page,
                settings: RouteSettings(name: name ?? page.name),
              )
            : MaterialPageRoute(
                builder: (_) => page,
                settings: RouteSettings(name: name ?? page.name),
              ),
        context,
      );

  static Future<T?>? pushRoute<T extends Object?>(Route<T> route, BuildContext? context) => findNavigatorState(context: context)?.push<T>(route);

  static Future<T?>? replace<T extends Object?>(Widget page, {String? name, BuildContext? context}) => replaceRoute<T>(
      useCupertinoPageRoute
          ? CupertinoPageRoute(
              builder: (_) => page,
              settings: RouteSettings(name: name ?? page.name),
            )
          : MaterialPageRoute(
              builder: (_) => page,
              settings: RouteSettings(name: name ?? page.name),
            ),
      context);
  static Future<T?>? replaceRoute<T extends Object?>(Route<T> route, BuildContext? context) => findNavigatorState(context: context)?.pushReplacement(route);
  static Future<T?>? pushAndRemoveAll<T extends Object?>(Widget page, {String? name, BuildContext? context}) => pushRouteAndRemoveAll(
      useCupertinoPageRoute
          ? CupertinoPageRoute(
              builder: (_) => page,
              settings: RouteSettings(name: name ?? page.name),
            )
          : MaterialPageRoute(
              builder: (_) => page,
              settings: RouteSettings(name: name ?? page.name),
            ),
      context);
  static Future<T?>? pushRouteAndRemoveAll<T extends Object?>(Route<T> route, BuildContext? context) => findNavigatorState(context: context)?.pushAndRemoveUntil(route, (Route<dynamic> route) => false);

  static void pop<T extends Object?>({BuildContext? context, T? data}) => tryToPop(context: context, data: data);
  static void tryToPop<T extends Object?>({BuildContext? context, T? data}) {
    if (canPop(context: context)) {
      findNavigatorState(context: context)?.pop(data);
    }
  }

  static bool canPop({BuildContext? context}) => findNavigatorState(context: context)?.canPop() ?? false;
  static void popUntil(String pageName, {BuildContext? context}) => findNavigatorState(context: context)?.popUntil(ModalRoute.withName(pageName));
}
