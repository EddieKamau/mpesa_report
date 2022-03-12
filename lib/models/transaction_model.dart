import 'package:mpesa_report/utils/export_utils.dart';

class TransactionModel implements Comparable<TransactionModel> {
  TransactionModel({
    this.amount, 
    this.balance, 
    this.dateTime, 
    this.partyName, 
    this.transId,
  });
  
  String? transId;
  double? amount;
  double? balance;
  double? cost;
  String? partyName;
  DateTime? dateTime;

  String body = '';

  @override
  int compareTo(TransactionModel other) => dateTime.toString().compareTo(other.dateTime.toString());


  String get partyDetail => partyName ?? '';

  TransactionModel.fromMessageString(String _body){
    body = _body;
    // Extract transId
    transId = _body.split(' ')[0];

    // Extract amount
    amount = extractAmount(_body);

    // Extract balance
    balance = transfersBalance(_body);

    // Extract cost
    cost = transfersCost(_body);

    // Extract datetime
    dateTime = extractDate(_body);
  }
}