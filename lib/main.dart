import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'linear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Progress Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _progressValue = 0.0;
  bool _animationInProgress = false;
  Timer? _timer;

  final random = Random();

  Timer _startTimer(
      {int? pauseDuration,
      double? pausePosition,
      bool? start,
      bool? last,
      bool? second}) {
    setState(() {
      _animationInProgress = true;
    });
    if (_timer != null) {
      _timer!.cancel();
    }
    if (start == true) {
      pausePosition = random.nextInt(100) / 100;

      pauseDuration = random.nextInt(3);

      while (pauseDuration! < 0) {
        pauseDuration = random.nextInt(2);
      }
      setState(() {
        _progressValue = 0.0;
      }); 
    }
    

    return Timer(Duration(seconds: pauseDuration ?? 0), () {
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (double.parse((_progressValue).toStringAsFixed(2)) ==
                pausePosition &&
            last == null) {
          double pauseSecondPosition = 0.0;
          int pauseSecondDuration = random.nextInt(2);
          while (pauseSecondPosition < pausePosition!) {
            pauseSecondPosition = random.nextInt(100) / 100;
          }
          _startTimer(
            last: second == true ? true : null,
            second: second == null ? true : null,
            pauseDuration: pauseSecondDuration,
            pausePosition: pauseSecondPosition,
          );

          setState(() {
            _animationInProgress = false;
          });

          timer.cancel();
        } else {
          if (_progressValue >= 1) {
            setState(() {
              _progressValue = 0.0;
              _animationInProgress = false;
            });

            timer.cancel();
          } else {
            setState(() {
              _progressValue += 0.01;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Progress Bar Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () => _startTimer(start: true),
              child: Text('Start'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
            SizedBox(height: 20.0),
            ClipRect(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 22,
                child: CustomPaint(
                  foregroundPainter: StripedProgressPainter(
                    stripeColor: Colors.blue.shade300.withOpacity(0.5),
                    stripeWidth: 12,
                    progress: _progressValue,
                  ),
                  child: Transform.translate(
                    offset: Offset(0, 0.35),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: Colors.grey,
                      minHeight: 30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
