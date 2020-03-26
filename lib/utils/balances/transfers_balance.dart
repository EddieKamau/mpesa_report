import 'package:mpesa_report/utils/export_utils.dart';

double transfersBalance(String _body){
  double _balanceWallet;

  try{
    List<String> _balanceRawList = _body.split('balance is Ksh');
  String _balanceRaw = _balanceRawList[1].split(' ')[0];
  _balanceWallet = amoutFormater(_balanceRaw.substring(0, _balanceRaw.length-1));
  } catch (e){
    _balanceWallet = 0;
  }

  return _balanceWallet;
}