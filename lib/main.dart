import 'package:flutter/material.dart';
import 'package:mpesa_report/models/transaction_model.dart';
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
  final MpesaReportModule mpesaReportModule = MpesaReportModule();

  List<ItemModel> _items = [];

  ItemModel _all = ItemModel(label: 'All', transactions: []);

  @override
  void initState() {
    super.initState();
    mpesaReportModule.groupTransactions().then((value){
      setState(() {
        _all = ItemModel(label: 'All', transactions: mpesaReportModule.recordsModel.allTransactions());

        _items = [
          ItemModel(label: 'Withdraw', transactions: mpesaReportModule.recordsModel.withdrawTransactionModule.transactions),
          ItemModel(label: 'Sent', transactions: mpesaReportModule.recordsModel.sentTransactionModule.transactions),
          ItemModel(label: 'Received', transactions: mpesaReportModule.recordsModel.receivedTransactionModule.transactions),
          ItemModel(label: 'Pay bills', transactions: mpesaReportModule.recordsModel.billsTransactionModule.transactions),
          ItemModel(label: 'Buy goods', transactions: mpesaReportModule.recordsModel.goodsServicesTransactionModule.transactions),
          ItemModel(label: 'Savings', transactions: mpesaReportModule.recordsModel.savingsTransactionModule.transactions),
          ItemModel(label: 'Loans', transactions: mpesaReportModule.recordsModel.mshwariLoansTransactionModule.transactions),
          ItemModel(label: 'Reversal', transactions: mpesaReportModule.recordsModel.reversalTransactionModule.transactions),
        ];
      });
    });
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
              ItemCard(
                  'All',
                  mpesaReportModule.recordsModel.allTransactions().length,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(_all, isAll: true,)));
                  },
                ),
              for(var _item in _items)
                ItemCard(
                  _item.label,
                  _item.transactions.length,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(_item)));
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
  const ItemCard(this.label, this.count, { this.onTap,  Key? key }) : super(key: key);
  final String label;
  final int count;
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
                    child: Text(count.toString(), style: const TextStyle(color: Colors.white),),
                  ),
                ),

                // icon
                const Icon(Icons.radio, size: 55,),

                const SizedBox(height: 8,),

                // label
                Text(label, style: const TextStyle(fontSize: 17),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  ItemModel({required this.label, required this.transactions});
  String label;
  List<TransactionModel> transactions;
}