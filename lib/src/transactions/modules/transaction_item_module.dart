import 'package:mpesa_report/src/transactions/models/transaction_item_model.dart';

export 'package:mpesa_report/src/transactions/models/transaction_item_model.dart';

class TransactionItemModule{
  static TransactionItemModule? _cache;

  TransactionItemModule._internal();

  factory TransactionItemModule (){
    _cache ??= TransactionItemModule._internal();
    return _cache!;
  }

  final TransactionItemModel transactionItemModel = TransactionItemModel(itemKey: '', label: '', inputs: []);

  Future<void> connectTransactionItemModel() async {
    TransactionIputItem transactionIputItem = TransactionIputItem(label: '', value: '');
    await transactionIputItem.connect(openBox: false);

    await transactionItemModel.connect();
  }

  List<TransactionItemModel> get _transactionsHistotyModels{
    return List<TransactionItemModel>.from(transactionItemModel.modelBox?.values.toList() ?? []);
  }

  List<TransactionItemModel> transactionsHistotyModels({String? key}){
    if(key == null){
      return _transactionsHistotyModels;
    }else{
      return _transactionsHistotyModels.where((element) => element.itemKey == key).toList();
    }
  } 

  void addTransactionItemModel(TransactionItemModel item){
    var _index = _transactionsHistotyModels.indexOf(item);
    if(_index != -1){
      // increment score
      var _it = _transactionsHistotyModels[_index];
      _it.score = _it.score + 1;
      transactionItemModel.modelBox?.putAt(_index, _it);
    }else{
      // add
      transactionItemModel.modelBox?.add(item);
    }
  }

  void pinTransactionItemModel(TransactionItemModel item, {bool pinIt = true}){
    var _index = _transactionsHistotyModels.indexOf(item);
    if(_index != -1){
      // increment score
      var _it = _transactionsHistotyModels[_index];
      _it.score = pinIt ? (99999 + _it.score) : (_it.score - 99999);
      transactionItemModel.modelBox?.putAt(_index, _it);
    }
  }

  void editTransactionItemModel(TransactionItemModel item){
    var _index = _transactionsHistotyModels.indexOf(item);
    if(_index != -1){
      // increment score
      transactionItemModel.modelBox?.putAt(_index, item);
    }
  }

  void deleteTransactionItemModel(TransactionItemModel item){
    var _index = _transactionsHistotyModels.indexOf(item);
    if(_index != -1){
      // increment score
      transactionItemModel.modelBox?.deleteAt(_index);
    }
  }
}

List<TransactionItemModel> _tt = [
  for(int i=0; i<9; i++)
    TransactionItemModel(itemKey: 'send', label: 'Name Name$i', inputs: [TransactionIputItem(label: 'PhoneNo', value: '071234567$i')]),

  for(int i=0; i<4; i++)
    TransactionItemModel(itemKey: 'withdraw', label: 'Agent Name$i', inputs: [TransactionIputItem(label: 'AgentNo', value: '12345$i')]),

  for(int i=0; i<4; i++)
    TransactionItemModel(itemKey: 'paybill', label: 'Business A$i', inputs: [TransactionIputItem(label: 'BusinessNo', value: '12345$i'), TransactionIputItem(label: 'AccountNo', value: '12345678$i')]),

  for(int i=0; i<8; i++)
    TransactionItemModel(itemKey: 'buygoods', label: 'Business A$i', inputs: [TransactionIputItem(label: 'TillNo', value: '12345$i')]),

  for(int i=0; i<9; i++)
    TransactionItemModel(itemKey: 'Airtime', label: 'Name Name$i', inputs: [TransactionIputItem(label: 'PhoneNo', value: '071234567$i')]),

  for(int i=0; i<3; i++)
    TransactionItemModel(itemKey: 'equity', label: 'Business A$i', inputs: [TransactionIputItem(label: 'AccountNo', value: '12345$i')]),

  for(int i=0; i<3; i++)
    TransactionItemModel(itemKey: 'kcb', label: 'Business A$i', inputs: [TransactionIputItem(label: 'AccountNo', value: '12345$i')]),

  for(int i=0; i<4; i++)
    TransactionItemModel(itemKey: 'coop', label: 'Business A$i', inputs: [TransactionIputItem(label: 'AccountNo', value: '12345$i')]),

  for(int i=0; i<2; i++)
    TransactionItemModel(itemKey: 'kplc-tokens', label: '', inputs: [TransactionIputItem(label: 'AccountNo', value: '12345$i')]),

  for(int i=0; i<1; i++)
    TransactionItemModel(itemKey: 'kplc-postpay', label: '', inputs: [TransactionIputItem(label: 'AccountNo', value: '12345$i')]),

  for(int i=0; i<1; i++)
    TransactionItemModel(itemKey: 'nhif', label: '', inputs: [TransactionIputItem(label: 'AccountNo', value: '12345$i')]),


];