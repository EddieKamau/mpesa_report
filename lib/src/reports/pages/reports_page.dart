import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mpesa_report/src/reports/models/transaction_model.dart';
import 'package:mpesa_report/src/reports/pages/transactions_page.dart';
import 'package:mpesa_report/src/reports/utils/amount_to_string.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({required this.transactions, required this.labels, required this.colors, Key? key }) : super(key: key);
  final List<List<TransactionModel>> transactions;
  final List<String> labels;
  final List<Color> colors;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool isPotrait = true;
  DateTimeRange? _dateTimeRange;
  List<ReportItem> items = [];

  double get _total => items.fold(0, (previousValue, element) => previousValue+element.value);

  @override
  void initState() {
    super.initState();
    for(int i=0; i< widget.transactions.length; i++){
      items.add(ReportItem(index: i, label: widget.labels[i], value: widget.transactions[i].totalAmount, color: widget.colors[i]));
    }
  }

  void onDateFilter(DateTimeRange dateTimeRange){
    setState(() {
      items.clear();
      for(int i=0; i< widget.transactions.length; i++){
        items.add(ReportItem(index: i, label: widget.labels[i], value: widget.transactions[i].dateFilter(dateTimeRange).totalAmount, color: widget.colors[i]));
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Report'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var _res = await showDateRangePicker(
            context: context, firstDate: DateTime(2019), lastDate: DateTime(2099),
            initialDateRange: _dateTimeRange
          );

          if(_res != null){
            setState(() {
              _dateTimeRange = _res;
            });
            var _dtr = DateTimeRange(start: _res.start, end: _res.end.add(const Duration(days: 1)));
            onDateFilter(_dtr);
          }
        },
        child: const Icon(Icons.calendar_today),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 15,
            children: [
              // chart
              _chart(),
              const SizedBox(height: 10,),
              // labels
              _labels(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chart()=> SizedBox(
    height: 290,
    width: 290,
    child: PieChart(
      PieChartData(
        pieTouchData:PieTouchData(touchCallback: (a,b){
          if(b!= null && b.touchedSection != null){
            int _index = b.touchedSection!.touchedSectionIndex;
            if (_index >= 0) {
              _index = items.where((element) => element.value > 0).toList()[_index].index;
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TransactionHomePage(transactions: widget.transactions[_index], label: widget.labels[_index],)));
            }
          }
        }),
        sections: items.map((item) => PieChartSectionData(
            value: item.value,
            color: item.color,
            radius: 60 + 50 * item.percentage(_total) / 100,
            title: '${item.percentage(_total)}%'
          )).toList()
      )
    ),
  );

  Widget _labels() {
    List<ReportItem> _l = List.from(items);
    _l.retainWhere((i)=> i.value > 0);
    return SingleChildScrollView(
    child: Column(
      children: _l.map((item) => Indicator(label: item.label, value: item.value.string, color: item.color,)).toList(),
    ),
  );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({required this.label, required this.value, required this.color, Key? key }) : super(key: key);
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.only(top:2, bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // value
          SizedBox(width: 60, child: Text(value, textAlign: TextAlign.end,)),

          // color
          Container(
            height: 18,
            width: 18,
            color: color,
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),

          // label
          Text(label)
        ],
      ),
    );
  }
}

class ReportItem {
  ReportItem({required this.label, required this.value, required this.color, required this.index});
  String label;
  double value;
  Color color;
  int index;


  int percentage(double total)=> (100*value/total).round();

  @override
  bool operator ==(other)=> other is ReportItem && other.index == index;
  

  @override
  int get hashCode => index;

}