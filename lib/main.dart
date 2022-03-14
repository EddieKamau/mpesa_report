import 'package:flutter/material.dart';
import 'package:mpesa_report/models/transaction_model.dart';
import 'package:mpesa_report/modules/mpesa_report_module.dart';
import 'package:mpesa_report/reports_page.dart';
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
  List<ReportItem> _reportItems = [];

  ItemModel _all = ItemModel(label: 'All', transactions: [], iconData: Icons.all_inbox_outlined);

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
        _all = ItemModel(label: 'All', transactions: mpesaReportModule.recordsModel.allTransactions(), iconData: Icons.all_inbox_outlined);

        _items = [
          ItemModel(label: 'Withdraw', transactions: mpesaReportModule.recordsModel.withdrawTransactionModule.transactions, iconData: Icons.outbond_outlined),
          ItemModel(label: 'Deposit', transactions: mpesaReportModule.recordsModel.depositTransactionModule.transactions, iconData: Icons.inbox_outlined),
          ItemModel(label: 'Sent', transactions: mpesaReportModule.recordsModel.sentTransactionModule.transactions, iconData: Icons.send_to_mobile),
          ItemModel(label: 'Received', transactions: mpesaReportModule.recordsModel.receivedTransactionModule.transactions, iconData: Icons.call_received),
          ItemModel(label: 'Pay bills', transactions: mpesaReportModule.recordsModel.billsTransactionModule.transactions, iconData: Icons.receipt_long),
          ItemModel(label: 'Buy goods', transactions: mpesaReportModule.recordsModel.goodsServicesTransactionModule.transactions, iconData: Icons.shopping_cart_outlined),
          ItemModel(label: 'Savings', transactions: mpesaReportModule.recordsModel.savingsTransactionModule.transactions, iconData: Icons.savings_outlined),
          ItemModel(label: 'Loans', transactions: mpesaReportModule.recordsModel.mshwariLoansTransactionModule.transactions, iconData: Icons.money_outlined),
          ItemModel(label: 'Reversal', transactions: mpesaReportModule.recordsModel.reversalTransactionModule.transactions, iconData: Icons.restart_alt),
        ];

        _reportItems = [
          ReportItem(label: 'Withdraw', value: mpesaReportModule.recordsModel.withdrawTransactionModule.totalAmount, color: Colors.orangeAccent),
          ReportItem(label: 'Deposit', value: mpesaReportModule.recordsModel.depositTransactionModule.transactions.totalAmount, color: Colors.purpleAccent),
          ReportItem(label: 'Sent', value: mpesaReportModule.recordsModel.sentTransactionModule.transactions.totalAmount, color: Colors.redAccent),
          ReportItem(label: 'Received', value: mpesaReportModule.recordsModel.receivedTransactionModule.transactions.totalAmount, color: Colors.green),
          ReportItem(label: 'Pay bills', value: mpesaReportModule.recordsModel.billsTransactionModule.transactions.totalAmount, color: Colors.limeAccent),
          ReportItem(label: 'Buy goods', value: mpesaReportModule.recordsModel.goodsServicesTransactionModule.transactions.totalAmount, color: Colors.blue),
          ReportItem(label: 'Savings', value: mpesaReportModule.recordsModel.savingsTransactionModule.transactions.totalAmount, color: Colors.blueGrey),
          ReportItem(label: 'Loans', value: mpesaReportModule.recordsModel.mshwariLoansTransactionModule.transactions.totalAmount, color: Colors.black),
          ReportItem(label: 'Reversal', value: mpesaReportModule.recordsModel.reversalTransactionModule.transactions.totalAmount, color: Colors.brown),
        ];

        _reportItems.retainWhere((element) => element.value > 0);
      });
    });
  }

  void filterReportsByDate(DateTimeRange dateTimeRange){
      setState(() {
        _reportItems = [
          ReportItem(label: 'Withdraw', value: mpesaReportModule.recordsModel.withdrawTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.orangeAccent),
          ReportItem(label: 'Deposit', value: mpesaReportModule.recordsModel.depositTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.purpleAccent),
          ReportItem(label: 'Sent', value: mpesaReportModule.recordsModel.sentTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.redAccent),
          ReportItem(label: 'Received', value: mpesaReportModule.recordsModel.receivedTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.green),
          ReportItem(label: 'Pay bills', value: mpesaReportModule.recordsModel.billsTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.limeAccent),
          ReportItem(label: 'Buy goods', value: mpesaReportModule.recordsModel.goodsServicesTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.blue),
          ReportItem(label: 'Savings', value: mpesaReportModule.recordsModel.savingsTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.blueGrey),
          ReportItem(label: 'Loans', value: mpesaReportModule.recordsModel.mshwariLoansTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.black),
          ReportItem(label: 'Reversal', value: mpesaReportModule.recordsModel.reversalTransactionModule.transactions.dateFilter(dateTimeRange).totalAmount, color: Colors.brown),
        ];

        _reportItems.retainWhere((element) => element.value > 0);
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
      home: Builder(
        builder: (context) {
          return Scaffold(
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Wrap(
                          runSpacing: 5,
                          spacing: 5,
                          runAlignment: WrapAlignment.spaceEvenly,
                          children: [
                            // chart
                            ChartCard(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_)=> ReportsPage(
                                    _reportItems,
                                    onDateFilter: filterReportsByDate
                                  )
                                ));
                              },
                            ),

                            // all transactions
                            ItemCard(
                                'All',
                                mpesaReportModule.recordsModel.allTransactions().length,
                                iconData: _all.iconData,
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(_all, isAll: true,)));
                                },
                              ),
                            for(var _item in _items)
                              if(_item.transactions.isNotEmpty) ItemCard(
                                _item.label,
                                _item.transactions.length,
                                iconData: _item.iconData,
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(_item)));
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
  const ItemCard(this.label, this.count, {required this.iconData, this.onTap,  Key? key }) : super(key: key);
  final String label;
  final int count;
  final IconData iconData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 140,
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
                Icon(iconData, size: 40,),

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

class ChartCard extends StatelessWidget {
  const ChartCard({this.onTap, Key? key }) : super(key: key);
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: const [

                // icon
                Icon(Icons.bar_chart, size: 50,),

                SizedBox(height: 8,),

                // label
                Text('Reports', style: TextStyle(fontSize: 17),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  ItemModel({required this.label, required this.transactions, required this.iconData});
  String label;
  IconData iconData;
  List<TransactionModel> transactions;
}