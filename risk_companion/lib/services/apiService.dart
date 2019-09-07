import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:risk_companion/models/LFRisk.dart';
import 'package:risk_companion/models/Weather.dart';

class ApiService {

  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  static final String _apiKey = "473c9e10-dca6-4ae4-a4f4-2ac562223d9b";

  static ApiService get instance {return _instance;}

  Future<LFRisk>  getAccidentRisk(Map<String, String> params) async{
    _decorateParams(params);

    var uri = Uri.https('api.101hack.se', 'v1/accident-risk', params);
    final response = await http.get(uri);

    if(response.statusCode != 200){
      throw Exception('Failed to load post' + response.toString());
    }

    return LFRisk.fromJson(json.decode(response.body));
  }

  Future<Risk> getAccidentRiskFromDestinations(String origin, String destination, Map<String, String> params) async {
    _decorateParams(params);
    params["origin"] = origin;
    params["destination"] = destination;

    var uri = Uri.https('api.101hack.se', 'v1/accident-risk/route', params);
    final response = await http.get(uri);

    if(response.statusCode != 200){
      throw Exception('Failed to load post' + response.toString());
    }

    return Risk.fromJson(json.decode(response.body));
  }

  Future<Weather> getWeatherFromPoint(double longitude, double latitude, DateTime date) async{
    Map<String, String> params = {
      "lat": latitude.toString(),
      "lon": longitude.toString(),
      "date": "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}",
    };

    _decorateParams(params);

    var uri = Uri.https('api.101hack.se', 'v1/weather/point', params);
    final response = await http.get(uri);

    if(response.statusCode != 200){
      throw Exception('Failed to load weather ' + response.toString());
    }

    return Weather.fromJson(json.decode(response.body));
  }


  _decorateParams(Map<String, String> params){
    params["key"] = _apiKey;

    return params;
  }

}
