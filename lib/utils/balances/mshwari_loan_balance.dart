import 'package:mpesa_report/utils/export_utils.dart';

double mshwariLoanBalance(String _body){
  double _balanceWallet;
  List<String> _balanceRawList = _body.split('balance is Ksh');
  try{
    String _balanceRaw = _balanceRawList[1].split(' ')[0].split('You')[0];
    _balanceWallet = amoutFormater(_balanceRaw.substring(0, _balanceRaw.length-1));
  } catch (e){
    String _balanceRaw = _body.split('balance is  Ksh')[1].split(' ')[0];
    _balanceWallet = amoutFormater(_balanceRaw.substring(0, _balanceRaw.length-1));
  }

  return _balanceWallet;
}