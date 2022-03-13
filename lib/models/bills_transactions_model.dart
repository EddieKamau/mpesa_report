import 'package:mpesa_report/models/transaction_model.dart';

class BillsModel extends TransactionModel{

  String? partyAccount;


  BillsModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.paybill;
    
    // Extract account and name
    if(_body.contains('sent')){
      partyName = _body.split('to ')[1].split(' ')[0]; // name
      partyAccount = _body.split('account ')[1].split(' ')[0]; // account
    } else {
      partyName = 'AIRTIME'; // name
      String _acc = 'self';
      if(_body.split('airtime for ').length > 1 ){
        _acc = _body.split('airtime for ')[1];
      }
      partyAccount = _acc; // account
    }
  }

  @override
  String get partyDetail => 'To: ${partyName ?? ""} _ ${partyAccount ?? ""}';

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