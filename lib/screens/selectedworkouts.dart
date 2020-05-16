import 'dart:math';

import 'package:flutter/material.dart';
import 'package:me/screens/startworkout.dart';
import 'package:me/workoutdata.dart';

class SelectedWorkouts extends StatelessWidget {
  final int sets;
  final List<int> randomIndeces;
  SelectedWorkouts(this.randomIndeces, this.sets);

  List<int> generateIndices() {
    Random random = Random();
    List<int> randomIndeces = [];
    while(randomIndeces.length != 5){
      int element = random.nextInt(workouts.length);
      if(!randomIndeces.contains(element)){
        randomIndeces.add(element);
      }
    }
    return randomIndeces;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget getWorkout(BuildContext context, int index) {
    int workoutDuration = (workouts[index]['duration'] * sets) + (40 * sets);
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              workouts[index]['imageUrl'],
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Text(
                    workouts[index]['name'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Text(
                    _printDuration(Duration(seconds: workoutDuration)),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Text(
                    "$sets sets",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Selected Workouts",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.purple,
            child: IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => SelectedWorkouts(generateIndices() ,sets))),
            ),
          ),
          SizedBox(width: 10.0,),
        ],
      ),
      floatingActionButton: RaisedButton(
        child: Text(
          "Start",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.purple,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => WorkoutPage(randomIndeces, sets))),
        shape: StadiumBorder(),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              getWorkout(context, randomIndeces[0]),
              SizedBox(
                height: 10.0,
              ),
              getWorkout(context, randomIndeces[1]),
              SizedBox(
                height: 10.0,
              ),
              getWorkout(context, randomIndeces[2]),
              SizedBox(
                height: 10.0,
              ),
              getWorkout(context, randomIndeces[3]),
              SizedBox(
                height: 10.0,
              ),
              getWorkout(context, randomIndeces[4]),
              SizedBox(
                height: 70.0,
              ),
            ],
          )),
    );
  }
}
