import 'package:flutter/material.dart';
import 'package:flutter_flouter/flutter_flouter.dart';
import 'package:flutter_flouter_example/router/base_navigator.route.dart';

final Router router = Router([]);

class Router {
  late final BaseNavigator router;
  late final RouteInformationParser<Uri> routeInformationParser;
  late final FlouterRouterDelegate routerDelegate;
  late final GlobalKey<NavigatorState> navigatorKey;

  Router(List<NavigatorObserver> observer) {
    router = BaseNavigator(observer);
    routeInformationParser = router.routeInformationParser;
    routerDelegate = router.routerDelegate;
    navigatorKey = router.navigatorKey;
  }

  /// Use routerDelegate to write your router method below
  /// like `push`, `pop`...
}

abstract class BaseNavigator {
  factory BaseNavigator(List<NavigatorObserver> observers) {
    return $BaseNavigator(observers);
  }

  GlobalKey<NavigatorState> get navigatorKey;

  FlouterRouterDelegate get routerDelegate;

  RouteInformationParser<Uri> get routeInformationParser;
}
