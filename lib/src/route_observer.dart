import 'package:flutter/widgets.dart';

class RouteLifeObserver<R extends Route<dynamic>> extends NavigatorObserver {
  final Map<R, Set<RouteAware>> _listeners = <R, Set<RouteAware>>{};

  /// Subscribe [routeAware] to be informed about changes to [route].
  ///
  /// Going forward, [routeAware] will be informed about qualifying changes
  /// to [route], e.g. when [route] is covered by another route or when [route]
  /// is popped off the [Navigator] stack.
  void subscribe(RouteAware routeAware, R route) {
    final Set<RouteAware> subscribers = _listeners.putIfAbsent(route, () => <RouteAware>{});
    if (subscribers.add(routeAware)) {
      routeAware.didPush();
    }
  }

  /// Unsubscribe [routeAware].
  ///
  /// [routeAware] is no longer informed about changes to its route. If the given argument was
  /// subscribed to multiple types, this will unregister it (once) from each type.
  void unsubscribe(RouteAware routeAware) {
    final List<R> routes = _listeners.keys.toList();
    for (final R route in routes) {
      final Set<RouteAware>? subscribers = _listeners[route];
      if (subscribers != null) {
        subscribers.remove(routeAware);
        if (subscribers.isEmpty) {
          _listeners.remove(route);
        }
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is R && previousRoute is R) {
      final List<RouteAware>? previousSubscribers = _listeners[previousRoute]?.toList();

      if (previousSubscribers != null) {
        for (final RouteAware routeAware in previousSubscribers) {
          routeAware.didPopNext(route);
        }
      }

      final List<RouteAware>? subscribers = _listeners[route]?.toList();

      if (subscribers != null) {
        for (final RouteAware routeAware in subscribers) {
          routeAware.didPop();
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is R && previousRoute is R) {
      final Set<RouteAware>? previousSubscribers = _listeners[previousRoute];

      if (previousSubscribers != null) {
        for (final RouteAware routeAware in previousSubscribers) {
          routeAware.didPushNext(route);
        }
      }
    }
  }
}

/// An interface for objects that are aware of their current [Route].
///
/// This is used with [RouteObserver] to make a widget aware of changes to the
/// [Navigator]'s session history.
abstract class RouteAware {
  /// Called when the top route has been popped off, and the current route
  /// shows up.
  void didPopNext(Route<dynamic> nextRoute) { }

  /// Called when the current route has been pushed.
  void didPush() { }

  /// Called when the current route has been popped off.
  void didPop() { }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  void didPushNext(Route<dynamic> nextRoute) { }
}