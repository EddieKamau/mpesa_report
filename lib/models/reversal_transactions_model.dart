class ReversalTransactionsModel{
  List<ReversalModel> transactions;

  double get totalAmount {
    double _amount = 0;
    transactions.forEach((object) {
      _amount += object.amount;
      
    } );
    return _amount;
  }
  

}

class ReversalModel{
  ReversalModel({
    this.amount, 
    this.balance, 
    this.dateTime, 
    this.aliasTransId, 
    this.transId,
  });

  final double amount;
  final double balance;
  final DateTime dateTime;
  final String aliasTransId;
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