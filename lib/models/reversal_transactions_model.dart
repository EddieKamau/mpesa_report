import 'package:mpesa_report/models/transaction_model.dart';

class ReversalTransactionsModel{
  List<ReversalModel> transactions = [];

  double get totalAmount {
    double _amount = 0;
    for (var object in transactions) {
      _amount += object.amount ?? 0;
      
    }
    return _amount;
  }
  

}

class ReversalModel extends TransactionModel{
  
  String? prevTransId;


  ReversalModel.fromMessageString(String _body):super.fromMessageString(_body){
    partyName = 'reversal';
    // aliasId
    prevTransId = _body.split('of transaction ')[1].split(' ')[0];
  }

  @override
  String get partyDetail => '${partyName ?? ""} for ${prevTransId ?? ""}';

  
}

/// model{
///   date
///   amount
///   type
///   second party name
///   second party account
///   balance
///   cost
///   transId
/// }