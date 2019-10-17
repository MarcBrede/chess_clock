import 'package:flutter/material.dart';
import 'package:chess_clock/GlobalFiles/game.dart';

import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

//Screen for the actual game
class SecondScreen extends StatefulWidget {
  final Game game;
  final Map<String, Color> currentColor;
  final bool shouldVibrate;
  SecondScreen({this.game, this.currentColor, this.shouldVibrate});


  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
  bool isWhiteTurn;
  bool isFinished;
  bool isStarted;
  AnimationController controllerWhite;
  AnimationController controllerBlack;

  AnimationController currentController;
  AnimationController otherController;

  String getTimerString(controller) {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration getCurrentTime() {
    if (isWhiteTurn) {
      return widget.game.timeWhite;
    } else {
      return widget.game.timeBlack;
    }
  }

  Duration getCurrentIncrement() {
    if (isWhiteTurn) {
      return widget.game.incrementWhite;
    } else {
      return widget.game.incrementBlack;
    }
  }

  //This function is called on every Tap on the Screen
  void changeStatus() {
    if (!isStarted) return;
    if (!(controllerWhite.isAnimating || controllerBlack.isAnimating)) return;
    //Changes for the CurrentController
    double newControllerValue = currentController.value +
        getCurrentIncrement().inMilliseconds / getCurrentTime().inMilliseconds;
    //The new ControllerValue might be bigger then the Starttime
    if (newControllerValue > 1.0) {
      setState(() {
        currentController.duration = Duration(
            milliseconds:
                (newControllerValue * controllerWhite.duration.inMilliseconds)
                    .toInt());
        currentController.value = 1.0;
      });
    } else {
      setState(() {
        currentController.value = newControllerValue;
      });
    }
    setState(() {
      //Change the turns
      isWhiteTurn = !isWhiteTurn;
      //stop the current Controller
      currentController.stop(canceled: true);
      //start the other from the last value
      otherController.reverse(from: otherController.value);
      //Switch the global currentController
      AnimationController dummy = currentController;
      currentController = otherController;
      otherController = dummy;
    });
    if(widget.shouldVibrate){
      //if (Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 300);
    //}
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    //Initiate the state
    isWhiteTurn = true;
    isFinished = false;
    isStarted = false;
    controllerWhite = new AnimationController(
      vsync: this,
      duration: widget.game.timeWhite,
    );
    controllerWhite.value = 1.0;
    controllerWhite.addStatusListener((status) {
      setState(() {
        if (!controllerWhite.isAnimating && controllerWhite.value == 0.0) {
          isFinished = true;
        }
      });
    });
    controllerBlack = new AnimationController(
      vsync: this,
      duration: widget.game.timeBlack,
    );
    controllerBlack.value = 1.0;
    controllerBlack.addStatusListener((status) {
      setState(() {
        if (!controllerBlack.isAnimating && controllerBlack.value == 0.0) {
          isFinished = true;
        }
      });
    });
    //set the global currentController
    currentController = controllerWhite;
    otherController = controllerBlack;
  }

  //This function builds the clock
  AnimatedBuilder buildAnimatedClock() {
    //pick the right Color for the background
    Color backgroundClockColor;
    if (isWhiteTurn) {
      backgroundClockColor = widget.currentColor['black'];
    } else {
      backgroundClockColor = widget.currentColor['white'];
    }
    //rerturn the correct Clock
    return AnimatedBuilder(
      animation: currentController,
      builder: (BuildContext context, Widget child) {
        return CustomPaint(
            painter: TimerPainter(
          animation: currentController,
          backgroundColor: backgroundClockColor,
          color: widget.currentColor['accent'],
        ));
      },
    );
  }

  Widget buildUpperRow() {
    //whites Turn
    if (isWhiteTurn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          getAnimatedTime(
              50, otherController, widget.currentColor['black'], false)
        ],
      );
    }
    //blacks Turn
    else {
      //either two or three FloatingActionButton should be shown
      if (!currentController.isAnimating && isStarted || isFinished) {
        return getTwoOrThreeFloatingActionButtonRow();
      }
      //just one floatingActionButton
      else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: widget.currentColor['accent'],
              child: buildPlayStopButton(),
              onPressed: managePlayStopButton,
            )
          ],
        );
      }
    }
  }

  Widget buildLowerRow() {
    //blacks Turn
    if (!isWhiteTurn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          getAnimatedTime(
              50, otherController, widget.currentColor['white'], true)
        ],
      );
    }
    //whites Turn
    else {
      //either two or three FloatingActionButton should be shown
      if (!currentController.isAnimating && isStarted || isFinished) {
        return getTwoOrThreeFloatingActionButtonRow();
      }
      //just one floatingActionButton
      else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: widget.currentColor['accent'],
              child: buildPlayStopButton(),
              onPressed: managePlayStopButton,
            )
          ],
        );
      }
    }
  }

  //This function gets called when the Stop or the Play button ist pressed
  void managePlayStopButton() {
    isStarted = true;
    if (currentController.isAnimating) {
      setState(() {
        currentController.stop(canceled: true);
      });
    } else {
      setState(() {
        currentController.reverse(from: currentController.value);
      });
    }
  }

  Widget getTwoOrThreeFloatingActionButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RotatedBox(
            quarterTurns: 2,
            child: FloatingActionButton(
              backgroundColor: widget.currentColor['accent'],
              heroTag: 'btn1',
              child: Icon(Icons.sync),
              onPressed: restartTheGame,
            ),
          ),
        ),
        //if the game is finished dont show the play button
        if (!isFinished)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RotatedBox(
              quarterTurns: isWhiteTurn ? 0 : 2,
              child: FloatingActionButton(
                backgroundColor: widget.currentColor['accent'],
                heroTag: 'btn2',
                child: buildPlayStopButton(),
                onPressed: managePlayStopButton,
              ),
            ),
          ),
        RotatedBox(
          quarterTurns: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: widget.currentColor['accent'],
              heroTag: 'btn3',
              child: Icon(Icons.cancel),
              onPressed: exit,
            ),
          ),
        ),
      ],
    );
  }

  void exit() {
    controllerWhite.dispose();
    controllerBlack.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Navigator.pop(context);
  }

  Future<bool> backButton() {
    controllerWhite.dispose();
    controllerBlack.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Future.value(true);
  }

  //builds the right floatingButton
  AnimatedBuilder buildPlayStopButton() {
    return AnimatedBuilder(
      animation: currentController,
      builder: (BuildContext context, Widget child) {
        return Icon(controllerWhite.isAnimating || controllerBlack.isAnimating
            ? Icons.pause
            : Icons.play_arrow);
      },
    );
  }

  //This function build the animated Time
  AnimatedBuilder getAnimatedTime(
      double size, AnimationController controller, Color color, bool rotate) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          if (!rotate) {
            return Text(
              getTimerString(controller),
              style: TextStyle(
                fontSize: size,
                color: color,
              ),
            );
          } else {
            return RotatedBox(
              quarterTurns: 2,
              child: Text(
                getTimerString(controller),
                style: TextStyle(
                  fontSize: size,
                  color: color,
                ),
              ),
            );
          }
        });
  }

  void restartTheGame() {
    setState(() {
      isWhiteTurn = true;
      isFinished = false;
      isStarted = false;
    });
    controllerWhite.dispose();
    controllerWhite = new AnimationController(
      vsync: this,
      duration: widget.game.timeWhite,
    );
    setState(() {
      controllerWhite.value = 1.0;
    });
    controllerWhite.addStatusListener((status) {
      setState(() {
        if (!controllerWhite.isAnimating && controllerWhite.value == 0.0) {
          isFinished = true;
        }
      });
    });
    controllerBlack.dispose();
    controllerBlack = new AnimationController(
      vsync: this,
      duration: widget.game.timeBlack,
    );
    setState(() {
      controllerBlack.value = 1.0;
    });
    controllerBlack.addStatusListener((status) {
      setState(() {
        if (!controllerBlack.isAnimating && controllerBlack.value == 0.0) {
          isFinished = true;
        }
      });
    });
    //set the global currentController
    setState(() {
      currentController = controllerWhite;
      otherController = controllerBlack;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backButton,
      child: Scaffold(
        backgroundColor: isWhiteTurn
            ? widget.currentColor['white']
            : widget.currentColor['black'],
        body: InkWell(
          onTap: changeStatus,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  margin: EdgeInsets.all(8.0),
                  child: buildUpperRow(),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.center,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(child: buildAnimatedClock()),
                          Align(
                            alignment: FractionalOffset.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                isWhiteTurn
                                    ? getAnimatedTime(100.0, controllerWhite,
                                        widget.currentColor['black'], false)
                                    : getAnimatedTime(100.0, controllerBlack,
                                        widget.currentColor['white'], true)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  margin: EdgeInsets.all(8.0),
                  child: buildLowerRow(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
