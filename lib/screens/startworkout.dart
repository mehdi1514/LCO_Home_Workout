import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:me/screens/home.dart';
import 'package:me/workoutdata.dart';

class WorkoutPage extends StatelessWidget {
  final List<int> indices;
  final int sets;
  WorkoutPage(this.indices, this.sets);

  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: Colors.purple),),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: TextStyle(color: Colors.purple),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("All your progress will be lost"),
      content: Text("Are you sure you want to go back?"),
      actions: [
        yesButton,
        cancelButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(indices);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: indices.length == 0
              ? Icon(Icons.home)
              : Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            if (indices.length == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false);
            } else {
              showAlertDialog(context);
            }
          },
        ),
        title: Text(
          indices.length == 0 ? "" : "Let's Go!",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: indices.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, bottom: 32.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Card(
                        elevation: 10.0,
                        child: Image.asset(
                          'images/bravo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "You completed all workouts.",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    workouts[indices[0]]['name'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image.asset(workouts[indices[0]]['imageUrl'])),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  WorkoutTimer(indices, sets),
                ],
              ),
            ),
    );
  }
}

class WorkoutTimer extends StatefulWidget {
  final List<int> indices;
  int sets;
  WorkoutTimer(this.indices, this.sets);
  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  int time1 = 4;
  int time2, bTime, wTime; // wTime = total workout time , bTime = total break time
  int interval; // duration of each set of one exercise
  String rest = '';
  int _sets;
  final assetsAudioPlayer = AssetsAudioPlayer();
  Timer timer1, timer2;
  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer1() {
    timer1 = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time1 != 0) {
        setState(() {
          time1 -= 1;
        });
      } else {
        timer.cancel();
        startTimer2();
      }
    });
  }

  void startTimer2() {
    Random random = new Random();
    int audioIndex = random.nextInt(3);
    assetsAudioPlayer.open(
        Audio("audio/${audioIndex + 1}.mp3")
    );
    setState(() {
      time2 -= 1;
    });
    timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time2 != 0 && time2 > 0) {
        if(assetsAudioPlayer.isPlaying.value == true)
          wTime -= 1;
        else
          bTime -= 1;

        if (bTime % 10 == 0 && assetsAudioPlayer.isPlaying.value == false){ //10 - 40
          assetsAudioPlayer.play();
          setState(() {
            rest = '';
          });
        }

        else if (wTime % 10 == 0 && assetsAudioPlayer.isPlaying.value == true) { // 10 - interval
          assetsAudioPlayer.pause();
          setState(() {
            rest = ' | break';
            widget.sets -= 1;
          });
        }

        setState(() {
          time2 -= 1;
        });
      } else {
        assetsAudioPlayer.stop();
        timer.cancel();
        widget.indices.removeAt(0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WorkoutPage(widget.indices, _sets)));
      }
    });
  }

  @override
  void initState() {
    _sets = widget.sets;
    bTime = 40 * widget.sets;
    wTime = workouts[widget.indices[0]]['duration'] * widget.sets;
    time2 = (workouts[widget.indices[0]]['duration'] + 40) * widget.sets;
    interval = (workouts[widget.indices[0]]['duration']);
    startTimer1();
    super.initState();
  }

  @override
  void dispose() {
    timer1.cancel();
    timer2.cancel();
    assetsAudioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Card(
          shape: StadiumBorder(),
          color: Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
                Text(
                  time1 != 0
                      ? "Starting in $time1 s"
                      : "  ${_printDuration(Duration(seconds: time2))} $rest",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.02),
                ),
              ],
            ),
          ),
        ),
        Text(
          "${widget.sets.toString()} set(s) left",
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
        )
      ],
    );
  }
}
