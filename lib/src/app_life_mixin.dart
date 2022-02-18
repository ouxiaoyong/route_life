import 'package:flutter/widgets.dart';

import 'app_live.dart';

mixin AppLifeMixin<T extends StatefulWidget> on State<T>{
  @override
  void dispose() {
    AppLive.instance.removeListener(onAppLifeChanged);
    super.dispose();
  }

  @override
  void initState() {
    AppLive.instance.addListener(onAppLifeChanged);
    super.initState();
  }

  void onAppLifeChanged(bool resume);
}