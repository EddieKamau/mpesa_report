import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:mpesa_report/src/transactions/models/option_model.dart';
import 'package:mpesa_report/src/transactions/modules/transaction_item_module.dart';

import '../modules/transact_module.dart';

class TransactionInputsWidget extends StatefulWidget {
  const TransactionInputsWidget(this.option, {this.inputValues = const [], this.itemLabel = '', Key? key}) : super(key: key);
  final OptionModel option;
  final List<String> inputValues;
  final String itemLabel;

  @override
  State<TransactionInputsWidget> createState() => _TransactionInputsWidgetState();
}

class _TransactionInputsWidgetState extends State<TransactionInputsWidget> {
  TransactionItemModule transactionItemModule = TransactionItemModule(); 

  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  List<int> inputsIndexes = [];
  AutovalidateMode? autovalidateMode;
  List<String> inputValues = [];
  List<int> inputItemIndexes = [];

  @override
  void initState() {
    super.initState();
    inputValues = widget.inputValues;
    for(var i = 0; i< widget.option.inputs.length; i++){
      if(widget.option.inputs[i].type != OptionInputType.fixed){
        inputsIndexes.add(i);
      }

      // values that are saved
      if(widget.option.inputs[i].type == OptionInputType.numberValue || widget.option.inputs[i].type == OptionInputType.value || widget.option.inputs[i].type == OptionInputType.phone){
        inputItemIndexes.add(i);
      }
      
    }
    _controllers = List.generate(inputsIndexes.length, (index) => TextEditingController());

    for(int i= 0; i< inputValues.length; i++){
      if(_controllers.length >= i+1){
        _controllers[i].text = widget.inputValues[i];
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    for(var c in _controllers){
      c.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant TransactionInputsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      inputValues = widget.inputValues;
      for(int i= 0; i< inputValues.length; i++){
        if(_controllers.length >= i+1){
          _controllers[i].text = widget.inputValues[i];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // inputs
              for(int i=0; i<inputsIndexes.length; i++)
                _InputField(controller: _controllers[i], input: widget.option.inputs[inputsIndexes[i]],),
              
              // actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    }, 
                    child: const Text('back')
                  ),
        
                  ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState?.validate() == true){
                        OptionModel _opt = widget.option;
                        for (var index in inputsIndexes) {
                          _opt.inputs[index].value = _controllers[inputsIndexes.indexOf(index)].text;
                        }

                        await TransactModule.transact(
                          transactionItemModel: TransactionItemModel(
                              itemKey: widget.option.key, 
                              label: widget.itemLabel, // TODO: person name 
                              inputs: inputItemIndexes.map((i) => TransactionIputItem(
                                label: widget.option.inputs[i].key ?? '',
                                value: _controllers[inputsIndexes.indexOf(i)].text
                              )).toList()
                            ), 
                          optionModel: _opt
                        );

                        if(mounted) Navigator.of(context).pop();

                        

                      }else{
                        setState(() {
                          autovalidateMode = AutovalidateMode.onUserInteraction;
                        });
                      }
                    }, 
                    child: const Text('Transact')
                  )
                ],
              )
        
            ],
          ),
        ),
      );
  }
}

class _InputField extends StatefulWidget {
  const _InputField({required this.controller, required this.input, Key? key}) : super(key: key);
  final OptionInput input;
  final TextEditingController controller;

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.only(top: 3, bottom: widget.input.maxLength > 0 ? 3 : 17),
      child: TextFormField(
        validator: (val){
          return (val?.length ?? 0) < widget.input.minLength ? 'Minimum character length is ${widget.input.minLength}' : null;
        },
        controller: widget.controller,
        obscureText: widget.input.type == OptionInputType.pin,
        keyboardType: widget.input.type.textInputType,
        textInputAction: widget.input.type == OptionInputType.pin ? TextInputAction.done : TextInputAction.next,
        maxLength: widget.input.maxLength <= 0 ? null : widget.input.maxLength,
        inputFormatters: [
          if(widget.input.type == OptionInputType.pin) FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*')),
          // if(input.type == OptionInputType.phone) FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*')),
          if(widget.input.type == OptionInputType.number) FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))
        ],
        decoration: InputDecoration(
          labelText: widget.input.label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffixIcon: widget.input.type == OptionInputType.phone ? 
          IconButton(
            onPressed: () async {
              // get contacts
              if(kIsWeb){
                if(FlutterContactPicker.available){
                  FlutterContactPicker.pickPhoneContact();
                }
              }else{
                var contact = await FlutterContactPicker.pickPhoneContact();
                if(contact.phoneNumber?.number != null){
                  widget.controller.text = contact.phoneNumber!.number!;
                }
                
                print(contact.fullName);
              }
            }, 
            icon: const Icon(Icons.arrow_drop_down)
          )
            : null
        ),
      ),
    );
  }
}