import 'package:flutter/material.dart';
import 'package:route_life/route_life.dart';

RouteLifeObserver routeLifeObserver = RouteLifeObserver();
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (context) => const HomePage(),
        "/game": (context) => const GamePage(),
        "/page1": (context) => const Page1(),
      },
      initialRoute: "/home",
      navigatorObservers: [
        routeLifeObserver
      ],
    );
  }

}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteLifeMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Home Page"),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/game');
          }, child: Text("Go Game Page")),
        ],
      ),),
    );
  }

  @override
  void initState() {
    super.initState();
    _playHomeMusic();
  }

  @override
  void dispose() {
    _stopHomeMusic();
    super.dispose();
  }

  @override
  void onRoutePause(Route nextRoute) {
    _pauseHomeMusic();
  }

  @override
  void onRouteResume(Route nextRoute) {
    _resumeHomeMusic();
  }


  void _playHomeMusic(){
    print("play home music");
  }

  void _pauseHomeMusic(){
    print("pause home music");
  }

  void _resumeHomeMusic(){
    print("resume home music");
  }

  void _stopHomeMusic(){
    print("stop home music");
  }
}


class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with RouteLifeMixin,AppLifeMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Game Page"),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/page1');
          }, child: Text("next page")),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("close page"))
        ],
      ),),
    );
  }

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

  void _playGamePageMusic(){
    print("play GamePage music");
  }

  void _pauseGamePageMusic(){
    print("pause GamePage music");
  }

  void _resumeGamePageMusic(){
    print("resume GamePage music");
  }

  void _stopGamePageMusic(){
    print("stop GamePage music");
  }

}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Page1"),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("close page"))
        ],
      ),),
    );
  }
}

