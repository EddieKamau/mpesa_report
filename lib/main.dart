import 'package:flutter/material.dart';
import 'package:mpesa_report/modules/mpesa_report_module.dart';
import 'package:mpesa_report/transactions_page.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

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
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          UssdAdvanced.sendUssd(code: '*334#', subscriptionId: -1);
        },
        child: const Icon(Icons.send_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            runSpacing: 15,
            spacing: 15,
            children: [
              for(var i=0; i<6; i++)
                ItemCard(
                  i,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const TransactionsPage()));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class ItemCard extends StatelessWidget {
  const ItemCard(this.i, { this.onTap,  Key? key }) : super(key: key);
  final int i;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // count
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: const Text('27', style: TextStyle(color: Colors.white),),
                  ),
                ),

                // icon
                const Icon(Icons.radio, size: 55,),

                const SizedBox(height: 8,),

                // label
                Text('label $i', style: const TextStyle(fontSize: 17),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}