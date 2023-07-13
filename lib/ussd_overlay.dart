import 'package:flutter/material.dart';
import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:mpesa_report/src/ussd_widgets/ussd_close_widget.dart';
import 'package:mpesa_report/src/ussd_widgets/ussd_confirmation_widget.dart';
import 'package:mpesa_report/src/ussd_widgets/ussd_dialog_widget.dart';

class USSDOverlay extends StatefulWidget {
  const USSDOverlay({Key? key}) : super(key: key);

  @override
  State<USSDOverlay> createState() => _USSDOverlayState();
}

class _USSDOverlayState extends State<USSDOverlay> {

  bool isLoading = true;
  String data = '';
  UssdWidgetType widgetType = UssdWidgetType.dialog;

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

  var overlayStreamController = FlutterOverlayApps.overlayListener();


  @override
  void initState() {
    super.initState();
    // lisent for any data from the main app
    overlayStreamController.stream.listen((event) {
      var _message = OverlayMessage.fromMap(event);
      if (_message.type == OverlayMessageType.message) {
        _active = true;
        calcProgress();
        setState(() {
          isLoading = false;
          data = _message.message.toString();
          widgetType = _message.widgetType;
        });
      } else if(_message.type == OverlayMessageType.close) {
        // FlutterOverlayApps.closeOverlay();
        setState(() {
          isLoading = false;
          data = _message.message.toString();
          widgetType = _message.widgetType;
        });
      }else{
        if(event['method'] == 'backButton'){
          if(mounted && Navigator.of(context).canPop()){Navigator.of(context).pop();}
          else{
            
            onCancel();
          }
        }
      }
    });
  }

  

  @override
  void dispose() {
    super.dispose();
    data = '';
    widgetType = UssdWidgetType.dialog;
    overlayStreamController.close();
    FlutterOverlayApps.closeOverlay();
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
            child: widgetType.widget(
              data: data,
              onSend: onSend,
              onCancel: onCancel,
              onColse: onColse
            ),
          )
        ],
      ),
    );
  }

  void onCancel(){
    _active = false;
    setState(() {
      isLoading = true;
      data = '';
    });
    FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(type: OverlayMessageType.close).asMap());
    FlutterOverlayApps.closeOverlay();
  }

  void onColse(){
    _active = false;
    setState(() {
      isLoading = true;
      data = '';
    });
    
    FlutterOverlayApps.closeOverlay();
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
  OverlayMessage({this.type = OverlayMessageType.message, this.message, this.widgetType = UssdWidgetType.dialog});
  OverlayMessage. fromMap(Map map){
    try{
      type = OverlayMessageType.values.byName(map['type']);
    }catch(_){
      type = OverlayMessageType.other;
    }
    try{
      widgetType = UssdWidgetType.values.byName(map['widgetType']);
    }catch(_){
      widgetType = UssdWidgetType.dialog;
    }
    message = map['message']?.toString();
  }
  late OverlayMessageType type;
  UssdWidgetType widgetType = UssdWidgetType.dialog;
  String? message;

  Map<String, String?> asMap()=>{
    'type': type.name,
    'widgetType': widgetType.name,
    'message': message,
  };
}
enum OverlayMessageType{
  message, close, other
}

class _LoadiningWidget extends StatelessWidget {
  _LoadiningWidget({required this.onCancel, Key? key}) : super(key: key);
  final Function() onCancel;
  final FocusNode focusNode  = FocusNode ();


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text('Loading...'),
          ),
          LinearProgressIndicator(color: Theme.of(context).primaryColor,),
          const SizedBox(height: 30,),
          TextButton(onPressed: onCancel, child: const Text('cancel'))
        ],
      ),
    );
  }
}

enum UssdWidgetType{
  dialog, confirmation, fuliza, close
}

extension UssdWidgetTypeExt on UssdWidgetType{
  Widget widget({required String data, required Function(String val) onSend, required Function() onCancel, Function()? onColse}){
    switch (this) {
      case UssdWidgetType.close:
        return UssdCloseWidget(data: data, onColse: onColse);
      case UssdWidgetType.confirmation:
      case UssdWidgetType.fuliza:
        return UssdConfirmationWidget(data: data, onSend: onSend,);
      default:
        return UssdDialogWidget(data: data, onSend: onSend, onCancel: onCancel,);
    }
  }
}


