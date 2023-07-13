import 'package:flutter/material.dart';
import 'package:mpesa_report/src/transactions/models/option_model.dart';
import 'package:mpesa_report/src/transactions/pages/transaction_inputs_page.dart';
import 'package:mpesa_report/src/transactions/widgets/transaction_inputs_widget.dart';

class TransactItem extends StatelessWidget {
  const TransactItem({required this.option, this.shouldPop = false, this.parentLable, Key? key}) : super(key: key);
  final OptionModel option;
  final bool shouldPop;
  final String? parentLable;

  void onOptionSelect(BuildContext context, {required String label}){
    if(option.options.isEmpty && option.isTransaction){
      Navigator.push(context, MaterialPageRoute(builder: (_)=> TransactionInputsPage(option)));
    }else if(!option.isTransaction && option.options.isEmpty){
      // TransactionInputsWidget(widget.option)
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context, 
        isScrollControlled: true,
        builder: (modalContext){
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(modalContext).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              )
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, textAlign: TextAlign.center, style: const TextStyle(height: 1.4),),
                TransactionInputsWidget(option, key: ValueKey(option.key),),
              ],
            ),
          );
        }
      );
      // .then((value)=> {if(shouldPop) Navigator.of(context).popUntil(ModalRoute.withName('/'))});
    } else{
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context, 
        builder: (modalContext){
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(modalContext).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              )
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, textAlign: TextAlign.center, style: const TextStyle(height: 1.4),),
                Wrap(
                  runSpacing: 7,
                  spacing: 7,
                  alignment: WrapAlignment.center,
                  children: [
                    for(var option in option.options)
                        TransactItem(option: option, shouldPop: true, parentLable: label,),
                  ],
                ),
              ],
            ),
          );
        }
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(shouldPop) Navigator.of(context).pop();
        // if(shouldPop) Navigator.of(context).pop();
        onOptionSelect(context, label: parentLable == null ? option.label : '$parentLable\n${option.label}');
      },
      child: Card(
        child: Container(
          width: 85,
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flutter_dash_outlined, size: 36,),
                const SizedBox(height: 4,),
                Text(option.label, textAlign: TextAlign.center,),
                if(option.isService) const SizedBox(height: 2,),
                if(option.isService && option.options.isEmpty) Text(option.inputs[2].value ?? '', textAlign: TextAlign.center,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}