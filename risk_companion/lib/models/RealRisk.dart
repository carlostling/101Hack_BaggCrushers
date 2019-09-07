import 'package:risk_companion/models/Weather.dart';
import 'package:risk_companion/models/WeatherForecast.dart';
import 'package:risk_companion/models/LFRisk.dart';


class RealRisk{

  double _riskScore;
  LFRisk _lfRisk;
  WeatherForecast _weatherForecast;

  RealRisk(LFRisk lfRisk, WeatherForecast weatherForecast) {
    this._lfRisk = lfRisk;
    this._weatherForecast = weatherForecast;
    calculateRiskScore();
}


  void calculateRiskScore(){
    double lfRiskScore = _lfRisk.score;
    double mmOfRain = _weatherForecast.meanPrecipitationIntensity;
    double riskFromRainScalar = riskFromRain(mmOfRain);
    _riskScore =  lfRiskScore*riskFromRainScalar;
  }

  double riskFromRain(double mmOfRain){
    if(mmOfRain == 0)
      return 1;
    else if(mmOfRain <= 0.39)
      return 1.27;
    else if(mmOfRain > 0.39)
      return 2.46;
  }

   double get riskscore =>  _riskScore;
}

