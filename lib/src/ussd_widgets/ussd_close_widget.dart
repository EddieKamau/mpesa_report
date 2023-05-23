import 'package:flutter/material.dart';
import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';

class UssdCloseWidget extends StatefulWidget {
  const UssdCloseWidget({required this.data, this.onColse, Key? key}) : super(key: key);
  final String data;
  final Function()? onColse;

  @override
  State<UssdCloseWidget> createState() => _UssdWidgetState();
}

class _UssdWidgetState extends State<UssdCloseWidget> {
  String data = '';
  String title = '';


  void getValues(){
  
    var ops = data.split('\n');
    if(ops.length >1) ops.removeLast();
    title = ops.join('\n');
    
    
    
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
  void didUpdateWidget(covariant UssdCloseWidget oldWidget) {
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

                // close
                ElevatedButton(
                  onPressed: widget.onColse, 
                  child: const Text('Close')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}