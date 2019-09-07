
class Weather {
  String _date;
  double _temperature;
  double _windDirection;
  double _windSpeed;
  double _rain;
  double _snowdepth;
  double _sunshine;
  double _visibility;
  double _cloudCover;

  Weather.fromJson(Map<String, dynamic> json){
    _date = json ["date"];
    _temperature = json["temperature"];
    _windDirection = json["wind_direction"];
    _windSpeed = json["wind_speed"];
    _rain = json["rain"];
    _snowdepth = json["snowdepth"];
    _sunshine = json["sunshine"];
    _visibility = json["visibility"];
    _cloudCover = json["cloud_cover"];
  }


  String toString(){
    return "Weather: ${_date}, ${_temperature}, ${_windDirection}, ${_windSpeed}, ${_rain}, ${_snowdepth}, ${_sunshine}, ${_visibility}, ${_cloudCover}";
  }

  double get cloudCover => _cloudCover;

  double get visibility => _visibility;

  double get sunshine => _sunshine;

  double get snowdepth => _snowdepth;

  double get rain => _rain;

  double get windSpeed => _windSpeed;

  double get windDirection => _windDirection;

  double get temperature => _temperature;

  String get date => _date;

}
