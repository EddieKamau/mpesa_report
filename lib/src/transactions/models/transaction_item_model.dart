import 'package:hive/hive.dart';
import 'package:mpesa_report/src/hive_manager/hive_manager.dart';

part 'transaction_item_model.g.dart';

@HiveType(typeId: 1)
class TransactionItemModel extends HiveManager<TransactionItemModel> implements Comparable<TransactionItemModel>{
  TransactionItemModel({
    required this.itemKey, required this.label, required this.inputs
  }):super('transactionItem', TransactionItemModelAdapter());
  @HiveField(0)
  int score = 0;
  @HiveField(1)
  String itemKey;
  @HiveField(2)
  String label;
  @HiveField(3)
  List<TransactionIputItem> inputs;

  @override
  int compareTo(TransactionItemModel other)=> score.compareTo(other.score);


  @override
  bool operator ==(other){
    bool _inputsEqual(){
      if(other is! TransactionItemModel) return false;
      if(inputs.length != other.inputs.length){
        return false;
      }
      bool _same = true;
      for(int i=0; i<inputs.length; i++){
        if(_same){
          _same = inputs[i].value == other.inputs[i].value;
        }
      }
      return _same;
    }

    return other is TransactionItemModel && other.itemKey == itemKey && _inputsEqual();
  }
  
  @override
  int get hashCode => inputs.hashCode;
  
}

@HiveType(typeId: 2)
class TransactionIputItem extends HiveManager<TransactionIputItem>{
  TransactionIputItem({required this.label, required this.value}):super('', TransactionIputItemAdapter());
  @HiveField(0)
  String label;
  @HiveField(1)
  String value;
}
