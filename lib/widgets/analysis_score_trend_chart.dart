import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oy_site/models/customer_analysis_result_model.dart';

class AnalysisScoreTrendChart extends StatelessWidget {
  final String title;
  final List<CustomerAnalysisResult> results;
  final double Function(CustomerAnalysisResult result) leftScoreSelector;
  final double Function(CustomerAnalysisResult result) rightScoreSelector;

  const AnalysisScoreTrendChart({
    super.key,
    required this.title,
    required this.results,
    required this.leftScoreSelector,
    required this.rightScoreSelector,
  });

  String _formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sortedResults = [...results]
      ..sort((a, b) => a.analysisDate.compareTo(b.analysisDate));

    final leftSpots = <FlSpot>[];
    final rightSpots = <FlSpot>[];

    for (int i = 0; i < sortedResults.length; i++) {
      leftSpots.add(
        FlSpot(i.toDouble(), leftScoreSelector(sortedResults[i])),
      );
      rightSpots.add(
        FlSpot(i.toDouble(), rightScoreSelector(sortedResults[i])),
      );
    }

    return Container(
      width: 340,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLegendDot('Sol Ayak', Colors.teal),
              const SizedBox(width: 12),
              _buildLegendDot('Sağ Ayak', Colors.orange),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= sortedResults.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _formatShortDate(sortedResults[index].analysisDate),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: leftSpots,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.teal,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: rightSpots,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.orange,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}