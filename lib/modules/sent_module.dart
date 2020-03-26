import 'package:mpesa_report/models/export_models.dart' show SentModel, SentTransactionsModel;
import 'package:mpesa_report/utils/export_utils.dart';

class SentModule{

  SentTransactionsModel sentTransactionsModel = SentTransactionsModel();
  List<SentModel> sentModels = [];

  DateTime _dateTime;
  double _amount = 0;
  String _transId;
  double _cost = 0;
  double _balanceWallet;
  String _secondPartName;
  String _secondPartAccount;


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
    String _raw = _body.split('sent to ')[1].split('on')[0];
    List<String> _rawList = _raw.split(' ');
    _secondPartName = _rawList.sublist(0, _rawList.length - 1).join(' '); // name
    _secondPartAccount = _rawList.last; // account

    // Extract transId
    _transId = _body.split(' ')[0];



    sentModels.add(SentModel(
      amount: _amount,
      balance: _balanceWallet,
      cost: _cost,
      dateTime: _dateTime,
      partyAccount: _secondPartAccount,
      partyName: _secondPartName,
      transId: _transId,
    ));
    sentTransactionsModel.transactions = sentModels;
  }

}