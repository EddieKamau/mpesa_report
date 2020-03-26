class WithdrawTransactionsModel{
  List<WithdrawModel> transactions;

  double get totalCost {
    double _cost = 0;
    transactions.forEach((object) {
      _cost += object.cost;
      
    } );
    return _cost;
  }
  double get totalAmount {
    double _amount = 0;
    transactions.forEach((object) {
      _amount += object.amount;
      
    } );
    return _amount;
  }
  

}

class WithdrawModel{
  WithdrawModel({
    this.amount, 
    this.balance, 
    this.cost, 
    this.dateTime, 
    this.partyName, 
    this.partyAccount, 
    this.transId,
  });

  final double amount;
  final double balance;
  final double cost;
  final DateTime dateTime;
  final String partyName;
  final String partyAccount;
  final String transId;

  
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