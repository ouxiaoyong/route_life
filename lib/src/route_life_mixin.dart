import 'package:flutter/widgets.dart';
import 'route_observer.dart';
import 'route_observer.dart' as route;

mixin RouteLifeMixin<T extends StatefulWidget> on State<T>{
  late RouteAwareImp _awareImp;
  RouteLifeObserver? _routeObserver;
  bool get isRouteShowing => route?.isCurrent?? _isRouteShowing;
  bool _isRouteShowing = false;
  ModalRoute? route;
  @override
  void initState() {
    _isRouteShowing = true;
    _awareImp = RouteAwareImp(onRoutePause,onRouteResume);
    Future.delayed(Duration.zero,_subscribe);
    super.initState();
  }

  void _subscribe(){
    _routeObserver = Navigator.of(context,rootNavigator: true).widget.observers.firstWhere((element) => element is RouteLifeObserver) as RouteLifeObserver;
    ModalRoute route = ModalRoute.of(context)!;
    this.route = route;
    _routeObserver?.subscribe(_awareImp, route);
  }

  void _unsubscribe(){
    _routeObserver?.unsubscribe(_awareImp);
  }

  @override
  void dispose() {
    _isRouteShowing = false;
    route = null;
    _unsubscribe();
    super.dispose();
  }

  void onRoutePause(Route<dynamic> nextRoute);

  void onRouteResume(Route<dynamic> nextRoute);
}

class RouteAwareImp extends route.RouteAware{
  final void Function(Route<dynamic> nextRoute) onRoutePause;
  final void Function(Route<dynamic> nextRoute) onRouteResume;
  RouteAwareImp(this.onRoutePause,this.onRouteResume);

  @override
  void didPopNext(Route<dynamic> nextRoute) {
    onRouteResume.call(nextRoute);
  }

  @override
  void didPushNext(Route<dynamic> nextRoute) {
    onRoutePause.call(nextRoute);
  }
}