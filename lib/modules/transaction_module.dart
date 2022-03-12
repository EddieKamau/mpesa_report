import 'package:mpesa_report/models/export_models.dart';
import 'package:mpesa_report/models/transaction_model.dart';


class TransactionModule<T extends TransactionModel> {
  List<T> transactions = [];

  double get totalCost {
    double _cost = 0;
    for (var transaction in transactions) {
      _cost += transaction.cost ?? 0;
      
    }
    return _cost;
  }
  double get totalAmount {
    double _amount = 0;
    for (var transaction in transactions) {
      _amount += transaction.amount ?? 0;
      
    }
    return _amount;
  }

  void process(String _body, {bool loanPay = true, bool savingsIn = true}){
    if(T is BillsModel){
      transactions.add(BillsModel.fromMessageString(_body) as T);
    }else if(T is GoodsServicesModel){
      transactions.add(GoodsServicesModel.fromMessageString(_body) as T);
    }else if(T is LoanModel){
      transactions.add(LoanModel.fromMessageString(_body, loanPay) as T);
    }else if(T is ReceivedModel){
      transactions.add(ReceivedModel.fromMessageString(_body) as T);
    }else if(T is ReversalModel){
      transactions.add(ReversalModel.fromMessageString(_body) as T);
    }else if(T is SavingsModel){
      transactions.add(SavingsModel.fromMessageString(_body, savingsIn) as T);
    }else if(T is SentModel){
      transactions.add(SentModel.fromMessageString(_body) as T);
    }else if(T is WithdrawModel){
      transactions.add(WithdrawModel.fromMessageString(_body) as T);
    }
  }
}

// TODO: Deposit