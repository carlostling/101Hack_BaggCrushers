import 'package:flutter/material.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as loc;

import 'ScreenUtils.dart';

class RiskPage extends StatelessWidget {
  String _focus;
  String _destination;
  String _age;
  String _carLicense;
  String _kmPerYear;

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
            "Utvärdera ditt fokus:",
            style: TextStyle(
                fontSize: ScreenUtils.getFontSize(20),
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getWidth(50)),
            child: FocusSliderWidget(changeFocus),
          ),
          AutoCompleteWidget(),
          ],
        ),
      ),
    );
  }

  void changeFocus(String newValue) {
    _focus = newValue;
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

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _age = sharedPreferences.getString("age");
    _carLicense = sharedPreferences.getString("carLicense");
    _kmPerYear = sharedPreferences.getString("kmPerYear");

    Profile profile = new Profile(
        _age, _carLicense, _destination, _focus, _kmPerYear, currentLocation);
    ApiService lfApiService = ApiService.instance;
    SmhiApiService smhiApiService = SmhiApiService.instance;
    LFRisk lfRisk = await lfApiService.getAccidentRisk(profile.getDataMap());
    WeatherForecast weatherForecast = await smhiApiService.getForecast(
        currentLocation.longitude, currentLocation.latitude);
    RealRisk realRisk = new RealRisk(lfRisk, weatherForecast);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResultPage(realRisk)));
  }
}


class AutoCompleteWidget extends StatefulWidget {

  final people = <String>["Apelsin", "Henrik"];
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  @override
  _AutoCompleteWidgetState createState() => _AutoCompleteWidgetState();
}

class _AutoCompleteWidgetState extends State<AutoCompleteWidget> {
    String selectedLetter;
    String selectedPerson;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  @override
  Widget build(BuildContext context) {
    return 
            SimpleAutocompleteFormField<String>(
              decoration: InputDecoration(
                  labelText: 'Letter', border: OutlineInputBorder()),
              // suggestionsHeight: 200.0,
              maxSuggestions: 10,
              itemBuilder: (context, item) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(item),
                  ),
              onSearch: (String search) async => search.isEmpty
                  ? widget.letters
                  : widget.letters
                      .where((letter) => search.toLowerCase().contains(letter))
                      .toList(),
              itemFromString: (string) => widget.letters.singleWhere(
                  (letter) => letter == string.toLowerCase(),
                  orElse: () => null),
              onChanged: (value) => setState(() => selectedLetter = value),
              onSaved: (value) => setState(() => selectedLetter = value),
              validator: (letter) => letter == null ? 'Invalid letter.' : null,
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
        onChanged: (double currentSizeOfQuiz) {
          widget.callback(currentSizeOfQuiz.toString());
          setState(() {
            _sliderValue = currentSizeOfQuiz.toInt();
          });
        },
      ),
    );
  }
}

