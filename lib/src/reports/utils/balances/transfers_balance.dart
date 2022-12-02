import 'package:mpesa_report/src/reports/utils/export_utils.dart';

double transfersBalance(String _body){
  double _balanceWallet = 0;

  if(_body.contains('Reversal')){
    return 0;
  }

  try{
    List<String> _balanceRawList = _body.split('balance is Ksh');

    // check if 110.Down || 110.Dial etc
    var _l = _balanceRawList[1].split(' ')[0].split('.');
    if(_l.length > 2){
      _balanceWallet = amoutFormater([_l[0], _l[1]].join(''));
    }else{
      String _balanceRaw = _balanceRawList[1].split(' ')[0];
      _balanceWallet = amoutFormater(_balanceRaw.substring(0, _balanceRaw.length-1));
    }

    
  } catch (e){
    _balanceWallet = 0;
  }

  return _balanceWallet;
}