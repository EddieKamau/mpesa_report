import 'dart:math';

import 'package:mpesa_report/models/export_models.dart';
import 'package:sms_advanced/sms_advanced.dart';

class MpesaReportModule{
  SmsQuery smsQuery = SmsQuery();

  RecordsModel recordsModel = RecordsModel();
  

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
    
    for (var message in _messages) {


      String _body = message.body ?? '';
      

      if(_body.contains('Failed.') || _body.contains('[') || _body.contains('failed,')){
        continue;
      }


      if(_body.contains('for account') || _body.contains('airtime')){ // bills / airtime
        recordsModel.billsTransactionModule.process(_body);

      }else if(_body.contains('repaid')){ // loan pay
        recordsModel.mshwariLoansTransactionModule.process(_body, loanPay: true);

      }else if(_body.contains('loan has been approved')){ // get loan
        recordsModel.mshwariLoansTransactionModule.process(_body, loanPay: false);

      } else if(_body.contains('paid')){ // buy goods
        recordsModel.goodsServicesTransactionModule.process(_body);

      } else if(_body.contains('have received')){ //recieved
        recordsModel.receivedTransactionModule.process(_body);

      } else if(_body.contains('sent')){ // sent
        recordsModel.sentTransactionModule.process(_body);
        
      } else if(_body.contains('transferred')){ // savings
        if(_body.contains('from')){
          recordsModel.savingsTransactionModule.process(_body, savingsIn: false);

        } else {
          recordsModel.savingsTransactionModule.process(_body, savingsIn: true);

        }
        
      } else if(_body.contains('Reversal')){ // reversal
        recordsModel.reversalTransactionModule.process(_body);

      } else if(_body.contains('Withdraw')){ // withdraw
        recordsModel.withdrawTransactionModule.process(_body);

      } else if(_body.contains('Withdraw')){ // TODO deposit
        recordsModel.withdrawTransactionModule.process(_body);
      }

    }

    
  }



}
enum MpesaTransactionType{
  send, receive, 
  withdraw, deposit,
  paybill, buyGoods,
  savings, loans
}
