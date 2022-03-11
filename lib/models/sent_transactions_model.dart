class SentTransactionsModel{
  List<SentModel> transactions = [];

  double get totalCost {
    double _cost = 0;
    for (var object in transactions) {
      _cost += object.cost ?? 0;
      
    }
    return _cost;
  }
  double get totalAmount {
    double _amount = 0;
    for (var object in transactions) {
      _amount += object.amount ?? 0;
      
    }
    return _amount;
  }
  

}

class SentModel{
  SentModel({
    this.amount, 
    this.balance, 
    this.cost, 
    this.dateTime, 
    this.partyName, 
    this.partyAccount, 
    this.transId,
  });

  final double? amount;
  final double? balance;
  final double? cost;
  final DateTime? dateTime;
  final String? partyName;
  final String? partyAccount;
  final String? transId;

  
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