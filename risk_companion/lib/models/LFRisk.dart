
class LFRisk {
  double _percentile;
  double _score;

  LFRisk(this._percentile, this._score);

  LFRisk.fromJson(Map<String, dynamic> json){
    _percentile = json['percentile'];
    _score = json['score'];
  }

  double get percentile =>  _percentile;
  double get score => _score;


}