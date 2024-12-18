import 'package:flutter/material.dart';
import 'package:mpesa_report/src/reports/pages/sms_reports_page.dart';
import 'package:mpesa_report/theming_controller.dart';

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



class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> with SingleTickerProviderStateMixin{
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


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() :  ThemeData(primarySwatch: _primarySatch),
      // home: const SmsReport() const TransactPage()
      home: const Scaffold(
        body: SmsReport(),
      )
    );
  }
}