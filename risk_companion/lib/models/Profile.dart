import 'package:location/location.dart';

class Profile {
  String _age;
  String _focus;
  String _carLicense;
  String _kmPerYear;
  String _destination;
  LocationData _locationData;


  set focus(String focus) {
    _focus = focus;
  }

  set carLicense(String carLicense) {
    _carLicense = carLicense;
  }

  set kmPerYear(String kmPerYear) {
    _kmPerYear = (double.parse(kmPerYear) / 10).toString();
  }

  set destination(String destination) {
    _destination = destination;
  }

  Map<String, String> getDataMap() {
    Map<String, String> dataMap = new Map<String, String>();
    dataMap.putIfAbsent("age", () => _age);
    dataMap.putIfAbsent("focus", () => _focus);
    dataMap.putIfAbsent("carLicence", () => _carLicense);
    dataMap.putIfAbsent("distance", () => _kmPerYear);
    dataMap.putIfAbsent("destination", () => _destination);

    return dataMap;
  }
  Profile(this._age,this._carLicense,this._destination,this._focus,this._kmPerYear,this._locationData);




set age(String age){
  _age = age;
}
}
