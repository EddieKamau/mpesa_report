import 'package:flutter/material.dart';
import 'package:mpesa_report/main.dart';
import 'package:mpesa_report/models/transaction_model.dart';
import 'package:mpesa_report/utils/amount_to_string.dart';


class TransactionHomePage extends StatefulWidget {
  const TransactionHomePage(this.itemModel, {this.isAll = false, Key? key }) : super(key: key);
  final ItemModel itemModel;
  final bool isAll;

  @override
  State<TransactionHomePage> createState() => _TransactionHomePageState();
}

class _TransactionHomePageState extends State<TransactionHomePage> {
  bool isSearching = false;
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _transactions = widget.itemModel.transactions;
  }

  void search(String val){
    setState(() {
      _transactions = widget.itemModel.transactions.where((t) => t.body.toLowerCase().contains(val.toLowerCase())).toList();
    });
  }

  void stopSearch(){
    setState(() {
      _transactions = widget.itemModel.transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: isSearching ? _searchField() : Text('${widget.itemModel.label} Transactions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: (){
                setState(() {
                  isSearching = !isSearching;
                });
                if(!isSearching){
                  stopSearch();
                }
              }, 
              icon: Icon(isSearching ? Icons.clear_outlined :Icons.search_outlined)
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Count:'),
                        Text(_transactions.length.toString()),
                      ],
                    ),

                    // for all
                    if(widget.isAll) Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total amount in:'),
                        Text(_transactions.totalIn.string),
                      ],
                    ),
                    if(widget.isAll) Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total amount out:'),
                        Text(_transactions.totalOut.string),
                      ],
                    ),

                    // for individual
                    if(!widget.isAll) Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total amount:'),
                        Text(_transactions.totalAmount.string),
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total cost:'),
                        Text(_transactions.totalCost.string),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if(isSearching) const LinearProgressIndicator(),

            Expanded(
              child: TransactionsPage(_transactions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField()=> Container(
    padding: const EdgeInsets.all(10),
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20)
    ),
    child: TextField(
      decoration: const InputDecoration(
        hintText: 'Search'
      ),
      onChanged: (String val){
        if(val.isEmpty){
          setState(() {
            isSearching = false;
          });
        }else{
          // search
          search(val);
        }
      },
    ),
  );
}


class TransactionsPage extends StatelessWidget {
  const TransactionsPage(this.transactions, { Key? key }) : super(key: key);

  final List<TransactionModel> transactions;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (_, index){
        var _t = transactions[index];
        return ListTile(
          leading: Text(_t.transactionType.name),
          title: Text(_t.partyDetail),
          subtitle: Text(_t.dateTime?.toString().substring(0, 16) ?? ''),
          trailing: Text('Ksh. ${_t.amountFormated}', style: TextStyle(color: _t.isPositive ? Colors.green : Colors.redAccent,)),
          onTap: (){
            showDialog(
              context: context, 
              builder: (_)=> Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _t.body,
                    style: const TextStyle(fontSize: 16, letterSpacing: 1.15, wordSpacing: 1.2, height: 1.2),
                  ),
                ),
              )
            );
          },
        );
      },
    );
  }

  
}