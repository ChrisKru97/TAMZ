import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tamz/binary/binary.dart';
import 'package:tamz/converter/converter.dart';
import 'package:tamz/custom_button.dart';
import 'package:tamz/http/http_testing.dart';
import 'package:tamz/todo/todo_list.dart';
import 'bmi/bmi.dart';
import 'game/game.dart';
import 'zodiac/zodiac.dart';

class Route {
  Route({this.path, this.title, this.child});

  String path;
  String title;
  Widget child;
}

Soundpool pool = Soundpool(streamType: StreamType.notification);

var routeList = <Route>[
  Route(path: '/zodiac', title: 'Zodiac', child: Zodiac()),
  Route(path: '/bmi', title: 'BMI', child: Bmi()),
  Route(path: '/todo', title: 'Todo list', child: TodoList()),
  Route(path: '/http', title: 'HTTP testing', child: HttpTesting()),
  Route(path: '/converter', title: 'Currency converter', child: Converter()),
  Route(path: '/binary', title: 'Binary clock', child: Binary(pool)),
  Route(path: '/game', title: 'Game', child: Game()),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<void> loadAssets(Soundpool pool) async {
    await pool.load(await rootBundle.load('assets/audio/tick.m4a'));
    await pool.load(await rootBundle.load('assets/audio/tock.m4a'));
    await pool.load(await rootBundle.load('assets/audio/minute.mp3'));
    await pool.load(await rootBundle.load('assets/audio/cuckoo.mp3'));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
      future: loadAssets(pool),
      builder: (context, snapshot) => MaterialApp(
            title: 'TAMZ',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => Home(),
            }..addAll(Map.fromIterable(routeList,
                key: (v) => v.path, value: (v) => (_) => v.child)),
          ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('TAMZ - Krutsche'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: routeList
              .map((Route route) => CustomButton(
                    text: route.title,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(route.path),
                  ))
              .toList(),
        ),
      ));
}
