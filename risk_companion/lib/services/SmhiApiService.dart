import 'dart:convert';
import 'package:risk_companion/models/WeatherForecast.dart';
import 'package:http/http.dart' as http;

class SmhiApiService {

  SmhiApiService._privateConstructor();
  static final SmhiApiService _instance = SmhiApiService._privateConstructor();
  static SmhiApiService get instance {return _instance;}


  Future<WeatherForecast> getForecast(double longitude, double latitude) async {

    final response = await http.get('https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/${longitude}/lat/${latitude}/data.json');
    if(response.statusCode != 200){
      throw Exception('Failed to load weather ' + response.toString());
    }

    return WeatherForecast.fromJson(json.decode(response.body));
  }
}
