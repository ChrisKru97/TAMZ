import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

Image grass = Image.asset('assets/game/terrain/grass.png');
Image north = Image.asset('assets/game/terrain/north.png');
Image east = Image.asset('assets/game/terrain/east.png');
Image south = Image.asset('assets/game/terrain/south.png');
Image west = Image.asset('assets/game/terrain/west.png');
Image ne = Image.asset('assets/game/terrain/ne.png');
Image nw = Image.asset('assets/game/terrain/nw.png');
Image se = Image.asset('assets/game/terrain/se.png');
Image sw = Image.asset('assets/game/terrain/sw.png');
List<Image> items = <Image>[
  Image.asset('assets/game/item/item_0.png'),
  Image.asset('assets/game/item/item_1.png'),
  Image.asset('assets/game/item/item_2.png'),
  Image.asset('assets/game/item/item_3.png')
];
List<Image> robot = <Image>[
  Image.asset('assets/game/robot/robot_0.png'),
  Image.asset('assets/game/robot/robot_1.png'),
  Image.asset('assets/game/robot/robot_2.png'),
  Image.asset('assets/game/robot/robot_3.png'),
  Image.asset('assets/game/robot/robot_4.png'),
  Image.asset('assets/game/robot/robot_5.png'),
  Image.asset('assets/game/robot/robot_6.png'),
  Image.asset('assets/game/robot/robot_7.png'),
  Image.asset('assets/game/robot/robot_8.png'),
  Image.asset('assets/game/robot/robot_9.png'),
  Image.asset('assets/game/robot/robot_10.png'),
  Image.asset('assets/game/robot/robot_11.png'),
  Image.asset('assets/game/robot/robot_12.png'),
  Image.asset('assets/game/robot/robot_13.png'),
  Image.asset('assets/game/robot/robot_14.png'),
  Image.asset('assets/game/robot/robot_15.png')
];

enum Direction { north, east, south, west }

class GameState {
  GameState({this.x = 0.5, this.y = 0.5, this.direction = Direction.south});

  double x;
  double y;
  Direction direction;
}

class Position {
  Position({this.x, this.y, this.which});

  double x;
  double y;
  int which;
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static final rand = Random(DateTime.now().millisecondsSinceEpoch);
  final StreamController<GameState> _streamController =
      StreamController<GameState>();
  static final StreamController<Position> _positionStreamController =
      StreamController<Position>.broadcast();
  final StreamController<int> _scoreStreamController = StreamController<int>();
  final StreamController<int> _tickerStreamController =
      StreamController<int>.broadcast()
        ..addStream(Stream.periodic(Duration(seconds: 1), (i) {
          if (i % 5 == 0) {
            _positionStreamController.add(Position(
                x: rand.nextDouble(),
                y: rand.nextDouble(),
                which: rand.nextInt(4)));
          }
          return i % 5;
        }));
  final StreamController<double> _animationStreamController =
      StreamController<double>();
  GameState actual = GameState();
  int score = 0;
  double animationState = 0;

  @override
  Widget build(BuildContext context) {
    final max = (MediaQuery.of(context).size.width * 0.8 / 32).floor() - 1;
    final side = (max - 2) * 32;
    final fontSize = MediaQuery.of(context).size.width * 0.06;
    return GestureDetector(
      onVerticalDragUpdate: (ban) {
        animationState = (animationState + 0.2) % 16;
        _animationStreamController.add(animationState);
        actual.y += ban.primaryDelta * 0.003;
        if (actual.y > 1) {
          actual.y = 1;
        } else if (actual.y < 0) {
          actual.y = 0;
        }
        actual.direction =
            ban.primaryDelta < 0 ? Direction.north : Direction.south;
        _streamController.sink.add(actual);
      },
      onHorizontalDragUpdate: (ban) {
        animationState = (animationState + 0.2) % 16;
        _animationStreamController.add(animationState);
        actual.x += ban.primaryDelta * 0.003;
        if (actual.x > 1) {
          actual.x = 1;
        } else if (actual.x < 0) {
          actual.x = 0;
        }
        actual.direction =
            ban.primaryDelta < 0 ? Direction.west : Direction.east;
        _streamController.sink.add(actual);
      },
      child: Scaffold(
          appBar: AppBar(title: Text('Game')),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    StreamBuilder<int>(
                        stream: _scoreStreamController.stream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          return Text('Score: ${snapshot.data}',
                              style: TextStyle(fontSize: fontSize));
                        }),
                    StreamBuilder<int>(
                        stream: _tickerStreamController.stream,
                        initialData: 0,
                        builder: (context, snapshot) => Text(
                              'Next: ${5 - snapshot.data}',
                              style: TextStyle(fontSize: fontSize),
                            ))
                  ],
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      maxHeight: MediaQuery.of(context).size.width * 0.8),
                  child: Stack(
                    children: <Widget>[
                      Column(
                          children: List.generate(max + 1, (i) => i).map((y) {
                        return Row(
                            children: List.generate(max + 1, (i) => i).map((x) {
                          if (x == 0) {
                            if (y == 0) {
                              return nw;
                            } else if (y == max) {
                              return sw;
                            } else {
                              return west;
                            }
                          } else if (x == max) {
                            if (y == 0) {
                              return ne;
                            } else if (y == max) {
                              return se;
                            } else {
                              return east;
                            }
                          } else if (y == 0) {
                            return north;
                          } else if (y == max) {
                            return south;
                          }
                          {
                            return grass;
                          }
                        }).toList());
                      }).toList()),
                      StreamBuilder<Position>(
                        stream: _positionStreamController.stream,
                        builder: (context, itemSnapshot) =>
                            StreamBuilder<GameState>(
                                stream: _streamController.stream,
                                initialData: actual,
                                builder: (context, snapshot) {
                                  final x = side * snapshot.data.x + 24;
                                  final y = side * snapshot.data.y + 24;
                                  if (itemSnapshot.hasData &&
                                      ((max - 2) * itemSnapshot.data.x)
                                                      .roundToDouble() *
                                                  32 +
                                              11 <
                                          x &&
                                      (((max - 2) * itemSnapshot.data.x)
                                                      .roundToDouble() *
                                                  32 +
                                              48) >
                                          x &&
                                      ((max - 2) * itemSnapshot.data.y)
                                                      .roundToDouble() *
                                                  32 +
                                              11 <
                                          y &&
                                      (((max - 2) * itemSnapshot.data.y)
                                                      .roundToDouble() *
                                                  32 +
                                              48) >
                                          y) {
                                    score += 1;
                                    _scoreStreamController.sink.add(score);
                                    _positionStreamController.sink.add(Position(
                                        x: rand.nextDouble(),
                                        y: rand.nextDouble(),
                                        which: rand.nextInt(4)));
                                  }
                                  return Positioned(
                                      top: y,
                                      left: x,
                                      child: Transform.rotate(
                                          angle: snapshot.data.direction ==
                                                  Direction.east
                                              ? pi * 3 / 2
                                              : snapshot.data.direction ==
                                                      Direction.north
                                                  ? pi
                                                  : snapshot.data.direction ==
                                                          Direction.west
                                                      ? pi / 2
                                                      : 0,
                                          child: StreamBuilder<double>(
                                              stream: _animationStreamController
                                                  .stream,
                                              initialData: 0,
                                              builder: (context, snapshot) {
                                                print(snapshot.data.floor().toString());
                                                return robot[
                                                    snapshot.data.floor()];
                                              })));
                                }),
                      ),
                      StreamBuilder<Position>(
                        stream: _positionStreamController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center();
                          }
                          final x =
                              ((max - 2) * snapshot.data.x).roundToDouble() *
                                      32 +
                                  32;
                          final y =
                              ((max - 2) * snapshot.data.y).roundToDouble() *
                                      32 +
                                  32;
                          return Positioned(
                              top: y,
                              left: x,
                              child: items[snapshot.data.which]);
                        },
                      )
                    ],
                  ),
                )
              ])),
    );
  }

  @override
  void dispose() {
    _animationStreamController.close();
    _tickerStreamController.close();
    _streamController.close();
    _positionStreamController.close();
    _scoreStreamController.close();
    super.dispose();
  }
}
