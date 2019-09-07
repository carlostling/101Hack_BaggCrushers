
class Risk {
  double _percentile;
  double _score;

  Risk(this._percentile, this._score);

  Risk.fromJson(Map<String, dynamic> json){
    _percentile = json['percentile'];
    _score = json['score'];
  }


  double get percentile =>  _percentile;
  double get score => _score;


}