import 'package:mpesa_report/utils/export_utils.dart';

List<double> savingsBalances(String _body){
  double _balanceWallet;
  double _balanceSavings;

  List<String> _balanceRawList = _body.split('balance is Ksh');
  String _bwR = _balanceRawList[2].split(' ')[0];
  _balanceWallet = amoutFormater(_bwR.substring(0, _bwR.length -1));
  _balanceSavings = amoutFormater(_balanceRawList[1].split(' ')[0]);

  return [_balanceWallet, _balanceSavings];
}