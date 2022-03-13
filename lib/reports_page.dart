import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mpesa_report/utils/amount_to_string.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage(this.items, { Key? key }) : super(key: key);
  final List<ReportItem> items;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool isPotrait = true;

  double _total = 0;

  @override
  void initState() {
    super.initState();
    _total = widget.items.fold(0, (previousValue, element) => previousValue+element.value);
  }


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        isPotrait = MediaQuery.of(context).orientation == Orientation.portrait;
        return Material(
          child: isPotrait ? Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 10, left: 20, right: 10),
            child: Column(
              children: [
                // chart
                _chart(),
                const SizedBox(height: 10,),
                // labels
                _labels(),
              ],
            ),
          ) : 
          Row(
            children: [
              // chart
              _chart(),
                const SizedBox(width: 10,),
              // labels
              _labels()
            ],
          ),
        );
      }
    );
  }

  Widget _chart()=> SizedBox(
    height: 290,
    width: 290,
    child: PieChart(
      PieChartData(
        sections: widget.items.map((item) => PieChartSectionData(
            value: item.value,
            color: item.color,
            radius: 60 + 50 * item.percentage(_total) / 100,
            title: '${item.percentage(_total)}%'
          )).toList()
      )
    ),
  );

  Widget _labels()=> Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: widget.items.map((item) => Indicator(label: item.label, value: item.value.string, color: item.color,)).toList(),
      ),
    ),
  );
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
  ReportItem({required this.label, required this.value, required this.color});
  String label;
  double value;
  Color color;

  int percentage(double total)=> (100*value/total).round();
}