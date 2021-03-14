import 'package:flutter/material.dart';
import 'dart:async';

class ElapsedTime {
  final int milliSeconds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.milliSeconds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
      const TextStyle(fontSize: 20.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class Timers extends StatefulWidget {
  Timers({this.dependencies});
  final Dependencies dependencies;

  TimerState createState() => new TimerState(dependencies: dependencies);
}

class TimerState extends State<Timers> {
  TimerState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int milliSeconds = (milliseconds / 10).truncate();
      final int seconds = (milliSeconds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        milliSeconds: milliSeconds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 40.0,
            // width: 50.0,
            child: new MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            height: 40.0,
            // width: 50.0,
            child: new MilliSeconds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class MilliSeconds extends StatefulWidget {
  MilliSeconds({this.dependencies});
  final Dependencies dependencies;

  MilliSecondsState createState() =>
      new MilliSecondsState(dependencies: dependencies);
}

class MilliSecondsState extends State<MilliSeconds> {
  MilliSecondsState({this.dependencies});
  final Dependencies dependencies;

  int milliSeconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.milliSeconds != milliSeconds) {
      setState(() {
        milliSeconds = elapsed.milliSeconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String milliSecondsStr = (milliSeconds % 100).toString().padLeft(2, '0');
    return new Text(milliSecondsStr, style: dependencies.textStyle);
  }
}
