import 'package:mpesa_report/models/export_models.dart' show GoodsServicesModel, GoodsServicesTransactionsModel;
import 'package:mpesa_report/utils/export_utils.dart';

class GoodsServicesModule{

  GoodsServicesTransactionsModel goodsServicesTransactionsModel = GoodsServicesTransactionsModel();
  List<GoodsServicesModel> goodsServicesModels = [];

  DateTime? _dateTime;
  double _amount = 0;
  String? _transId;
  double? _balanceWallet;
  String? _secondPartName;


  void process(String _body){

    // Extract amount
    _amount = extractAmount(_body);

    // Extract balance
    _balanceWallet = transfersBalance(_body);

    // Extract datetime
    _dateTime = extractDate(_body);

    // Extract name
    _secondPartName = _body.split('paid to ')[1].split('.')[0]; // name

    // Extract transId
    _transId = _body.split(' ')[0];



    goodsServicesModels.add(GoodsServicesModel(
      amount: _amount,
      balance: _balanceWallet,
      dateTime: _dateTime,
      partyName: _secondPartName,
      transId: _transId,
    ));
    goodsServicesTransactionsModel.transactions = goodsServicesModels;
  }

}