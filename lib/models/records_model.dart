import 'package:mpesa_report/modules/export_modules.dart';

class RecordsModel{
  RecordsModel(){
    billsModule = BillsModule();
    goodsServicesModule = GoodsServicesModule();
    mshwariLoansModule = MshwariLoansModule();
    receivedModule = ReceivedModule();
    reversalModule = ReversalModule();
    savingsModule = SavingsModule();
    sentModule = SentModule();
    withdrawModule = WithdrawModule();
    
  }

  late BillsModule billsModule;
  late GoodsServicesModule goodsServicesModule;
  late MshwariLoansModule mshwariLoansModule;
  late ReceivedModule receivedModule;
  late ReversalModule reversalModule;
  late SavingsModule savingsModule;
  late SentModule sentModule;
  late WithdrawModule withdrawModule;

  double get totalCost{
    double _cost = billsModule.billsTransactionsModel.totalCost +
                  sentModule.sentTransactionsModel.totalCost +
                  withdrawModule.withdrawTransactionsModel.totalCost;

    return _cost;
  }

  double get totalOut{
    double _out = billsModule.billsTransactionsModel.totalAmount +
                  goodsServicesModule.goodsServicesTransactionsModel.totalAmount +
                  sentModule.sentTransactionsModel.totalAmount +
                  withdrawModule.withdrawTransactionsModel.totalAmount;

    return _out;
  }

  double get totalIn{
    double _in = sentModule.sentTransactionsModel.totalAmount +
                reversalModule.reversalTransactionsModel.totalAmount;

    return _in;
  }



}