
class WeatherForecast {
  Map<String, dynamic> _json;
  double _airPressure;
  double _airTemperature;
  double _horizontalVisibility;
  int _windDirection;
  double _windSpeed;
  double _windGustSpeed;
  int _relativeHumidity;
  int _thunderProbability;
  double _minPrecipitationIntensity;
  double _maxPrecipitationIntensity;
  double _meanPrecipitationIntensity;
  double _medianPrecipitationIntensity;
  int _percentFrozenPrecipitation;
  int _precipitationCategory;
  int _weatherSymbol;


  WeatherForecast.fromJson(Map<String, dynamic> json){
    json = json['timeSeries'][0];
    _json = json;

    List<dynamic> parameters = json['parameters'];

    parameters.forEach((parameter) {
      String parameterName = parameter["name"];
      var value = parameter["values"][0];

      switch(parameterName) {
        case 'msl':
          _airPressure = value;
          break;
        case 't':
          _airTemperature = value;
          break;
        case 'vis':
          _horizontalVisibility = value;
          break;
        case 'wd':
          _windDirection = value;
          break;
        case 'ws':
          _windSpeed = value;
          break;
        case 'r':
          _relativeHumidity = value;
          break;
        case 'tstm':
          _thunderProbability = value;
          break;
        case 'gust':
          _windGustSpeed = value;
          break;
        case 'pmin':
          _minPrecipitationIntensity = value;
          break;
        case 'pmax':
          _maxPrecipitationIntensity = value;
          break;
        case 'spp':
          _percentFrozenPrecipitation = value;
          break;
        case 'pcat':
          _precipitationCategory = value;
          break;
        case 'pmean':
          _meanPrecipitationIntensity = value;
          break;
        case 'pmedian':
          _medianPrecipitationIntensity = value;
          break;
        case 'Wsymb2':
          _weatherSymbol = value;
          break;
      }
    });
  }

  int get weatherSymbol => _weatherSymbol;

  int get precipitationCategory => _precipitationCategory;

  int get percentFrozenPrecipitation => _percentFrozenPrecipitation;

  double get medianPrecipitationIntensity => _medianPrecipitationIntensity;

  double get meanPrecipitationIntensity => _meanPrecipitationIntensity;

  double get maxPrecipitationIntensity => _maxPrecipitationIntensity;

  double get minPrecipitationIntensity => _minPrecipitationIntensity;

  int get thunderProbability => _thunderProbability;

  int get relativeHumidity => _relativeHumidity;

  double get windGustSpeed => _windGustSpeed;

  double get windSpeed => _windSpeed;

  int get windDirection => _windDirection;

  double get horizontalVisibility => _horizontalVisibility;

  double get airTemperature => _airTemperature;

  double get airPressure => _airPressure;

  Map<String, dynamic> get json => _json;

}
