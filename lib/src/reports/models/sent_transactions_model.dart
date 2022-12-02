import 'package:mpesa_report/src/reports/models/transaction_model.dart';


class SentModel extends TransactionModel{

  String? partyAccount;


  SentModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.send;

    // Extract account and name
    String _raw = _body.split('sent to ')[1].split('on')[0];
    List<String> _rawList = _raw.split(' ');
    partyName = _rawList.sublist(0, _rawList.length - 1).join(' '); // name
    partyAccount = _rawList.last; // account
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