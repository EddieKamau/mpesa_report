import 'package:mpesa_report/models/export_models.dart' show BillsModel, BillsTransactionsModel;
import 'package:mpesa_report/utils/export_utils.dart';

class BillsModule{

  BillsTransactionsModel billsTransactionsModel = BillsTransactionsModel();
  List<BillsModel> billsModels = [];




  void process(String _body){
    DateTime? _dateTime;
    double _amount = 0;
    String? _transId;
    double _cost = 0;
    double? _balanceWallet;
    String? _secondPartName;
    String? _secondPartAccount;

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balance
    _balanceWallet = transfersBalance(_body);

    // Extract cost
    _cost = transfersCost(_body);

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract account and name
    if(_body.contains('sent')){
      _secondPartName = _body.split('to ')[1].split(' ')[0]; // name
      _secondPartAccount = _body.split('account ')[1].split(' ')[0]; // account
    } else {
      _secondPartName = 'SAFARICOM AIRTIME'; // name
      String _acc = 'self';
      if(_body.split('airtime for ').length > 1 ){
        _acc = _body.split('airtime for ')[1];
      }
      _secondPartAccount = _acc; // account
    }

    // Extract transId
    _transId = _body.split(' ')[0];



    billsModels.add(BillsModel(
      amount: _amount,
      balance: _balanceWallet,
      cost: _cost,
      dateTime: _dateTime,
      partyAccount: _secondPartAccount,
      partyName: _secondPartName,
      transId: _transId,
    ));
    billsTransactionsModel.transactions = billsModels;
  }

}