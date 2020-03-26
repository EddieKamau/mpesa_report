import 'package:mpesa_report/models/export_models.dart' show SavingsModel, SavingsTransactionsModel, SavingsType;
import 'package:mpesa_report/utils/export_utils.dart';

class SavingsModule{

  SavingsTransactionsModel savingsTransactionsModel = SavingsTransactionsModel();
  List<SavingsModel> savingsModels = [];

  DateTime _dateTime;
  double _amount = 0;
  double _balanceSavings = 0;
  double _balanceWallet = 0;
  String _transId;

  double get balanceWallet => _balanceWallet;


  void process(String _body, bool save){

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balances
    List<double> _balances = savingsBalances(_body);
    _balanceWallet = _balances[0];
    _balanceSavings = _balances[1];

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract transId
    _transId = _body.split(' ')[0];



    savingsModels.add(SavingsModel(
      amount: _amount,
      balance: _balanceSavings,
      dateTime: _dateTime,
      transId: _transId,
      savingsType: save ? SavingsType.savingsIn : SavingsType.savingsOut
    ));
    savingsTransactionsModel.transactions = savingsModels;
  }

}