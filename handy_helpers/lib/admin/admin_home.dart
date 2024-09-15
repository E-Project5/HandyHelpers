import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'home',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: AdminHome(),
  ));
}

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              "Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            //Initialize the chart widget
            // SfCircularChart(
            //     //  title: ChartTitle(text: 'Brand Sales'),
            //     legend: Legend(isVisible: true),
            //     series: <PieSeries<_PieData, String>>[
            //       PieSeries<_PieData, String>(
            //           explode: true,
            //           explodeIndex: 0,
            //           dataSource: pieData,
            //           xValueMapper: (_PieData data, _) => data.xData,
            //           yValueMapper: (_PieData data, _) => data.yData,
            //           dataLabelMapper: (_PieData data, _) => data.text,
            //           dataLabelSettings: DataLabelSettings(isVisible: true)),
            //     ]),
          SizedBox(height: 20,),
           Container(
             child: Padding(
                       padding: const EdgeInsets.all(4.0),
                       child: Expanded(
                         child: GridView.count(
                          shrinkWrap: true,
                                       crossAxisCount: 2,
                                       children: List.generate(4, (index) {
                                         return Card(
                                           elevation: 4.0,
                                           
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(10.0),
                                           ),
                                           child: Center(
                                             child: Padding(
                                               padding: const EdgeInsets.all(16.0),
                                               child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 40.0),
                            SizedBox(height: 8.0),
                            Text('Card $index'),
                          ],
                                               ),
                                             ),
                                           ),
                                         );
                                       }),
                         ),
                       ),
                     ),
           ),
          ])

          //  Center(
          //     child: DataTable(
          //       columns: [
          //         DataColumn(label: Text('Name')),
          //         DataColumn(label: Text('Age')),
          //         DataColumn(label: Text('Role')),
          //       ],
          //       rows: [
          //         DataRow(cells: [
          //           DataCell(Text('Alice')),
          //           DataCell(Text('25')),
          //           DataCell(Text('Developer')),
          //         ]),
          //         DataRow(cells: [
          //           DataCell(Text('Bob')),
          //           DataCell(Text('30')),
          //           DataCell(Text('Designer')),
          //         ]),
          //         DataRow(cells: [
          //           DataCell(Text('Charlie')),
          //           DataCell(Text('28')),
          //           DataCell(Text('Product Manager')),
          //         ]),
          //       ],
          //     ),
          //   ),

          ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  String? text;
}

List<_PieData> pieData = [
  _PieData('John', 35, 'John'),
  _PieData('Doe', 25, 'Doe'),
  _PieData('Jane', 40, 'Jane'),
];
