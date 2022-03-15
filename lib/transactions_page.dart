import 'package:flutter/material.dart';
import 'package:mpesa_report/models/transaction_model.dart';
import 'package:mpesa_report/utils/amount_to_string.dart';


class TransactionHomePage extends StatefulWidget {
  const TransactionHomePage({required this.transactions, required this.label, this.isAll = false, Key? key }) : super(key: key);
  final List<TransactionModel> transactions;
  final String label;
  final bool isAll;

  @override
  State<TransactionHomePage> createState() => _TransactionHomePageState();
}

class _TransactionHomePageState extends State<TransactionHomePage> {
  bool isSearching = false;
  List<TransactionModel> _transactions = [];
  DateTimeRange? _dateTimeRange;
  List<TransactionModel> _bufferTransactions = [];

  DateTime? _lstInputTime;

  bool get _isloading => _lstInputTime != null && _lstInputTime!.isAfter(DateTime.now());

  @override
  void initState() {
    super.initState();
    _transactions = widget.transactions;
  }

  void __setLstDate(){
    _lstInputTime = DateTime.now().add(const Duration(seconds: 1));
    Future.delayed(const Duration(seconds: 1),).then((value) => setState((){}));
  
  }


  void search(String val){
    setState(() {
      __setLstDate();
      if(_dateTimeRange != null){
        _transactions = widget.transactions.dateFilter(_dateTimeRange!);
      }else{
        _transactions = widget.transactions;
      }

      _transactions = _transactions.search(val);
      _bufferTransactions = List.from(_transactions);
    });
  }

  void stopSearch(){
    setState(() {
      _lstInputTime = null;
      _transactions = widget.transactions;
      _dateTimeRange = null;
      _bufferTransactions = [];
    });
  }

  void filterByDate(DateTimeRange dateTimeRange){
    setState(() {
      _dateTimeRange = dateTimeRange;
      _transactions = isSearching ? _bufferTransactions.dateFilter(dateTimeRange) : widget.transactions.dateFilter(dateTimeRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: isSearching ? _searchField() : Text('${widget.label} Transactions'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var _res = await showDateRangePicker(
            context: context, firstDate: DateTime(2019), lastDate: DateTime(2099),
            initialDateRange: _dateTimeRange
          );

          if(_res != null){
            var _dtr = DateTimeRange(start: _res.start, end: _res.end.add(const Duration(days: 1)));
            filterByDate(_dtr);
          }
        },
        child: const Icon(Icons.calendar_today),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
            if(isSearching && _isloading) const LinearProgressIndicator(),

            Expanded(
              child: TransactionsPage(_transactions, isAll: widget.isAll,),
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
      color: Theme.of(context).backgroundColor,
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
  const TransactionsPage(this.transactions, {this.isAll = false, Key? key }) : super(key: key);

  final List<TransactionModel> transactions;
  final bool isAll;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (_, index){
        var _t = transactions[index];
        return ListTile(
          leading: isAll ? Text(_t.transactionType.name) : null,
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