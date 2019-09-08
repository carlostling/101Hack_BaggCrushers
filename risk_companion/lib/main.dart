import 'package:flutter/material.dart';
import 'package:risk_companion/ResultPage.dart';
import 'package:risk_companion/SignUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RiskPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Quicksand'),
      
      home: FutureBuilder(
        future: hasSignedUp(),
        builder: (context,snapshot){
          if(snapshot != null && snapshot.hasData){
            return snapshot.data ? RiskPage() : SignUpPage();
          }else{
            return Container(child: Center(child: CircularProgressIndicator(),),);
          }
        },
      ),
    );
  }

  Future<bool> hasSignedUp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getBool("initial") != null){
        return true;
    }else{
      return false;
    }
  }
}

