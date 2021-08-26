import 'package:flutter/material.dart';
import 'package:flutter_flouter/flutter_flouter.dart';
import 'package:flutter_flouter_example/router/base_navigator.route.dart';

final Router router = Router([]);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Router {
  late final BaseNavigator router;
  late final RouteInformationParser<Uri> routeInformationParser;
  late final FlouterRouterDelegate routerDelegate;

  Router(List<NavigatorObserver> observer) {
    router = BaseNavigator(observer);
    routeInformationParser = FlouterRouteInformationParser();
    routerDelegate = router.routerDelegate;
  }

  /// Use routerDelegate to write your router method below
  /// like `push`, `pop`...
}

abstract class BaseNavigator {
  factory BaseNavigator(List<NavigatorObserver> observers) {
    return $BaseNavigator(observers);
  }

  FlouterRouterDelegate get routerDelegate;
}
