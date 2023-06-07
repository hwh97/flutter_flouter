import 'package:flutter/widgets.dart';

const _kCompleteWaitDuration = Duration(milliseconds: 200);

class FlouterObserver extends NavigatorObserver {
  Duration? _completeWaitDuration;

  Duration get completeWaitDuration =>
      _completeWaitDuration ?? _kCompleteWaitDuration;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // 根据name排除dialog类型路由
    if (route is TransitionRoute && route.settings.name != null) {
      _completeWaitDuration = route.transitionDuration;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // 根据name排除dialog类型路由
    if (previousRoute is TransitionRoute && route.settings.name != null) {
      _completeWaitDuration = previousRoute.transitionDuration;
    }
  }
}
