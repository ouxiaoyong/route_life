
import 'package:flutter/widgets.dart';
typedef OnAppLifecycleChanged = void Function(bool);

class AppLive with WidgetsBindingObserver{
  static final AppLive _instance = AppLive._();
  AppLive._(){
    _listen();
  }
  static AppLive get instance => _instance;
  bool _resumed = true;
  bool get resumed => _resumed;
  final List<OnAppLifecycleChanged> _onAppLifecycleChangedList = [];
  addListener(OnAppLifecycleChanged onAppLifecycleChanged){
    if(!_onAppLifecycleChangedList.contains(onAppLifecycleChanged)){
      _onAppLifecycleChangedList.add(onAppLifecycleChanged);
    }
  }

  _listen(){
    WidgetsBinding.instance!.removeObserver(this);
    WidgetsBinding.instance!.addObserver(this);
  }

  removeListener(OnAppLifecycleChanged onAppLifecycleChanged){
    if(_onAppLifecycleChangedList.contains(onAppLifecycleChanged)){
      _onAppLifecycleChangedList.remove(onAppLifecycleChanged);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      _setAppLifecycleState(true);
    }else{
      _setAppLifecycleState(false);
    }
  }

  _setAppLifecycleState(bool resumed){
    if(_resumed != resumed){
      _resumed = resumed;

      for (var e in List.from(_onAppLifecycleChangedList)) {
        e?.call(_resumed);
      }
    }
  }
}