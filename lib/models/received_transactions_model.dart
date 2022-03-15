import 'package:mpesa_report/models/transaction_model.dart';


class ReceivedModel extends TransactionModel{

  String? partyAccount;


  ReceivedModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.receive;
    
    // Extract account and name
    String _raw = _body.split('from ')[1].split('on')[0];
    List<String> _rawList = _raw.split(' ');
    partyName = _rawList.sublist(0, _rawList.length - 1).join(' '); // name
    partyAccount = _rawList.last; // account
  }

  @override
  String get partyDetail => 'From: ${partyName ?? ""} _ ${partyAccount ?? ""}';

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