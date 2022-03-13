import 'package:mpesa_report/models/transaction_model.dart';
import 'package:mpesa_report/utils/balances/mshwari_loan_balance.dart';
import 'package:mpesa_report/utils/format_amount.dart';

class LoanModel extends TransactionModel{

  double loan = 0;
  LoanType loanType = LoanType.loanGet;


  LoanModel.fromMessageString(String _body, bool pay):super.fromMessageString(_body){
    transactionType = MpesaTransactionType.loans;
    
    loanType= pay ? LoanType.loanPay : LoanType.loanGet;
    partyName = 'Loan';

    // loan
    // check if kcb mpesa
    if(_body.contains('KCB M-PESA')){
      loan = 0;
    }else if(_body.contains('repaid in full')){
      loan = 0;
    } else {
      loan = amoutFormater(_body.split('Ksh')[1].split(' ')[0]);
    }

    // Extract balances
    balance = mshwariLoanBalance(_body);
  }

  @override
  String get partyDetail => loanType == LoanType.loanPay ? 'Pay loan': 'Get loan';

  @override
  bool get isPositive => loanType ==LoanType.loanGet;

  
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