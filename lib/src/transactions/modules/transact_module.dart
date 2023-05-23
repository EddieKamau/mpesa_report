import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:mpesa_report/src/transactions/models/option_model.dart';
import 'package:mpesa_report/src/transactions/modules/transaction_item_module.dart';
import 'package:mpesa_report/ussd_overlay.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class TransactModule {
  static Future<void> transact({
    required TransactionItemModel transactionItemModel,
    required OptionModel optionModel
  }) async {

    await FlutterOverlayApps.showOverlay(
      height: 450,
      alignment: OverlayAlignment.center
    );
    // send ussd
    var _res =await UssdAdvanced.multisessionUssd(code: '*334#', subscriptionId: 0);
    var __res = _res?.split('\n')[0];
    if(_res == null || _res == '' || _res == '\n' || __res == 'Check your accessibility') {
      await Future.delayed(const Duration(milliseconds: 100));
      FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: 'Turn on access', widgetType: UssdWidgetType.close, type: OverlayMessageType.close).asMap());
      return;
    }
    var overlayStreamController = FlutterOverlayApps.overlayListener();
    try {
      overlayStreamController.stream.listen((event) async {
        var _message = OverlayMessage.fromMap(event);
        if (_message.type == OverlayMessageType.message) {
          await UssdAdvanced.sendMessage(_message.message ?? '0').then((value) {
            if((value ?? '').split('\n').length < 2){
              FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: event, widgetType: UssdWidgetType.close, type: OverlayMessageType.close).asMap());
            }else if(value.toString().toLowerCase().contains('accept')){
              // send confirmation dialog 
              FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: value, widgetType: UssdWidgetType.confirmation).asMap());
            } else{
              FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: event, widgetType: UssdWidgetType.close, type: OverlayMessageType.close).asMap());
            }
          });

          
        } else {
          UssdAdvanced.cancelSession();
          FlutterOverlayApps.closeOverlay();
          overlayStreamController.close();
          return;
        }
      });
    } catch (e) { 
      FlutterOverlayApps.closeOverlay();
      overlayStreamController.close();
      return;
    }

    var _ussdEndStreamController = UssdAdvanced.onEnd();
    _ussdEndStreamController.stream.listen((event) {
      FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: event, widgetType: UssdWidgetType.close, type: OverlayMessageType.close).asMap());
      overlayStreamController.close();
      _ussdEndStreamController.close();
    });
    
    



    String? ussdResponse;
    for (var input in optionModel.inputs) {
      var _r = await UssdAdvanced.sendMessage(input.value ?? '0');
      if(_r == null || _r.toLowerCase().contains('invalid')) {
        FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: _r, type: OverlayMessageType.close).asMap());
        break;
      }
      ussdResponse = _r;
    }
    
    if(ussdResponse == null){
      FlutterOverlayApps.closeOverlay();
      overlayStreamController.close();
      return;
    }
    if(ussdResponse.toLowerCase().contains('fuliza')){
      // send fuliza confirmation
      await FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: ussdResponse, widgetType: UssdWidgetType.fuliza).asMap());
      
    }else{

      // send confirmation dialog 
      await FlutterOverlayApps.sendDataToAndFromOverlay(OverlayMessage(message: ussdResponse, widgetType: UssdWidgetType.confirmation).asMap());
//       Send KSH1.00 to ELIUD KAMAU 
//        Transaction cost: KSH0.00
//        1. Accept
//      2. Cancel
      // extract name



    }



    // update item
    TransactionItemModule transactionItemModule = TransactionItemModule(); 
    if(transactionItemModel.inputs.isNotEmpty){
      if(transactionItemModel.label == ''){
        // TODO: update
      }
      // add item model
      transactionItemModule.addTransactionItemModel(transactionItemModel);
    }

  }
}