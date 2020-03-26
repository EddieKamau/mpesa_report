import 'package:mpesa_report/utils/export_utils.dart';

double savingsCosts(String _body){

  String _costRaw = _body.split('cost Ksh.')[1].split('.')[0];

  return amoutFormater(_costRaw);
}