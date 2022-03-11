import 'package:mpesa_report/models/export_models.dart' show LoanModel, LoansTransactionsModel, LoanType;
import 'package:mpesa_report/utils/export_utils.dart';

class MshwariLoansModule{

  LoansTransactionsModel loansTransactionsModel = LoansTransactionsModel();
  List<LoanModel> loanModels = [];

  double _balanceWallet = 0;

  double get balanceWallet => _balanceWallet;


  void process(String _body, bool pay){
    DateTime? _dateTime;
    double _amount = 0;
    double? _loan;
    String? _transId;

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balances
    _balanceWallet = mshwariLoanBalance(_body);

    // loan
    if(_body.contains('repaid in full')){
      _loan = 0;
    } else {
      _loan = amoutFormater(_body.split('Ksh')[1].split(' ')[0]);
    }

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract transId
    _transId = _body.split(' ')[0];



    loanModels.add(LoanModel(
      amount: _amount,
      loan: _loan,
      loanType: pay ? LoanType.loanPay : LoanType.loanGet,
      dateTime: _dateTime,
      transId: _transId,
    ));
    loansTransactionsModel.transactions = loanModels;
  }

}