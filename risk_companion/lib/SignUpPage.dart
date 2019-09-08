import 'package:flutter/material.dart';
import 'package:risk_companion/RiskPage.dart';
import 'ScreenUtils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  String age;

  String carLicense;

  String kmPerYear;
  SignUpPage({this.age,this.carLicense,this.kmPerYear});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String age;

  String carLicense;

  String kmPerYear;

  @override
  void initState() {
    age = widget.age;
    carLicense = widget.carLicense;
    kmPerYear = widget.kmPerYear;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    ScreenUtils.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 90, 160, 1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: ScreenUtils.getHeight(20),
            width: 0,
          ),
          Center(
              child: Text(
            "Enter details",
            style: TextStyle(
              fontSize: ScreenUtils.getFontSize(40),
              color: Color.fromRGBO(0, 90, 160, 1),
            ),
            textAlign: TextAlign.center,
          )),
          SizedBox(
            height: 15,
            width: 0,
          ),
          InputFieldWidget(
            title: "Age",
            callback: changeAge,
            isNumber: true,
            initialValue: widget.age,
          ),
          SizedBox(
            height: 10,
            width: 0,
          ),
          InputFieldWidget(
            title: "License Plate",
            callback: changeCarLicense,
            isNumber: false,
            initialValue: widget.carLicense,
          ),
          SizedBox(
            height: 10,
            width: 0,
          ),
          InputFieldWidget(
            title: "Km per year",
            callback: changeKmPerYear,
            isNumber: true,
            initialValue: widget.kmPerYear,
          ),
          SizedBox(
            height: 10,
            width: 0,
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: true,
              ),
              Text(
                "Save my data for next calculation",
                style: TextStyle(fontWeight: FontWeight.w400),
              )
            ],
          ),
          RaisedButton(
            onPressed: () => _submit(context),
            color: Color.fromRGBO(227, 6, 19, 0.8),
            shape: StadiumBorder(),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Next",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtils.getFontSize(20)),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtils.getHeight(20),
          ),
        ],
      ),
    );
  }

  void changeAge(String newValue) {
    setState(() {
       age = newValue;
    });
   
  }

  void changeCarLicense(String newValue) {
    setState(() {
      carLicense = newValue;
    });
    
  }

  void changeKmPerYear(String newValue) {
    setState(() {
      kmPerYear = newValue;
    });
    
  }

  void _submit(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("age", age);
    sharedPreferences.setString("carLicense", carLicense);
    sharedPreferences.setString("kmPerYear", kmPerYear);
    sharedPreferences.setBool("initial", true);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RiskPage()));
  }
}

class InputFieldWidget extends StatelessWidget {
  final String title;
  final String initialValue;
  final bool isNumber;
  Function callback;


  InputFieldWidget({@required this.title, this.initialValue, this.callback, this.isNumber});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getWidth(15)),
      child: TextFormField(
        initialValue: initialValue,
        decoration: new InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          labelText: title,
          
          fillColor: Colors.grey,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: new BorderSide(),
          ),
        ),
        onChanged: (string) {
          callback(string);
        },
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: new TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
