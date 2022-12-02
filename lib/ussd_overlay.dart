import 'package:flutter/material.dart';
import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';

class USSDOverlay extends StatefulWidget {
  const USSDOverlay({Key? key}) : super(key: key);

  @override
  State<USSDOverlay> createState() => _USSDOverlayState();
}

class _USSDOverlayState extends State<USSDOverlay> {

  bool isLoading = true;
  String data = '';

  double _progressValue = 0;
  bool _showProgress = false;
  bool _active = false;

  void calcProgress()async{
    _showProgress = false;
    _progressValue = 0;
    var now = DateTime.now();

    int ussdDuration = 57;
    int progressDuration = 20;

    while (_active) {
      var current = DateTime.now();
      var difference = (current.microsecondsSinceEpoch - now.microsecondsSinceEpoch) / 1000000;
      if(difference > ussdDuration){
        // setState(() {
          _showProgress = false;
          _progressValue = 1;
        // });
        _active = false;
        // cancel
        onCancel();
        break;
      }
      if (difference >= ussdDuration - progressDuration) {
        setState(() {
          _showProgress = true;
          _progressValue = 1 - ((progressDuration - (ussdDuration - difference)) / progressDuration);
        });
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }


  @override
  void initState() {
    super.initState();
    // lisent for any data from the main app
    FlutterOverlayApps.overlayListener().listen((event) {
      var _message = OverlayMessage.fromMap(event);
      if (_message.type == OverlayMessageType.message) {
        _active = true;
        calcProgress();
        setState(() {
          isLoading = false;
          data = _message.message.toString();
        });
      } else {
        FlutterOverlayApps.closeOverlay();
      }
    });
  }

  

  @override
  void dispose() {
    super.dispose();
    data = '';
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: isLoading ? _LoadiningWidget(onCancel: onCancel): 
      Column(
        children: [
          if(_showProgress) LinearProgressIndicator(
            minHeight: 10,
            value: _progressValue,
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: UssdWidget(
            data: data,
            onSend: onSend,
            onCancel: onCancel,
                  ),
          )
        ],
      ),
    );
  }

  void onCancel(){
    _active = false;
    isLoading = true;
    // FlutterOverlayApps.disposeOverlayListener();
    FlutterOverlayApps.closeOverlay();
    FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(type: OverlayMessageType.close).asMap());
  }

  void onSend(String val){
    _active = false;
    setState(() {
      isLoading = true;
      data = '';
    });
    FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: val).asMap());
  }
}

class OverlayMessage{
  OverlayMessage({this.type = OverlayMessageType.message, this.message});
  OverlayMessage.fromMap(Map map){
    type = OverlayMessageType.values.byName(map['type']);
    message = map['message']?.toString();
  }
  late OverlayMessageType type;
  String? message;

  Map<String, String?> asMap()=>{
    'type': type.name,
    'message': message,
  };
}
enum OverlayMessageType{
  message, close
}

class _LoadiningWidget extends StatelessWidget {
  const _LoadiningWidget({required this.onCancel, Key? key}) : super(key: key);
  final Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onCancel,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Loading...'),
            LinearProgressIndicator(color: Theme.of(context).primaryColor,)
          ],
        ),
      ),
    );
  }
}

class UssdWidget extends StatefulWidget {
  const UssdWidget({required this.data, required this.onSend, required this.onCancel, Key? key}) : super(key: key);
  final String data;
  final Function(String val) onSend;
  final Function() onCancel;

  @override
  State<UssdWidget> createState() => _UssdWidgetState();
}

class _UssdWidgetState extends State<UssdWidget> {
  TextEditingController? _controller;
  final String? title = 'Select one below';
  String data = '';

  Map<String, String>? options;

  bool hasInput = false;
  bool hasBack = false;
  String? backValue;

  void getValues(){
    String seperator = ':';
  
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
  void didUpdateWidget(covariant UssdWidget oldWidget) {
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


