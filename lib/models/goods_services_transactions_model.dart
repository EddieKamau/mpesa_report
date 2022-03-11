class GoodsServicesTransactionsModel{
  List<GoodsServicesModel> transactions = [];

  double get totalAmount {
    double _amount = 0;
    for (var object in transactions) {
      _amount += object.amount ?? 0;
      
    }
    return _amount;
  }
  

}

class GoodsServicesModel{
  GoodsServicesModel({
    this.amount, 
    this.balance, 
    this.dateTime, 
    this.partyName, 
    this.transId,
  });

  final double? amount;
  final double? balance;
  final DateTime? dateTime;
  final String? partyName;
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