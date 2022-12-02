import 'package:mpesa_report/src/reports/utils/export_utils.dart';

double extractAmount(String _body){
  double _amount = 0;
  String _amountRaw = _body.split('Ksh')[1].split(' ')[0];
  _amount = amoutFormater(_amountRaw);
  return _amount;
}