import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';

class SimpleLineChart extends StatefulWidget {
  const SimpleLineChart({Key? key}) : super(key: key);

  @override
  _SimpleLineChartState createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart> {
  final List<String> bulan = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];

  final PengepulController pengepulC = Get.put(PengepulController());

  @override
  void initState() {
    super.initState();
    pengepulC.fetchRataRataHarga('arabika', '2025');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Obx(() {
            final data = pengepulC.rataRataHargaKopi;

            return LineChart(
              LineChartData(
                minX: 1,
                maxX: 12,
                minY: 0,
                maxY: 12000,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2000,
                      getTitlesWidget: (value, meta) {
                        if (value % 2000 != 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            '${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt() - 1;
                        if (index < 0 || index >= bulan.length)
                          return const SizedBox();
                        return Text(
                          bulan[index],
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          'Rp ${spot.y.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent &&
                        (response == null || response.lineBarSpots == null)) {
                      setState(
                          () {}); // akan memicu UI update dan menghilangkan tooltip
                    }
                  },
                  handleBuiltInTouches: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.map((item) {
                      return FlSpot(
                        item.bulan.toDouble(),
                        item.rata_rata_harga.toDouble(),
                      );
                    }).toList(),
                    isCurved: false,
                    barWidth: 3,
                    color: Colors.blue,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
