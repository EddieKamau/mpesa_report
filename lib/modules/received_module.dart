import 'package:mpesa_report/models/export_models.dart' show ReceivedModel, ReceivedTransactionsModel;
import 'package:mpesa_report/utils/export_utils.dart';

class ReceivedModule{

  ReceivedTransactionsModel receivedTransactionsModel = ReceivedTransactionsModel();
  List<ReceivedModel> receivedModels = [];

  DateTime? _dateTime;
  double _amount = 0;
  String? _transId;
  double _balanceWallet = 0;
  String? _secondPartName;
  String? _secondPartAccount;


  void process(String _body){

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balance
    _balanceWallet = transfersBalance(_body);

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract account and name
    String _raw = _body.split('from ')[1].split('on')[0];
    List<String> _rawList = _raw.split(' ');
    _secondPartName = _rawList.sublist(0, _rawList.length - 1).join(' '); // name
    _secondPartAccount = _rawList.last; // account

    // Extract transId
    _transId = _body.split(' ')[0];



    receivedModels.add(ReceivedModel(
      amount: _amount,
      balance: _balanceWallet,
      dateTime: _dateTime,
      partyAccount: _secondPartAccount,
      partyName: _secondPartName,
      transId: _transId,
    ));
    receivedTransactionsModel.transactions = receivedModels;
  }

}