import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StopWatchPage(),
    );
  }
}

enum WatchState { PAUSED, PLAYING }

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  var _watchState = WatchState.PAUSED;
  late Timer _timer;

  var _time = 0;

  List<String> _lapTimes = [];


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StopWatch'),
      ),
      body: buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: buildPlayButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildBody() {
    var sec = _time ~/ 100;
    var hundredth = '${_time % 100}'.padLeft(2, '0');

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Stack(
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text( // 초
                    '$sec',
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Text('$hundredth'), // 1/100초
                ],
              ),
              Container(
                width: 100,
                height: 200,
                child: ListView(
                  children: _lapTimes.map((time) => Text(time)).toList(),
                ),
              )
            ]),
            Positioned(
              left: 10,
              bottom: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: _reset,
                child: Icon(Icons.rotate_left),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: Text('랩타임'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildPlayButton() {
    return FloatingActionButton(
      child: _getPlayIcon(),
      onPressed: () => setState(() {
        _togglePlayButton();
      }),
    );
  }

  Widget _getPlayIcon() {
    switch (_watchState) {
      case WatchState.PAUSED:
        return Icon(Icons.pause);
      case WatchState.PLAYING:
        return Icon(Icons.play_arrow);
    }
  }

  void _togglePlayButton() {
    if (_watchState == WatchState.PAUSED) {
      _watchState = WatchState.PLAYING;
      _start();
    } else {
      _watchState = WatchState.PAUSED;
      _pause();
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer.cancel();
  }

  void _reset() {
    setState(() {
      _timer.cancel();
      _lapTimes.clear();
      _watchState = WatchState.PAUSED;
      _time = 0;
    });
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1}등 $time');
  }
}
