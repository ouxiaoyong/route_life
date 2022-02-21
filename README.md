
if you wan to listen route lifecycle in widget, this is a way.

## Usage

1.set navigatorObservers

```dart
import 'package:route_life/route_life.dart';

RouteLifeObserver routeLifeObserver = RouteLifeObserver();

MaterialApp(
      navigatorObservers: [
        routeLifeObserver
      ],
    );
```
2. with RouteLifeMixin or AppLifeMixin

```dart
class _GamePageState extends State<GamePage> with RouteLifeMixin,AppLifeMixin{
  @override
  void initState() {
    super.initState();
    _playGamePageMusic();
  }

  @override
  void dispose() {
    _stopGamePageMusic();
    super.dispose();
  }

  @override
  void onRoutePause(Route nextRoute) {
    _pauseGamePageMusic();
  }

  @override
  void onRouteResume(Route nextRoute) {
    _resumeGamePageMusic();
  }

  @override
  void onAppLifeChanged(bool resume) {
    if(!isRouteShowing){
      return;
    }
    if(resume){
      _resumeGamePageMusic();
    }else{
      _pauseGamePageMusic();
    }
  }
}
```
