import 'package:flutter/material.dart';

class UssdConfirmationWidget extends StatefulWidget {
  const UssdConfirmationWidget({required this.data, required this.onSend, Key? key}) : super(key: key);
  final String data;
  final Function(String val) onSend;

  @override
  State<UssdConfirmationWidget> createState() => _UssdWidgetState();
}

class _UssdWidgetState extends State<UssdConfirmationWidget> {
  String data = '';
  String title = '';

  // Map<String, String>? options;


  void getValues(){
  
    var ops = data.split('\n');
    title = ops.length >= 3 ? ops.sublist(0, 2).join('\n') : ops.join('\n');
    
    
    
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
      getValues();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UssdConfirmationWidget oldWidget) {
    setState(() {
      data = widget.data;
      getValues();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            if(title != '') Center(child: Text(title, style: const TextStyle(fontSize: 16),)),

            const SizedBox(height: 30,),
            // actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // no
                TextButton(
                  onPressed: (){
                    // cancel ussd and overlay
                    widget.onSend('2');

                  }, 
                  child: const Text('No')
                ),

                // yes
                ElevatedButton(
                  onPressed: (){
                    // send input
                    widget.onSend('1');
                  }, 
                  child: const Text('Accept')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}