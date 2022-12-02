import 'package:mpesa_report/src/reports/utils/export_utils.dart';

double transfersCost(String _body){
  String _costRaw;
  try {
    _costRaw = _body.split('cost, Ksh')[1].split('.')[0];
  } catch (e) {
    _costRaw = '0';
  }

  return amoutFormater(_costRaw);
}