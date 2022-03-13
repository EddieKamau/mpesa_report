import 'package:mpesa_report/models/export_models.dart';
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
  MpesaTransactionType transactionType = MpesaTransactionType.send;

  String body = '';

  @override
  int compareTo(TransactionModel other) => dateTime.toString().compareTo(other.dateTime.toString());


  String get partyDetail => partyName ?? '';
  bool get isPositive => true;

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

enum MpesaTransactionType{
  send, receive, reversal,
  withdraw, deposit,
  paybill, buyGoods,
  savings, loans,
}

extension TransactionsTotals on List<TransactionModel>{
  double get totalCost {
    double _cost = 0;
    for (var transaction in this) {
      _cost += transaction.cost ?? 0;
      
    }
    return _cost;
  }
  double get totalAmount {
    double _amount = 0;
    for (var transaction in this) {
      _amount += transaction.amount ?? 0;
      
    }
    return _amount;
  }

  double get totalOut{
    double _out = 0;
    for (var transaction in this) {
      if(
        transaction is BillsModel ||
        transaction is GoodsServicesModel ||
        transaction is SentModel ||
        transaction is WithdrawModel
      ){

        _out += transaction.amount ?? 0;
      }
      
    }

    return _out;
  }

  double get totalIn{
    double _in = 0;
    for (var transaction in this) {
      if(
        transaction is ReceivedModel ||
        transaction is ReversalModel
        // transaction is WithdrawModel TODO: deposit
      ){

        _in += transaction.amount ?? 0;
      }
      
    }
    

    return _in;

  }
}