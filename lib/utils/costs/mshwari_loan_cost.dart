import 'package:mpesa_report/utils/export_utils.dart';

double mshwariLoanCost(String _body){

  String _costRaw = _body.split('cost Kshs ')[1];

  return amoutFormater(_costRaw);
}