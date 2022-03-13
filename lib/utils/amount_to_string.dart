extension AmountToString on double?{
  String get string{
  var _amount = (this ?? 0).toString();
  
  var _l = _amount.split('.');

  if(_l[0].length > 3){
    var val = _l[0];
    var _commas = (val.length / 3).floor();
    String _new = val.substring(0, val.length-(3*_commas));
    for(int i=1; i<=_commas; i++){
      _new = '$_new,${val.substring(val.length-(3*i), val.length-(3*(i-1)))}';
    }
    _amount = _new;
  }else{
    _amount = _l[0];
  }

  if(_l.length > 1){ //add decimal
    _amount = '$_amount.${_l[1]}';
  }

  return _amount;
}
}