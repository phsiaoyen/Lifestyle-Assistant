import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_dart/models/pie_chart_data.dart';

class Buildpiechart extends StatelessWidget{
  const Buildpiechart(this._data,{super.key});
  final List<Dietdata> _data;

  @override
  Widget build(BuildContext context){
    return SfCircularChart(
      legend:const Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap),
      series:<CircularSeries>[
        PieSeries<Dietdata,String>(
          dataSource:_data,
          xValueMapper: (Dietdata data,_) => data.category,
          yValueMapper: (Dietdata data,_) => data.amount,
          //dataLabelSettings: DataLabelSettings(isVisible: true),
          )
      ]
    );
  }
}