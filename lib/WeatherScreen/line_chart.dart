import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ChartData {
  final DateTime timestamp;
  final double humidity;
  final double moisture;
  final double temperature;

  ChartData(this.timestamp, this.humidity, this.moisture, this.temperature);
}

class GoogleSheetService {
  final String sheetId;

  GoogleSheetService(this.sheetId);

  Future<List<ChartData>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1?key=AIzaSyAqYikfvM1LupRa-bUdrT6749jueGBVRP4'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('values')) {
        final values = data['values'] as List<dynamic>;

        // Skip the first row as it contains column headers
        final dataRows = values.skip(1);

        final dateFormat = DateFormat('MM/dd/yyyy HH:mm:ss');

        return dataRows.map((row) {
          return ChartData(
            dateFormat.parse(row[0] as String),
            double.parse(row[1] as String),
            double.parse(row[2] as String),
            double.parse(row[3] as String),
          );
        }).toList();
      } else {
        throw Exception('Failed to load data from Google Sheets');
      }
    } else {
      throw Exception('Failed to load data from Google Sheets');
    }
  }
}

// ...
class LineChartFromGoogleSheet extends StatefulWidget {
  const LineChartFromGoogleSheet({super.key});

  @override
  _LineChartFromGoogleSheetState createState() =>
      _LineChartFromGoogleSheetState();
}

class _LineChartFromGoogleSheetState extends State<LineChartFromGoogleSheet> {
  late Future<List<ChartData>> _chartData;
  late DateTime _selectedDate; // Change to DateTime

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Initialize with a default date
    _chartData = GoogleSheetService(
      '12sQBsLe8OyR-41gBluXrVX0UVRGPcovDbVUlhb3emTM',
    ).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Line Charts from Google Sheet'),
      ),
      body: FutureBuilder<List<ChartData>>(
        future: _chartData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildLineChart(
                    data,
                    'Humidity',
                    Colors.blue,
                        (item) => item.humidity,
                  ),
                  buildLineChart(
                    data,
                    'Moisture',
                    Colors.green,
                        (item) => item.moisture,
                  ),
                  buildLineChart(
                    data,
                    'Temperature',
                    Colors.red,
                        (item) => item.temperature,
                  ),
                  buildDateSelector(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildDateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            'Selected Date: ${DateFormat('MM/dd/yyyy').format(_selectedDate)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          FloatingActionButton(
            onPressed: () => _selectDate(context),
            tooltip: 'Select Date',
            child: const Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = _selectedDate;

    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    setState(() {
      _selectedDate = newDate;
    });
  }

  Widget buildLineChart(List<ChartData> data, String title, Color color,
      double Function(ChartData) getValue) {
    // Filter the data based on the selected date
    final filteredData = data
        .where((item) =>
    item.timestamp.day == _selectedDate.day &&
        item.timestamp.month == _selectedDate.month &&
        item.timestamp.year == _selectedDate.year)
        .toList();
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: 0,
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(reservedSize: 44, showTitles: true)),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(reservedSize: 44, showTitles: false)),
            topTitles: AxisTitles(
                sideTitles: SideTitles(reservedSize: 44, showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(reservedSize: 44, showTitles: true)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: const Color(0xff37434d),
              width: 3,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: filteredData
                  .map((item) =>
                  FlSpot(item.timestamp.hour.toDouble(), getValue(item)))
                  .toList(),
              isCurved: true,
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
              ),
              barWidth: 5,
            ),
          ],
        ),
      ),
    );
  }
}