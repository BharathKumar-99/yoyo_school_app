// lib/services/route_tracker.dart
import 'package:flutter/material.dart';

class RouteTracker extends NavigatorObserver {
  final List<String> _routeHistory = [];

  List<String> get history => List.unmodifiable(_routeHistory);

  void clearHistory() => _routeHistory.clear();

  String get currentRouteStack {
    return _routeHistory.isEmpty
        ? 'No Route History'
        : _routeHistory.reversed.join(' -> ');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? route.runtimeType.toString();
    _routeHistory.add(routeName);
    print('Route PUSHED: $routeName');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_routeHistory.isNotEmpty) {
      _routeHistory.removeLast();
    }
    print('Route POPPED: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (_routeHistory.isNotEmpty) {
      _routeHistory.removeLast();
    }
    final newRouteName =
        newRoute?.settings.name ?? newRoute.runtimeType.toString();
    _routeHistory.add(newRouteName);
    print('Route REPLACED with: $newRouteName');
  }
}

final routeTracker = RouteTracker();
