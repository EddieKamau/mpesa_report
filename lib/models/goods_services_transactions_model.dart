import 'package:mpesa_report/models/transaction_model.dart';

class GoodsServicesModel extends TransactionModel{
  
  GoodsServicesModel.fromMessageString(String _body):super.fromMessageString(_body){
    // Extract name
    partyName = _body.split('paid to ')[1].split('.')[0]; // name
  }
  @override
  String get partyDetail => 'To: ${partyName ?? ""}';

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