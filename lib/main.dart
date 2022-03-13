import 'package:flutter/material.dart';
import 'package:mpesa_report/models/transaction_model.dart';
import 'package:mpesa_report/modules/mpesa_report_module.dart';
import 'package:mpesa_report/theming_controller.dart';
import 'package:mpesa_report/transactions_page.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:flutter_switch/flutter_switch.dart';

void main() {
  runApp(const SmsReport());
}

class SmsReport extends StatefulWidget {

  const SmsReport({Key? key}) : super(key: key); 

  @override
  State<SmsReport> createState() => _SmsReportState();
}

class _SmsReportState extends State<SmsReport> {
  final MpesaReportModule mpesaReportModule = MpesaReportModule();
  final ThemingController themingController = ThemingController();
  
  bool _isDarkTheme = false;

  List<ItemModel> _items = [];

  ItemModel _all = ItemModel(label: 'All', transactions: []);

  @override
  void initState() {
    super.initState();
    
    _isDarkTheme = themingController.isDarkTheme;
    themingController.addListener(() {
      setState(() {
        _isDarkTheme = themingController.isDarkTheme;
      });
    });

    mpesaReportModule.groupTransactions().then((value){
      setState(() {
        _all = ItemModel(label: 'All', transactions: mpesaReportModule.recordsModel.allTransactions());

        _items = [
          ItemModel(label: 'Withdraw', transactions: mpesaReportModule.recordsModel.withdrawTransactionModule.transactions),
          ItemModel(label: 'Deposit', transactions: mpesaReportModule.recordsModel.depositTransactionModule.transactions),
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
  void dispose() {
    themingController.removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() :  null,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            UssdAdvanced.sendUssd(code: '*334#', subscriptionId: -1);
          },
          child: const Icon(Icons.send_outlined),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              // toggle theme
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _themeSwitch,
                    ],
                  ),
                ),
              ),

              // body
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    runAlignment: WrapAlignment.spaceEvenly,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget get _themeSwitch => FlutterSwitch(
        width: 65.0,
        height: 35.0,
        toggleSize: 35.0,
        value: _isDarkTheme,
        borderRadius: 30.0,
        padding: 2.0,
        activeToggleColor: const Color(0xFF6E40C9),
        inactiveToggleColor: const Color(0xFF2F363D),
        activeSwitchBorder: Border.all(
          color: const Color(0xFF3C1E70),
          width: 6.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: const Color(0xFFD1D5DA),
          width: 1.0,
        ),
        activeColor: const Color(0xFF271052),
        inactiveColor: Colors.white,
        activeIcon: const Icon(
          Icons.nightlight_round,
          color: Color(0xFFF8E3A1),
        ),
        inactiveIcon: const Icon(
          Icons.wb_sunny,
          color: Color(0xFFFFDF5D),
        ),
        onToggle: (val) {
          setState(() {
            themingController.changeTheme(val);
            _isDarkTheme = val;
          });
        },
      ); 
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
                const Icon(Icons.radio, size: 40,),

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