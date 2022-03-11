import 'package:flutter/material.dart';
import 'package:mpesa_report/modules/mpesa_report_module.dart';

void main() {
  runApp(const MaterialApp(
    home: SmsReport(),
  ));
}

class SmsReport extends StatefulWidget {

  const SmsReport({Key? key}) : super(key: key); 

  @override
  State<SmsReport> createState() => _SmsReportState();
}

class _SmsReportState extends State<SmsReport> {
  // final MpesaReportModule mpesaReportModule = MpesaReportModule();

  @override
  void initState() {
    super.initState();
    // mpesaReportModule.groupTransactions();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      
    );
  }
}
