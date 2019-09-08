import 'package:flutter/material.dart';
import 'package:risk_companion/SignUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:risk_companion/ResultPage.dart';
import 'package:risk_companion/models/LFRisk.dart';
import 'package:risk_companion/models/Profile.dart';
import 'package:risk_companion/models/RealRisk.dart';
import 'package:risk_companion/models/WeatherForecast.dart';
import 'package:risk_companion/services/SmhiApiService.dart';
import 'package:risk_companion/services/apiService.dart';
import 'ScreenUtils.dart';
import 'package:geocoder/geocoder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as loc;

import 'ScreenUtils.dart';

class RiskPage extends StatefulWidget {
  @override
  _RiskPageState createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  String _focus = "3";

  String _destination;

  String _age;

  String _carLicense;

  String _kmPerYear;

  bool onClick = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Risk analysis"),
        backgroundColor: Color.fromRGBO(0, 90, 160, 1),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage())),
          ),
        ],
      ),
      
      body: Stack(
          children: <Widget>[
            
            Column(
              children: <Widget>[
                SizedBox(height: ScreenUtils.getHeight(50),),

                Center(
              child: Text(
            "Trip specifics",
            style: TextStyle(
              fontSize: ScreenUtils.getFontSize(40),
              color: Color.fromRGBO(0, 90, 160, 1),
            ),
            textAlign: TextAlign.center,
          )),
                SizedBox(height: ScreenUtils.getHeight(30),),
                
                Text(
                "Evaluate your focus:",
                style: TextStyle(
                    fontSize: ScreenUtils.getFontSize(20),
                    fontWeight: FontWeight.w500),
              ),
                 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getWidth(50)),
                child: FocusSliderWidget(changeFocus),
              ),
              SizedBox(height: ScreenUtils.getHeight(30),),
              Center(
              child: Text(
                "Final destination:",
                style: TextStyle(
                    fontSize: ScreenUtils.getFontSize(20),
                    fontWeight: FontWeight.w500),
              ),),
              
          SizedBox(height: ScreenUtils.getHeight(10),),
              AutoCompleteWidget(changeDestination),
               Text(
                "*Destination is optinal, but gives a better risk analysis.",
                style: TextStyle(
                    fontSize: ScreenUtils.getFontSize(11),
                    fontWeight: FontWeight.w500,color: Colors.grey[500]) ,
              ),
              ],
            ),
           Align(
              alignment: Alignment.bottomCenter,
              
              child: 
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: RaisedButton(
                  onPressed: () {_submit(context);
                  setState(() {
                    onClick = true;
                  });
                   },
                  color: Color.fromRGBO(227, 6, 19, 0.8),
                  shape: StadiumBorder(),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: !onClick ? Text(
                      "Calculate risk",
                      style: TextStyle(
                          color: Colors.white, fontSize: ScreenUtils.getFontSize(25)),
                    ): CircularProgressIndicator(backgroundColor: Colors.grey[300],),
                  ),
              ),
               ),
            )
          ],
        ),
      
    );
  }

  void changeFocus(String newValue) {
    setState(() {
    _focus = newValue;
    });
  }

  void changeDestination(String newValue) {
    setState(() {
    _destination = newValue;
    });
  }

  void _submit(BuildContext context) async {
    loc.LocationData currentLocation;
    var location = new loc.Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      currentLocation = null;
      return;
    }

    ApiService lfApiService = ApiService.instance;
    SmhiApiService smhiApiService = SmhiApiService.instance;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _age = sharedPreferences.getString("age");
    _carLicense = sharedPreferences.getString("carLicense");
    _kmPerYear = sharedPreferences.getString("kmPerYear");
    var _currentLocationAdress = await Geocoder.local.findAddressesFromCoordinates(Coordinates(currentLocation.latitude, currentLocation.longitude));

    Profile profile = new Profile(
        _age, _carLicense, _destination, _focus, _kmPerYear, currentLocation);

    LFRisk lfRisk;
    if(profile.destination != null && profile.destination.isNotEmpty){
      lfRisk = await lfApiService.getAccidentRiskFromDestinations(_currentLocationAdress[0].addressLine, profile.destination, profile.getDataMap());
    }else{
      lfRisk = await lfApiService.getAccidentRisk(profile.getDataMap());
    }

    WeatherForecast weatherForecast = await smhiApiService.getForecast(
        currentLocation.longitude, currentLocation.latitude);
    RealRisk realRisk = new RealRisk(lfRisk, weatherForecast);
    onClick = false;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResultPage(realRisk, double.parse(_focus))));
  }
}


class AutoCompleteWidget extends StatefulWidget {
  final Function _callback;

  AutoCompleteWidget(this._callback);

  @override
  _AutoCompleteWidgetState createState() => _AutoCompleteWidgetState();
}

class _AutoCompleteWidgetState extends State<AutoCompleteWidget> {
  String selectedLetter;
  String selectedPerson;
  GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: "AIzaSyACilHiwdEQLGgtahLn578oUXLuQrXgGcg");

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getWidth(10)),
        child: SimpleAutocompleteFormField<String>(
          decoration: new InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: "Destination",
            fillColor: Colors.grey,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(20.0),
              borderSide: new BorderSide(),
            ),
          ),
          maxSuggestions: 10,

          itemBuilder: (context, item) =>
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(item),
              ),
          onSearch: (String search) async {

            if(search.isNotEmpty){

              PlacesAutocompleteResponse response = await _places.autocomplete(search, language: "sv", components: [Component("country", "SE")]);
              return response.predictions.map((prediction){
                return prediction.structuredFormatting.mainText;
              }).toList();
            }else {
              return new List<String>();
            }

          },
          itemFromString: (string) => null,
          onChanged: (value) {
            setState(() => selectedLetter = value);
            widget._callback(value);},
          validator: (letter) => letter == null ? 'Invalid.' : null,
        ),
      );
  }
}

class FocusSliderWidget extends StatefulWidget {
  Function callback;

  FocusSliderWidget(this.callback);

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
        label: '${_sliderValue.round()} out of 5',
        onChanged: (double value) {
          int focus = value.toInt()*80;
          widget.callback(focus.toString());
          setState(() {
            _sliderValue = value.toInt();
          });
        },
      ),
    );
  }
}

