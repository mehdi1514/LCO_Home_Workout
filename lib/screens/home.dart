import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:me/screens/selectedworkouts.dart';
import 'dart:math';
import '../workoutdata.dart';

class Home extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final setsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 30.0),
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('images/logo2.png'),
                    Text("Enter the number of sets"),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: setsController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the number of sets';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "eg: 3",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.38,
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Random Mode",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        color: Colors.purple,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Random random = Random();
                            List<int> randomIndeces = [];
                            while(randomIndeces.length != 5){
                              int element = random.nextInt(workouts.length);
                              if(!randomIndeces.contains(element)){
                                randomIndeces.add(element);
                              }
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectedWorkouts(randomIndeces,
                                        int.parse(setsController.text))));
                          }
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.38,
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Day Mode",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        color: Colors.purple,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Random random = Random();
                            List<int> randomIndeces = [];
                            while(randomIndeces.length != 5){
                              int element = random.nextInt(workouts.length);
                              if(!randomIndeces.contains(element)){
                                randomIndeces.add(element);
                              }
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectedWorkouts(randomIndeces,
                                        int.parse(setsController.text))));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
