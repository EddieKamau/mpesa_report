import 'dart:math';

import 'package:mpesa_report/src/reports/models/export_models.dart';
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

  Future groupTransactions()async{
    final List<SmsMessage> _messages = await fetchMpesaSms();
    
    for (var message in _messages) {


      try {
        String _body = message.body ?? '';

        if(_body.contains('Failed.') || _body.contains('[') || _body.contains('failed,')){
          continue;
        }

        if(_body.contains('Give')){ // deposit
          recordsModel.depositTransactionModule.process(_body);
        }else if(_body.contains('for account') || _body.contains('airtime')){ // bills / airtime
          recordsModel.billsTransactionModule.process(_body);

        }else if(_body.contains('repaid') || _body.contains('repayment of')){ // loan pay
          recordsModel.mshwariLoansTransactionModule.process(_body, loanPay: true);

        }else if(_body.contains('loan has been approved')){ // get loan
          recordsModel.mshwariLoansTransactionModule.process(_body, loanPay: false);

        } else if(_body.contains('paid')){ // buy goods
          recordsModel.goodsServicesTransactionModule.process(_body);

        } else if(_body.contains('have received')){ //recieved
          recordsModel.receivedTransactionModule.process(_body);

        } else if(_body.contains('sent')){ // sent
          recordsModel.sentTransactionModule.process(_body);
          
        } else if(_body.contains('transferred')|| _body.contains('transfered')){ // savings
          if(_body.contains('from')){
            recordsModel.savingsTransactionModule.process(_body, savingsIn: false);

          } else {
            recordsModel.savingsTransactionModule.process(_body, savingsIn: true);

          }
          
        } else if(_body.contains('Reversal')){ // reversal
          recordsModel.reversalTransactionModule.process(_body);

        } else if(_body.contains('Withdraw')){ // withdraw
          recordsModel.withdrawTransactionModule.process(_body);

        }
      } catch (e) {
        continue;
      }

    }

    return;
    
  }


  
}

