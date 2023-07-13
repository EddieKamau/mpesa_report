import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mpesa_report/src/reports/pages/sms_reports_page.dart';
import 'package:mpesa_report/src/transactions/modules/transaction_item_module.dart';
import 'package:mpesa_report/src/transactions/trasnact_page.dart';
import 'package:mpesa_report/theming_controller.dart';
import 'package:mpesa_report/ussd_overlay.dart';

var _primarySatch = const MaterialColor(
    0xFF1B5E20,
    <int, Color>{
       50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF206F40),
      500: Color(0xFF1B5E20),
      600: Color(0xFF17502E),
      700: Color(0xFF15492A),
      800: Color(0xFF0F311C),
      900: Color(0xFF0A1F12),
    },
  );

void main() {
  runApp(const EntryPage());
}

// overlay entry point
@pragma("vm:entry-point")
void showOverlay() {
  WidgetsFlutterBinding.ensureInitialized();
  final ThemingController themingController = ThemingController();
  runApp(MaterialApp(
    theme: themingController.isDarkTheme ? ThemeData.dark() : ThemeData(primarySwatch: _primarySatch),
    debugShowCheckedModeBanner: false,
    home: const USSDOverlay()
  ));
}

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> with SingleTickerProviderStateMixin{
  final TransactionItemModule transactionItemModule = TransactionItemModule();
  late final TabController tabController;
  int _currentTabIndex = 0;
  final ThemingController themingController = ThemingController();
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = themingController.isDarkTheme;
    themingController.addListener(() {
      setState(() {
        _isDarkTheme = themingController.isDarkTheme;
      });
    });

    tabController = TabController(length: 2, vsync: this, initialIndex: _currentTabIndex);
    tabController.addListener(() {
      setState(() {
        _currentTabIndex = tabController.index;
      });
    });

    Hive.initFlutter().then((value) => transactionItemModule.connectTransactionItemModel());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() :  ThemeData(primarySwatch: _primarySatch),
      // home: const SmsReport() const TransactPage()
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index){
            tabController.index = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.send_outlined,),label: 'Transact',),

            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          ]
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            TransactPage(),
            SmsReport(),
          ]
        ),
      )
    );
  }
}