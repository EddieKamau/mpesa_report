import 'package:flutter/material.dart';
import 'package:mpesa_report/src/transactions/models/option_model.dart';
import 'package:mpesa_report/src/transactions/modules/transaction_item_module.dart';
import 'package:mpesa_report/src/transactions/widgets/transaction_inputs_widget.dart';

class TransactionInputsPage extends StatefulWidget {
  const TransactionInputsPage(this.option, {Key? key}) : super(key: key);
  final OptionModel option;

  @override
  State<TransactionInputsPage> createState() => _TransactionInputsPageState();
}

class _TransactionInputsPageState extends State<TransactionInputsPage> {

  List<String> inputValues = [];
  String itemLabel = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.option.label),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // favorites
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Favorites', style: Theme.of(context).textTheme.titleMedium,),
            ),
            _FavoritesGrid(
              optionKey: widget.option.key,
              // onTap: ((values, {itemLabel}) => ),
              onTap: (values, _itemLabel) {
                setState(() {
                  inputValues = values;
                  itemLabel = _itemLabel;
                });
              },
            ),
      
      
            // inputs
            const Divider(),
            TransactionInputsWidget(widget.option, inputValues: inputValues, itemLabel: itemLabel)
          ],
        ),
      )
    );
  }
}

class _FavoritesGrid extends StatefulWidget {
  const _FavoritesGrid({required this.optionKey, this.onTap, Key? key}) : super(key: key);
  final Function(List<String> values, String itemLabel)? onTap;
  final String optionKey;

  @override
  State<_FavoritesGrid> createState() => _FavoritesGridState();
}

class _FavoritesGridState extends State<_FavoritesGrid> {
  TransactionItemModule module = TransactionItemModule();

  List<TransactionItemModel> favorites = [];

  void _fetchItems(){
    favorites = module.transactionsHistotyModels(key: widget.optionKey);
    favorites.sort();
    favorites = favorites.reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
    
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favorites.length,
        itemBuilder: (_, index){
          bool isPinned = favorites[index].score > 99999;
          return InkWell(
            onTap: (){
              widget.onTap?.call(favorites[index].inputs.map((e) => e.value).toList(), favorites[index].label);
            },
            onLongPress: (){
              // options (edit lable and pin and delete)
              showDialog(
                context: context, 
                builder: (_){
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // pinit
                          ElevatedButton.icon(
                            onPressed: (){
                              module.pinTransactionItemModel(favorites[index], pinIt: !isPinned);
                              setState(() {
                                _fetchItems();
                              });
                              Navigator.pop(_);
                            }, 
                            icon: Icon(!isPinned ? Icons.push_pin : Icons.push_pin_outlined), 
                            label: Text(isPinned ? 'unPin it' : 'Pin it')
                          ),

                          // edit
                          OutlinedButton(
                            onPressed: (){
                              Navigator.pop(_);
                              showDialog(
                                context: context, 
                                builder: (_){
                                  return Dialog(
                                    child: Builder(
                                      builder: (context) {
                                        TextEditingController labelController = TextEditingController(text: favorites[index].label);
                                        var inputs = favorites[index].inputs;
                                        Map<TextEditingController, TransactionIputItem> controllers = {
                                          // inputs
                                          for(var input in inputs)
                                            TextEditingController(text: input.value): input
                                        };

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // label 
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: labelController,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Label'
                                                    ),
                                                  ),
                                                ),
                                              
                                              // inputs
                                              for(var i=0; i< controllers.length; i++)
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: controllers.keys.toList()[i],
                                                    decoration: InputDecoration(
                                                      labelText: controllers.values.toList()[i].label
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: const Text('cancel')
                                                    ),

                                                    ElevatedButton(
                                                      onPressed: (){
                                                        var _item = favorites[index];
                                                        _item.label = labelController.text;
                                                        List<TransactionIputItem> _inputs = [];
                                                        for (var i = 0; i < controllers.length; i++) {
                                                          _inputs.add(TransactionIputItem(label: controllers.values.toList()[i].label, value: controllers.keys.toList()[i].text));
                                                        }
                                                        _item.inputs = _inputs;
                                                        module.editTransactionItemModel(_item);
                                                        setState(() {
                                                          favorites[index] = _item;
                                                        });
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: const Text('Update')
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                  );
                                }
                              );
                            }, 
                            child: const Text('Edit')
                          ),

                          // delete
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                            onPressed: (){
                              module.deleteTransactionItemModel(favorites[index]);
                              setState(() {
                                favorites.removeAt(index);
                              });
                              Navigator.pop(_);
                            }, 
                            child: const Text('Delete')
                          ),
                        ],
                      ),
                    ),
                  );
                }
              );
            },
            child: SizedBox(
              height: 90,
              width: 270,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Stack(
                          children: [
                            if(isPinned) const Align(alignment: Alignment.topRight, child: Icon(Icons.push_pin_outlined, color: Colors.grey, size: 20,),),
                            const Center(child: Text('B')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // label
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(favorites[index].label, style: Theme.of(context).textTheme.titleSmall,),
                            ),
          
                            // value 1, 2...
                            for(var input in favorites[index].inputs)
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("${input.label}: ${input.value}"),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}