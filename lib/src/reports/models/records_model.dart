import 'package:mpesa_report/src/reports/models/transaction_model.dart';
import 'package:mpesa_report/src/reports/modules/export_modules.dart';
import 'package:mpesa_report/src/reports/models/export_models.dart';

class RecordsModel{
  RecordsModel(){
    billsTransactionModule = TransactionModule();
    depositTransactionModule = TransactionModule();
    goodsServicesTransactionModule = TransactionModule();
    mshwariLoansTransactionModule = TransactionModule();
    receivedTransactionModule = TransactionModule();
    reversalTransactionModule = TransactionModule();
    savingsTransactionModule = TransactionModule();
    sentTransactionModule = TransactionModule();
    withdrawTransactionModule = TransactionModule();
    
  }

  late TransactionModule<BillsModel> billsTransactionModule;
  late TransactionModule<DepositModel> depositTransactionModule;
  late TransactionModule<GoodsServicesModel> goodsServicesTransactionModule;
  late TransactionModule<LoanModel> mshwariLoansTransactionModule;
  late TransactionModule<ReceivedModel> receivedTransactionModule;
  late TransactionModule<ReversalModel> reversalTransactionModule;
  late TransactionModule<SavingsModel> savingsTransactionModule;
  late TransactionModule<SentModel> sentTransactionModule;
  late TransactionModule<WithdrawModel> withdrawTransactionModule;

  double get totalCost{
    double _cost = billsTransactionModule.totalCost +
                  goodsServicesTransactionModule.totalCost +
                  mshwariLoansTransactionModule.totalCost +
                  sentTransactionModule.totalCost +
                  withdrawTransactionModule.totalCost;

    return _cost;
  }

  double get totalOut{
    double _out = billsTransactionModule.totalAmount +
                  goodsServicesTransactionModule.totalAmount +
                  sentTransactionModule.totalCost +
                  withdrawTransactionModule.totalCost;

    return _out;
  }

  double get totalIn{
    double _in = receivedTransactionModule.totalAmount +
                reversalTransactionModule.totalAmount;
                depositTransactionModule.totalAmount;

    return _in;

  }

  List<TransactionModel> allTransactions (){
    final List<TransactionModel> _t = [
      ...billsTransactionModule.transactions,
      ...depositTransactionModule.transactions,
      ...goodsServicesTransactionModule.transactions,
      ...mshwariLoansTransactionModule.transactions,
      ...receivedTransactionModule.transactions,
      ...reversalTransactionModule.transactions,
      ...savingsTransactionModule.transactions,
      ...sentTransactionModule.transactions,
      ...withdrawTransactionModule.transactions,
    ];

    _t.sort();

    return _t.reversed.toList();
  }

}