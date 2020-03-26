import 'dart:math';

import 'package:mpesa_report/models/export_models.dart';
import 'package:sms_maintained/sms.dart';

class MpesaReportModule{
  SmsQuery smsQuery = SmsQuery();
  double cost;

  RecordsModel recordsModel = RecordsModel();
  

  set setCost(double _amount){
    cost = _amount;
  }

  Future<List<SmsMessage>> fetchMpesaSms()async{

    final List<SmsMessage> _messages = await smsQuery.querySms(
        address: 'MPESA'
    );
    return _messages;

  }

  double amoutFormater(String _value){
    List _amountRaw = _value.split(',');
    double _amount = 0;
    for(int i = _amountRaw.length-1; i >= 0; i--){
      _amount += pow(1000, i) * double.parse(_amountRaw[(_amountRaw.length-1) - i]);
    }
    return _amount;
  }

  void groupTransactions()async{
    final List<SmsMessage> _messages = await fetchMpesaSms();
    
    _messages.forEach((message) {


      String _body = message.body;
      

      if(_body.contains('Failed.') || _body.contains('[') || _body.contains('failed,')){
        return null;
      }

      // Extract type (bills, goods, received, savings, sent, withdraw)
      if(_body.contains('for account') || _body.contains('airtime')){
        recordsModel.billsModule.process(_body);

      }else if(_body.contains('repaid')){
        recordsModel.mshwariLoansModule.process(_body, true);

      }else if(_body.contains('loan has been approved')){
        recordsModel.mshwariLoansModule.process(_body, false);
      } else if(_body.contains('paid')){
        recordsModel.goodsServicesModule.process(_body);

      } else if(_body.contains('have received')){
        recordsModel.receivedModule.process(_body);

      } else if(_body.contains('sent')){
        recordsModel.sentModule.process(_body);
        
      } else if(_body.contains('transferred')){
        if(_body.contains('from')){
          recordsModel.savingsModule.process(_body, false);

        } else {
          recordsModel.savingsModule.process(_body, true);

        }
        
      } else if(_body.contains('Reversal')){
        recordsModel.reversalModule.process(_body);
      } else if(_body.contains('Withdraw')){
        recordsModel.withdrawModule.process(_body);
      }

      


    });


    print('Total bills\t\t:${recordsModel.billsModule.billsTransactionsModel.totalAmount}');
    print('No. bills\t\t:${recordsModel.billsModule.billsTransactionsModel.transactions.length}');
    print('Total goods/S\t:${recordsModel.goodsServicesModule.goodsServicesTransactionsModel.totalAmount}');
    print('No. goods/S\t\t:${recordsModel.goodsServicesModule.goodsServicesTransactionsModel.transactions.length}');
    print('Total sent\t\t:${recordsModel.sentModule.sentTransactionsModel.totalAmount}');
    print('No. sent\t\t:${recordsModel.sentModule.sentTransactionsModel.transactions.length}');
    print('Total received\t:${recordsModel.receivedModule.receivedTransactionsModel.totalAmount}');
    print('No. received\t\t:${recordsModel.receivedModule.receivedTransactionsModel.transactions.length}');
    print("_______________________________________");
    print('Total in\t\t:${recordsModel.totalIn}');
    print('Total out\t\t:${recordsModel.totalOut}');
    print('Total cost\t\t:${recordsModel.totalCost}');
    
  }



}

