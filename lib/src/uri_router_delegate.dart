import 'dart:async';
import 'dart:collection';

import 'package:flutter_flouter/src/route_information.dart';
import 'package:flutter_flouter/src/typedef.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'flouter_uri.dart';

/// a [RouterDelegate] based on [FlouterUri]
class FlouterRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  final GlobalKey<NavigatorState> navigatorKey;
  final List<NavigatorObserver> observers;
  final Map<RegExp, PageBuilder> routes;
  final PageBuilder? pageNotFound;
  final _internalPages = <Page>[];
  final _internalUris = <FlouterUri>[];
  bool _skipNext = false;

  FlouterRouterDelegate({
    required this.navigatorKey,
    required this.routes,
    this.pageNotFound,
    this.observers = const <NavigatorObserver>[],
    List<Uri>? initialUris,
  }) {
    final _initialUris = initialUris ?? <Uri>[Uri(path: '/')];
    for (final uri in _initialUris) {
      setNewRoutePath(uri);
    }
    _skipNext = true;
  }

  /// give you a read only access
  /// to the [List] of [Page] you have in your navigator
  List<Page> get pages => UnmodifiableListView(_internalPages);

  /// give you a read only access
  /// to the [List] of [FlouterUri] you have in your navigator
  List<FlouterUri> get uris => UnmodifiableListView(_internalUris);

  /// get the current route [Uri]
  /// this is show by the browser if your app run in the browser
  Uri? get currentConfiguration => uris.isNotEmpty ? uris.last.uri : null;

  /// @nodoc
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: observers,
      pages: List.from(pages),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (routes.isNotEmpty) {
          pop(result);
          return true;
        }
        return false;
      },
    );
  }

  /// add a new [Uri] and the corresponding [Page] on top of the navigator
  @override
  Future<void> setNewRoutePath(Uri uri) {
    return _setNewRoutePath(FlouterUri(uri));
  }

  Future<void> _setNewRoutePath(FlouterUri uri) async {
    if (_skipNext) {
      _skipNext = false;
      return SynchronousFuture(null);
    }

    bool _findRoute = false;
    for (var i = 0; i < routes.keys.length; i++) {
      final key = routes.keys.elementAt(i);
      if (key.hasMatch(uri.uri.path)) {
        final match = key.firstMatch(uri.uri.path);
        final route = routes[key]!;

        _internalPages.add(route(FlouterRouteInformation(uri.uri, match)));
        _internalUris.add(uri);
        _findRoute = true;
        break;
      }
    }
    if (!_findRoute) {
      var page = pageNotFound?.call(FlouterRouteInformation(uri.uri, null));
      if (page == null) {
        page = MaterialPage(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Text('Page not found'),
              ),
            ),
          ),
        );
      }
      _internalPages.add(page);
      _internalUris.add(uri);
    }
    notifyListeners();
    return SynchronousFuture(null);
  }

  /// get index of [uri] in the list of internalUris
  int _getlastIndexOfUri(Uri uri) => _internalUris
      .lastIndexWhere((flouterUri) => flouterUri.uri.path == uri.path);

  /// allow you one [Uri] and wait result
  Future<T?> pushUri<T extends Object?>(Uri uri) async {
    final flouterUri = FlouterUri<T>(uri);
    await _setNewRoutePath(flouterUri);
    return flouterUri.popped as Future<T?>;
  }

  /// allow you clear the list of [pages] and then push an [Uri]
  Future<T?> clearAndPushUri<T extends Object?>(Uri uri) async {
    _internalPages.clear();
    _internalUris.clear();
    return pushUri<T>(uri);
  }

  /// allow you to remove the last [Uri] and the corresponding [Page]
  Future<T?> popAndPushUri<T extends Object?>(Uri uri, [T? result]) {
    pop(result);
    return pushUri(uri);
  }

  /// Pop to a specific [Uri] and delete any page at the top and push [Uri]
  Future<T?> removeUtilUriAndPush<T extends Object?>(Uri popPath, Uri toPath) {
    final index = _getlastIndexOfUri(popPath);
    if (index == -1) return SynchronousFuture(null);
    _internalPages.removeRange(index + 1, _internalPages.length);
    _internalUris.removeRange(index + 1, _internalUris.length);
    return pushUri(toPath);
  }

  /// Pop to a specific [Uri] and delete any page at the top
  void removeUtilUri(Uri uri) {
    final index = _getlastIndexOfUri(uri);
    if (index == -1) return;

    _internalPages.removeRange(index + 1, _internalPages.length);
    _internalUris.removeRange(index + 1, _internalUris.length);
    notifyListeners();
  }

  /// allow you to remove a specific [Uri] and the corresponding [Page]
  void removeUri<T extends Object?>(Uri uri, [T? result]) {
    final index = _getlastIndexOfUri(uri);
    if (index == -1) return;

    _internalPages.removeAt(index);
    FlouterUri flouterUri = _internalUris.removeAt(index);
    notifyListeners();
    return flouterUri.complete(result);
  }

  /// allow you to remove the last [Uri] and the corresponding [Page]
  void pop<T extends Object?>([T? result]) {
    _internalPages.removeLast();
    FlouterUri flouterUri = _internalUris.removeLast();
    notifyListeners();
    return flouterUri.complete(result);
  }

  /// returns whether the pop request should be considered handled.
  Future<bool> maybePop<T extends Object?>([T? result]) {
    if (canPop()) {
      pop(result);
      return SynchronousFuture(true);
    }
    return SynchronousFuture(false);
  }

  /// Whether the navigator that most tightly encloses the given context can be
  /// popped.
  bool canPop() => _internalPages.length > 1;
}
