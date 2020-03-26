class LoansTransactionsModel{
  List<LoanModel> transactions;
  double loan;

  double get totalAmount {
    double _amount = 0;
    transactions.forEach((object) {
      _amount += object.amount;
      
    } );
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

  final double amount;
  final double loan;
  final DateTime dateTime;
  final LoanType loanType;
  final String transId;

  
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