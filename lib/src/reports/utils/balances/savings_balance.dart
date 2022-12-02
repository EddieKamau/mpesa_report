import 'package:mpesa_report/src/reports/utils/export_utils.dart';

List<double> savingsBalances(String _body){
  double _balanceWallet = 0;
  double _balanceSavings = 0;

  List<String> _balanceRawList = _body.split('balance is Ksh');
  if(_body.contains('KCB')){
    try {
      var _rWaBal = _balanceRawList[2];
      _balanceWallet = amoutFormater(_rWaBal.substring(0, _rWaBal.length -1));
    } catch (e) {
      _balanceWallet = 0;
    }

    var _rBaSav = _balanceRawList[1].split(' ')[0];
    _balanceSavings= amoutFormater(_rBaSav.substring(0, _rBaSav.length-1));
  }else{
    try {
        String _bwR = _balanceRawList[2].split(' ')[0];
      _balanceWallet = amoutFormater(_bwR.substring(0, _bwR.length -1));
    } catch (e) {
      _balanceWallet = 0;
    }
    _balanceSavings = amoutFormater(_balanceRawList[1].split(' ')[0]);
  }

  return [_balanceWallet, _balanceSavings];
}