import 'package:sms_maintained/sms.dart';

class MpesaReportModule{
  SmsQuery smsQuery = SmsQuery();

  Future<List<SmsMessage>> fetchMpesaSms()async{

    final List<SmsMessage> messages = await smsQuery.querySms(
                                              address: 'MPESA'
    );
    print("******************");

    return messages;

  }



}