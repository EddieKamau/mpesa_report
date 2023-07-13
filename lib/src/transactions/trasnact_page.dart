import 'package:flutter/material.dart';
import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mpesa_report/src/transactions/models/option_model.dart';
import 'package:mpesa_report/src/transactions/modules/transaction_item_module.dart';
import 'package:mpesa_report/src/transactions/widgets/transact_item.dart';

class TransactPage extends StatefulWidget {
  const TransactPage({Key? key}) : super(key: key);

  @override
  State<TransactPage> createState() => _TransactPageState();
}

class _TransactPageState extends State<TransactPage> {
  final TransactionItemModule transactionItemModule = TransactionItemModule();

  @override
  void initState() {
    super.initState();
    Hive.initFlutter().then((value) => transactionItemModule.connectTransactionItemModel());
  }

  @override
  void dispose() {
    super.dispose();
    FlutterOverlayApps.closeOverlay();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // commonly used
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Friquents', style: Theme.of(context).textTheme.titleLarge,),
                ),
              ),
        
              Wrap(
                runSpacing: 4,
                spacing: 4,
                children: [
                  for(var option in friquents)
                    TransactItem(option: option,),
                  
                  InkWell(
                    onTap: () async {
                      await FlutterOverlayApps.showOverlay(
                        height: 300,
                        // width: (MediaQuery.of(context).size.width *.98).floor(),
                        closeOnBackButton: false,
                        alignment: OverlayAlignment.center);
                    },
                    child: Card(
                      child: Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(8.0),
                        child: const Column(
                          children: [
                            Icon(Icons.menu, size: 36,),
                            SizedBox(height: 4,),
                            Text('Menu')
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
        
              const SizedBox(height: 20,),
              // services
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Services', style: Theme.of(context).textTheme.titleLarge,),
                ),
              ),
        
              Wrap(
                runSpacing: 4,
                spacing: 4,
                children: [
                  for(var s in services)
                    TransactItem(option: s),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}