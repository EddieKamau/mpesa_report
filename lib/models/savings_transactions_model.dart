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

class SavingsModel{
  SavingsModel({
    this.amount, 
    this.balance, 
    this.dateTime, 
    this.savingsType, 
    this.transId,
  });

  final double? amount;
  final double? balance;
  final DateTime? dateTime;
  final SavingsType? savingsType;
  final String? transId;

  
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