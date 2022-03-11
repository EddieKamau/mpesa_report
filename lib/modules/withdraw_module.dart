import 'package:mpesa_report/models/export_models.dart' show WithdrawModel, WithdrawTransactionsModel;
import 'package:mpesa_report/utils/export_utils.dart';

class WithdrawModule{

  WithdrawTransactionsModel withdrawTransactionsModel = WithdrawTransactionsModel();
  List<WithdrawModel> withdrawModels = [];

  DateTime? _dateTime;
  double _amount = 0;
  String? _transId;
  double _cost = 0;
  double _balanceWallet = 0;
  String? _secondPartName;
  String? _secondPartAccount;


  void process(String _body){

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balance
    _balanceWallet = transfersBalance(_body);

    // Extract cost
    _cost = transfersCost(_body);

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract account and name
    String _raw = _body.split('from ')[1].split('New')[0];
    _secondPartName = _raw.split(' - ')[1]; // name
    _secondPartAccount = _raw.split(' - ')[0]; // account

    // Extract transId
    _transId = _body.split(' ')[0];



    withdrawModels.add(WithdrawModel(
      amount: _amount,
      balance: _balanceWallet,
      cost: _cost,
      dateTime: _dateTime,
      partyAccount: _secondPartAccount,
      partyName: _secondPartName,
      transId: _transId,
    ));
    withdrawTransactionsModel.transactions = withdrawModels;
  }

}