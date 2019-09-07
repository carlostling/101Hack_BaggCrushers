import 'package:flutter/material.dart';
import 'package:risk_companion/ResultPage.dart';
import 'package:risk_companion/models/Profile.dart';
import 'ScreenUtils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';

class SignUpPage extends StatelessWidget {
  String _age;
  String _focus;
  String _carLicense;
  String _kmPerYear;
  String _destination;

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
            "BERÄKNA RISK",
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
            title: "Ålder",
            callback: changeAge,
          ),
          SizedBox(
            height: 10,
            width: 0,
          ),
          InputFieldWidget(
            title: "Nummerplåt",
            callback: changeCarLicense,
          ),
          SizedBox(
            height: 10,
            width: 0,
          ),
          InputFieldWidget(
            title: "Km per år",
            callback: changeKmPerYear,
          ),
          SizedBox(
            height: 10,
            width: 0,
          ),
          Text(
            "Nuvarande fokus:",
            style: TextStyle(
                fontSize: ScreenUtils.getFontSize(20),
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getWidth(50)),
            child: FocusSliderWidget(),
          ),
          InputFieldWidget(
            title: "Slutdestination",
            callback: changeDestination,
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
                "Spara min data till nästa riskanalys",
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
                "Gå vidare",
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
    _age = newValue;
  }

  void changeFocus(String newValue) {
    _focus = newValue;
  }

  void changeCarLicense(String newValue) {
    _carLicense = newValue;
  }

  void changeKmPerYear(String newValue) {
    _kmPerYear = newValue;
  }

  void changeDestination(String newValue) {
    _destination = newValue;
  }

  void _submit(BuildContext context) async {
    LocationData currentLocation;
    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      currentLocation = null;
      return;
    }
    
    Profile profile = new Profile(
        _age, _carLicense, _destination, _focus, _kmPerYear, currentLocation);
    
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
  }
}

class InputFieldWidget extends StatelessWidget {
  final String title;
  final String initialValue;
  Function callback;

  InputFieldWidget({@required this.title, this.initialValue, this.callback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getWidth(15)),
      child: TextField(
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
        keyboardType: TextInputType.text,
        style: new TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}

class FocusSliderWidget extends StatefulWidget {
  @override
  _FocusSliderWidgetState createState() => _FocusSliderWidgetState();
}

class _FocusSliderWidgetState extends State<FocusSliderWidget> {
  int _sliderValue = 3;
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.lightBlue[200],
        inactiveTrackColor: Colors.grey[200],
        trackHeight: 7.0,
        thumbColor: Colors.grey[400],
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
        overlayColor: Colors.lightBlue[200].withAlpha(10),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
      ),
      child: Slider(
        min: 1.0,
        max: 5.0,
        divisions: 7,
        value: _sliderValue.toDouble(),
        label: '${_sliderValue.round()} av 5',
        onChanged: (double currentSizeOfQuiz) {
          setState(() {
            _sliderValue = currentSizeOfQuiz.toInt();
          });
        },
      ),
    );
  }
}
