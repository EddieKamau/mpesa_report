import 'package:mpesa_report/src/reports/models/transaction_model.dart';

class ReversalModel extends TransactionModel{
  
  String? prevTransId;


  ReversalModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.reversal;
    
    partyName = 'reversal';
    // aliasId
    prevTransId = _body.split('of transaction ')[1].split(' ')[0];
  }

  @override
  String get partyDetail => '${partyName ?? ""} for ${prevTransId ?? ""}';

  @override
  bool get isPositive => true;

  
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