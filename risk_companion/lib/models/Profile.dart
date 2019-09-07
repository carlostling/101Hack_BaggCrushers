//Ålder, kön, regnummer, mil per år, slutdestination,

class Profile {
  String _age;
  String _focus;
  String _carLicense;
  String _kmPerYear;
  String _destination;

  Profile(this._age,this._carLicense,this._destination,this._focus,this._kmPerYear);




set age(String age){
  _age = age;
}

set focus(String focus){
  _focus = focus;
}

set carLicense(String carLicense){
  _carLicense = carLicense;
}

set kmPerYear(String kmPerYear){
  _kmPerYear = kmPerYear;
}

set destination(String destination){
  _destination = destination;
}

}