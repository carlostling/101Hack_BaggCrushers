import 'dart:convert';
import 'package:risk_companion/models/WeatherForecast.dart';
import 'package:http/http.dart' as http;

class SmhiApiService {

  SmhiApiService._privateConstructor();
  static final SmhiApiService _instance = SmhiApiService._privateConstructor();
  static SmhiApiService get instance {return _instance;}


  Future<WeatherForecast> getForecast(double longitude, double latitude) async {
    longitude = 24.794242;
    latitude = 59.005735;
    final response = await http.get('https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/${longitude.toStringAsFixed(6)}/lat/${latitude.toStringAsFixed(6)}/data.json');
    if(response.statusCode != 200){
      throw Exception('Failed to load weather ' + response.toString());
    }
    return WeatherForecast.fromJson(json.decode(response.body));
  }
}
