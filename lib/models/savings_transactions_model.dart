class SavingsTransactionsModel{
  List<SavingsModel> transactions;
  double balance;

  double get totalAmount {
    double _amount = 0;
    transactions.forEach((object) {
      _amount += object.amount;
      
    } );
    return _amount;
  }
  
  set setBalance(double _amount){
    balance = _amount;
  }
  

}

class SavingsModel{
  SavingsModel({
    this.amount, 
    this.balance, 
    this.dateTime, 
    this.savingsType, 
    this.transId,
  });

  final double amount;
  final double balance;
  final DateTime dateTime;
  final SavingsType savingsType;
  final String transId;

  
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