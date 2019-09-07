import 'package:flutter_test/flutter_test.dart';
import 'package:risk_companion/models/WeatherForecast.dart';
import 'package:risk_companion/services/SmhiApiService.dart';
import 'package:risk_companion/services/apiService.dart';
import 'package:risk_companion/models/LFRisk.dart';
import 'package:risk_companion/models/RealRisk.dart';
void main() {
  SmhiApiService apiService = SmhiApiService.instance;
  ApiService apiServiceLF = ApiService.instance;
  test('Create a RealRisk object', () async {

    WeatherForecast weatherForecast = await apiService.getForecast(16.158, 58.58);
    LFRisk lfRisk = await apiServiceLF.getAccidentRisk({});
    RealRisk realRisk = new RealRisk(lfRisk, weatherForecast);
    print(realRisk);
  });

}
