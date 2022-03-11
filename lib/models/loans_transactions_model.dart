class LoansTransactionsModel{
  List<LoanModel> transactions = [];
  double loan = 0;

  double get totalAmount {
    double _amount = 0;
    for (var object in transactions) {
      _amount += object.amount ?? 0;
      
    }
    return _amount;
  }
  
  set setLoan(double _amount){
    loan = _amount;
  }
  

}

class LoanModel{
  LoanModel({
    this.amount, 
    this.loan, 
    this.dateTime, 
    this.loanType, 
    this.transId,
  });

  final double? amount;
  final double? loan;
  final DateTime? dateTime;
  final LoanType? loanType;
  final String? transId;

  
}

enum LoanType{
  loanGet,
  loanPay,
}

/// model{
///   date
///   amount
///   type
///   second party name
///   second party account
///   loan
///   cost
///   transId
/// }