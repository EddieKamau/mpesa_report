import 'package:flutter/material.dart';

class UssdDialogWidget extends StatefulWidget {
  const UssdDialogWidget({required this.data, required this.onSend, required this.onCancel, Key? key}) : super(key: key);
  final String data;
  final Function(String val) onSend;
  final Function() onCancel;

  @override
  State<UssdDialogWidget> createState() => _UssdWidgetState();
}

class _UssdWidgetState extends State<UssdDialogWidget> {
  TextEditingController? _controller;
  final String? title = 'Select one below';
  String data = '';

  Map<String, String>? options;

  bool hasInput = false;
  bool hasBack = false;
  String? backValue;

  void getValues(){
    String seperator = ' ';
  
    var ops = data.split('\n');
    ops.removeLast();
    
    options = {};
    
    hasInput = data.toLowerCase().contains('enter');
    
    
    for(var op in ops){
      var _res = op.split(seperator);
      var key = _res.first;
      var value = _res.length == 2 ? _res[1] : _res.length == 1 ? _res[0] : _res.sublist(1).join(seperator);
      options?.addAll({key: value});
      
      if(op.toLowerCase().contains('back')){
        hasBack = true;
        backValue = key;
      }
      
    }
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
      getValues();
      if(hasInput){
        _controller = TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UssdDialogWidget oldWidget) {
    setState(() {
      data = widget.data;
      getValues();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            if(title != null && title != '') Center(child: Text(title!, style: const TextStyle(fontSize: 16),)),
    
            // Options
            if(options != null)for(var optionKey in options!.keys)
              InkWell(
                onTap: (){
                  // send optionKey
                   widget.onSend(optionKey);
                },
                child: Card(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    margin: const EdgeInsets.symmetric(vertical: 1,),
                    child: Text(options![optionKey]!)
                  ),
                ),
              ),
    
            // input
            if(hasInput) Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.grey)
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            // actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // cancel
                TextButton(
                  onPressed: (){
                    // cancel ussd and overlay
                    widget.onCancel.call();

                  }, 
                  child: const Text('Cancel')
                ),

                // send
                if(hasInput) ElevatedButton(
                  onPressed: (){
                    // send input
                    widget.onSend(_controller!.text);
                  }, 
                  child: const Text('Send')
                ),

                // back
                if(hasBack) TextButton(
                  onPressed: (){
                    // send input with back value
                    widget.onSend(backValue!);
                  }, 
                  child: const Text('Back')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}