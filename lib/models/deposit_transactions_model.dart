import 'package:mpesa_report/models/transaction_model.dart';

class DepositModel extends TransactionModel{
  
  DepositModel.fromMessageString(String _body):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.deposit;
    
    // Extract name
    partyName = _body.split('cash to ')[1].split(' New')[0]; // name
  }
  @override
  String get partyDetail => 'At: ${partyName ?? ""}';

  @override
  bool get isPositive => true;

}