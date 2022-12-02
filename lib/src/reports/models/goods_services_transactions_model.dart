import 'package:mpesa_report/src/reports/models/transaction_model.dart';

class GoodsServicesModel extends TransactionModel{
  
  GoodsServicesModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.buyGoods;
    
    // Extract name
    partyName = _body.split('paid to ')[1].split('.')[0]; // name
  }
  @override
  String get partyDetail => 'To: ${partyName ?? ""}';

  @override
  bool get isPositive => false;

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