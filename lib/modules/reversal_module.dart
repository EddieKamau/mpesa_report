import 'package:mpesa_report/models/export_models.dart' show ReversalModel, ReversalTransactionsModel;
import 'package:mpesa_report/utils/export_utils.dart';

class ReversalModule{

  ReversalTransactionsModel reversalTransactionsModel = ReversalTransactionsModel();
  List<ReversalModel> reversalModels = [];



  void process(String _body){
    DateTime? _dateTime;
    double _amount = 0;
    String? _transId;
    double _balanceWallet = 0;
    String? _aliasTransId;

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balance
    _balanceWallet = transfersBalance(_body);

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract transId
    _transId = _body.split(' ')[0];

    // aliasId
    _aliasTransId = _body.split('of transaction ')[1].split(' ')[0];



    reversalModels.add(ReversalModel(
      amount: _amount,
      balance: _balanceWallet,
      dateTime: _dateTime,
      transId: _transId,
      aliasTransId: _aliasTransId
    ));
    reversalTransactionsModel.transactions = reversalModels;
  }

}