import 'package:flutter/material.dart';
import 'package:mpesa_report/modules/mpesa_report_module.dart';

void main() {
  runApp(MaterialApp(
    home: SmsReport(),
  ));
}

class SmsReport extends StatelessWidget {
  final MpesaReportModule mpesaReportModule = MpesaReportModule(); 

  @override
  Widget build(BuildContext context) {
    print(mpesaReportModule.fetchMpesaSms());
    return Container(
      
    );
  }
}
