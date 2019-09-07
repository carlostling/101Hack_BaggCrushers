import 'package:flutter_test/flutter_test.dart';
import 'package:risk_companion/models/WeatherForecast.dart';
import 'package:risk_companion/services/SmhiApiService.dart';

void main() {
  SmhiApiService apiService = SmhiApiService.instance;

  test('Weatherforecast http call works.', () async {

    WeatherForecast weatherForecast = await apiService.getForecast(16.158, 58.58);

    //print(weatherForecast.airTemperature);
    print(weatherForecast.json);
  });

}
