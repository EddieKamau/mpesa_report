import 'dart:math';

double amoutFormater(String _value){ 
  double _amount = 0;
  try {
    List _amountRaw = _value.split(',');
    for(int i = _amountRaw.length-1; i >= 0; i--){
      _amount += pow(1000, i) * double.parse(_amountRaw[(_amountRaw.length-1) - i]);
    }
  } catch (e) {
    _amount = 0;
  }
  return _amount;
}