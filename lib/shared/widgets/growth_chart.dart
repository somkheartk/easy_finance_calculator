import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';

class GrowthLineChart extends StatelessWidget {
  const GrowthLineChart({
    super.key,
    required this.dataPoints,
    required this.principalPoints,
    this.currencyCode = 'THB',
    this.title,
    this.valueLabel = 'Portfolio Value',
    this.principalLabel = 'Total Principal',
    this.height = 220,
  });

  final List<Map<String, double>> dataPoints;
  final List<Map<String, double>> principalPoints;
  final String currencyCode;
  final String? title;
  final String valueLabel;
  final String principalLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spots = dataPoints
        .map((p) => FlSpot(p['month']!, p['value']!))
        .toList();
    final principalSpots = principalPoints
        .map((p) => FlSpot(p['month']!, p['principal']!))
        .toList();

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: scheme.outlineVariant.withOpacity(0.3),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 64,
                    getTitlesWidget: (value, meta) {
                      if (value == minY || value == meta.max) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            CurrencyFormatter.format(value,
                                currencyCode: currencyCode, compact: true),
                            style: TextStyle(
                              fontSize: 10,
                              color: scheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.min || value == meta.max) {
                        return Text(
                          'M${value.toInt()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: scheme.onSurfaceVariant,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: spots.first.x,
              maxX: spots.last.x,
              minY: minY,
              maxY: maxY * 1.05,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final isValue = spot.barIndex == 0;
                      return LineTooltipItem(
                        '${isValue ? valueLabel : principalLabel}\n'
                        '${CurrencyFormatter.format(spot.y, currencyCode: currencyCode, compact: true)}',
                        TextStyle(
                          color: isValue ? AppColors.primary : AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                // Portfolio value line
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.08),
                  ),
                ),
                // Principal line
                LineChartBarData(
                  spots: principalSpots,
                  isCurved: false,
                  color: AppColors.success,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 5],
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _LegendItem(color: AppColors.primary, label: valueLabel),
            const SizedBox(width: 16),
            _LegendItem(
                color: AppColors.success, label: principalLabel, dashed: true),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 3,
          decoration: BoxDecoration(
            color: dashed ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(2),
            border: dashed ? Border.all(color: color, width: 1) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.principal,
    required this.profit,
    this.principalLabel = 'Principal',
    this.profitLabel = 'Profit',
    this.size = 140,
  });

  final double principal;
  final double profit;
  final String principalLabel;
  final String profitLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (principal <= 0 && profit <= 0) return const SizedBox.shrink();

    return SizedBox(
      height: size,
      width: size,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: size * 0.28,
          sections: [
            PieChartSectionData(
              value: principal,
              color: AppColors.primary.withOpacity(0.7),
              title: '',
              radius: size * 0.2,
            ),
            PieChartSectionData(
              value: profit,
              color: AppColors.success,
              title: '',
              radius: size * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
