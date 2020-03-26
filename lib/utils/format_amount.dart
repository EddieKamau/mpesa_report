import 'dart:math';

double amoutFormater(String _value){
  List _amountRaw = _value.split(',');
  double _amount = 0;
  for(int i = _amountRaw.length-1; i >= 0; i--){
    _amount += pow(1000, i) * double.parse(_amountRaw[(_amountRaw.length-1) - i]);
  }
  return _amount;
}