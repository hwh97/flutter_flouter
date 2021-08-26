import 'package:flutter_flouter/flutter_flouter.dart';
import 'package:flutter_flouter_example/page/home_page.dart';
import 'package:flutter_flouter_example/page/page2.dart';
import 'package:flutter_flouter_example/page/page3.dart';

import 'base_navigator.dart';
import 'package:flutter/material.dart';

class $BaseNavigator implements BaseNavigator {
  final List<NavigatorObserver> observers;

  $BaseNavigator(this.observers);

  static final page2 = "/page2";
  static final home = "/home";
  static final page3 = "/page3";

  @override
  FlouterRouterDelegate get routerDelegate {
    return FlouterRouterDelegate(
      navigatorKey: navigatorKey,
      routes: {
        RegExp(r"^/home$"): (routeInformation) => MyHomePageRoute(routeInformation),
        RegExp(r"^/page2$"): (routeInformation) => Page2Route(routeInformation),
        RegExp(r"^/page3$"): (routeInformation) => Page3Route(routeInformation),
      },
      observers: observers,
      initialUris: [
        Uri.parse("/home"),
      ],
    );
  }
}

/// define pages
class MyHomePageRoute extends Page {
  final FlouterRouteInformation routeInformation;

  MyHomePageRoute(this.routeInformation)
      : super(name: routeInformation.uri.path);

  @override
  LocalKey? get key => ObjectKey(routeInformation);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        return HomePage();
      },
    );
  }
}

class Page2Route extends Page {
  final FlouterRouteInformation routeInformation;

  Page2Route(this.routeInformation) : super(name: routeInformation.uri.path);

  @override
  LocalKey? get key => ObjectKey(routeInformation);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        final Map<String, String> p = routeInformation.uri.queryParameters;
        return Page2(
          value: p['value'],
        );
      },
    );
  }
}

class Page3Route extends Page {
  final FlouterRouteInformation routeInformation;

  Page3Route(this.routeInformation) : super(name: routeInformation.uri.path);

  @override
  LocalKey? get key => ObjectKey(routeInformation);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        final Map<String, String> p = routeInformation.uri.queryParameters;
        return Page3(
          value: p["value"],
        );
      },
    );
  }
}
