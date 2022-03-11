class ReceivedTransactionsModel{
  List<ReceivedModel> transactions = [];

  double get totalAmount {
    double _amount = 0;
    for (var object in transactions) {
      _amount += object.amount ?? 0;
      
    }
    return _amount;
  }
  

}

class ReceivedModel{
  ReceivedModel({
    this.amount, 
    this.balance, 
    this.dateTime, 
    this.partyName, 
    this.partyAccount, 
    this.transId,
  });

  final double? amount;
  final double? balance;
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