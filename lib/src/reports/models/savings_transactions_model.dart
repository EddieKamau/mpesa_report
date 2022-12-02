import 'package:mpesa_report/src/reports/models/transaction_model.dart';
import 'package:mpesa_report/src/reports/utils/balances/savings_balance.dart';

class SavingsTransactionsModel{
  List<SavingsModel> transactions = [];
  double balance = 0;

  double get totalAmount {
    double _amount = 0;
    for (var object in transactions) {
      _amount += object.amount ?? 0;
      
    }
    return _amount;
  }
  
  set setBalance(double _amount){
    balance = _amount;
  }
  

}

class SavingsModel extends TransactionModel{

  
  SavingsType savingsType = SavingsType.savingsIn;
  double savingsBalance = 0;


  SavingsModel.fromMessageString(String _body, bool save):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.savings;

    savingsType = save ? SavingsType.savingsIn : SavingsType.savingsOut;
    partyName = 'Savings';

    // Extract balances
    List<double> _balances = savingsBalances(_body);
    balance = _balances[0];
    savingsBalance = _balances[1];
  }

  @override
  String get partyDetail => savingsType == SavingsType.savingsIn ? 'To savings' : 'From savings';

  @override
  bool get isPositive => savingsType == SavingsType.savingsOut;


}

enum SavingsType{
  savingsIn,
  savingsOut,
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