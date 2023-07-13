
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mpesa_report/src/reports/models/transaction_model.dart';
import 'package:mpesa_report/src/reports/modules/mpesa_report_module.dart';
import 'package:mpesa_report/src/reports/pages/reports_page.dart';
import 'package:mpesa_report/src/reports/pages/transactions_page.dart';
import 'package:mpesa_report/theming_controller.dart';

class SmsReport extends StatefulWidget {

  const SmsReport({Key? key}) : super(key: key); 

  @override
  State<SmsReport> createState() => _SmsReportState();
}

class _SmsReportState extends State<SmsReport> {
  final MpesaReportModule mpesaReportModule = MpesaReportModule();
  final ThemingController themingController = ThemingController();
  
  late bool _isDarkTheme;

  final List<ItemModel> _items = [];

  ItemModel _all = ItemModel(label: 'All', transactions: [], iconData: Icons.all_inbox_outlined);

  List<List<TransactionModel>> _list = [];

  final List<String> _labels = [
      'Withdraw', 'Deposit', 'Sent', 'Received', 'Pay bills', 'Buy goods', 'Savings', 'Loans', 'Reversal'
    ];

    final List<IconData> _icons = [
      Icons.outbond_outlined, Icons.inbox_outlined, Icons.send_to_mobile, Icons.call_received, Icons.receipt_long, 
      Icons.shopping_cart_outlined, Icons.savings_outlined, Icons.money_outlined, Icons.restart_alt
    ];

    final List<Color> _colors = [
      Colors.orangeAccent, Colors.purpleAccent, Colors.redAccent, Colors.green, Colors.limeAccent, Colors.blue, Colors.blueGrey, Colors.black, Colors.brown
    ];

  @override
  void initState() {
    super.initState();
    
    _isDarkTheme = themingController.isDarkTheme;

    mpesaReportModule.groupTransactions().then((value){
      setState(() {
        _all = ItemModel(label: 'All', transactions: mpesaReportModule.recordsModel.allTransactions(), iconData: Icons.all_inbox_outlined);

        _list = [
          mpesaReportModule.recordsModel.withdrawTransactionModule.transactions, // Withdraw
          mpesaReportModule.recordsModel.depositTransactionModule.transactions, // Deposit
          mpesaReportModule.recordsModel.sentTransactionModule.transactions, // Sent
          mpesaReportModule.recordsModel.receivedTransactionModule.transactions, // Received
          mpesaReportModule.recordsModel.billsTransactionModule.transactions, // Pay bills
          mpesaReportModule.recordsModel.goodsServicesTransactionModule.transactions, // Buy goods
          mpesaReportModule.recordsModel.savingsTransactionModule.transactions, // Savings
          mpesaReportModule.recordsModel.mshwariLoansTransactionModule.transactions, // Loans
          mpesaReportModule.recordsModel.reversalTransactionModule.transactions, // Reversal
        ];

        
        for(int i=0; i< _list.length; i++){
          _items.add(ItemModel(label: _labels[i], transactions: _list[i], iconData: _icons[i]));
        }
        
      });
    });

    // FlutterOverlayApps.overlayListener().listen((event) {
    //   var _message = OverlayMessage.fromMap(event);
    //   if(_message.type == OverlayMessageType.message){
    //     UssdAdvanced.sendMessage(_message.message.toString()).then((value) => FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: value).asMap()));
    //   }else{
    //     UssdAdvanced.cancelSession();
    //   }
    // });

    

  }

  @override
  void dispose() {
    themingController.removeListener(() { });
    // FlutterOverlayApps.disposeOverlayListener();
    // FlutterOverlayApps.closeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    
    return Builder(
      builder: (context) {
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {

          //     var res = await UssdAdvanced.multisessionUssd(code: "*544#", subscriptionId: -1);
          //     UssdAdvanced.onEnd().listen((event) {
          //       FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(type: OverlayMessageType.close).asMap());
          //       UssdAdvanced.cancelSession();
          //     });

          //     await FlutterOverlayApps.showOverlay(
          //         // height: 600,
          //         // width: (MediaQuery.of(context).size.width *.98).floor(),
          //         alignment: OverlayAlignment.center);
                
              
              
          //     FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: res).asMap());

          //     // showDialog(
          //     //   context: context, 
          //     //   builder: (_)=> GestureDetector(
          //     //     child: const Scaffold(
          //     //       body: Dialog(
          //     //         child: UssdWidget(''),
          //     //       ),
          //     //     ),
          //     //   )
          //     // );
          //   },
          //   child: const Icon(Icons.send_outlined),
          // ),
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
                                  transactions: _list,
                                  labels: _labels,
                                  colors: _colors,
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(transactions: _all.transactions, label: _all.label, isAll: true,)));
                              },
                            ),
                          for(var _item in _items)
                            if(_item.transactions.isNotEmpty) ItemCard(
                              _item.label,
                              _item.transactions.length,
                              iconData: _item.iconData,
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(transactions: _item.transactions, label: _item.label,)));
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
      child: const SizedBox(
        width: 140,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [

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