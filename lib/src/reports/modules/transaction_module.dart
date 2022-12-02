import 'package:mpesa_report/src/reports/models/export_models.dart';
import 'package:mpesa_report/src/reports/models/transaction_model.dart';


class TransactionModule<T extends TransactionModel> {
  List<T> transactions = [];

  double get totalCost => transactions.totalCost;
  double get totalAmount => transactions.totalAmount;

  

  void process(String _body, {bool loanPay = true, bool savingsIn = true}){
    if(T == BillsModel){
      transactions.add(BillsModel.fromMessageString(_body) as T);
    }else if(T == GoodsServicesModel){
      transactions.add(GoodsServicesModel.fromMessageString(_body) as T);
    }else if(T == LoanModel){
      transactions.add(LoanModel.fromMessageString(_body, loanPay) as T);
    }else if(T == ReceivedModel){
      transactions.add(ReceivedModel.fromMessageString(_body) as T);
    }else if(T == ReversalModel){
      transactions.add(ReversalModel.fromMessageString(_body) as T);
    }else if(T == SavingsModel){
      transactions.add(SavingsModel.fromMessageString(_body, savingsIn) as T);
    }else if(T == SentModel){
      transactions.add(SentModel.fromMessageString(_body) as T);
    }else if(T == WithdrawModel){
      transactions.add(WithdrawModel.fromMessageString(_body) as T);
    }else if(T == DepositModel){
      transactions.add(DepositModel.fromMessageString(_body) as T);
    }
  }
}
