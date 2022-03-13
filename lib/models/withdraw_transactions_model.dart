import 'package:mpesa_report/models/transaction_model.dart';


class WithdrawModel extends TransactionModel{

  String? partyAccount;


  WithdrawModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.withdraw;

    // Extract account and name
    String _raw = _body.split('from ')[1].split('New')[0];
    partyName = _raw.split(' - ')[1]; // name
    partyAccount = _raw.split(' - ')[0]; // account
  }

  @override
  String get partyDetail => 'From: ${partyName ?? ""} - ${partyAccount ?? ""}';

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