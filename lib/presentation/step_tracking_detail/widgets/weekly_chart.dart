import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklyChart extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final Function(int) onDaySelected;

  const WeeklyChart({
    Key? key,
    required this.weeklyData,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
        width: double.infinity,
        height: 25.h,
        padding: EdgeInsets.all(4.w),
        decoration:
            AppTheme.glassDecoration(isLight: isLight, borderRadius: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Weekly Progress',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Expanded(
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: widget.weeklyData.isNotEmpty
                      ? (widget.weeklyData
                              .map((e) => e['steps'] as int)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2)
                      : 10000,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (event is FlTapUpEvent &&
                            barTouchResponse?.spot != null) {
                          final index =
                              barTouchResponse!.spot!.touchedBarGroupIndex;
                          setState(() {
                            selectedIndex = selectedIndex == index ? -1 : index;
                          });
                          widget.onDaySelected(index);
                        }
                      },
                      touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final dayData = widget.weeklyData[groupIndex];
                            return BarTooltipItem(
                                '${dayData['day']}\n${dayData['steps']} steps',
                                TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp));
                          })),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() < widget.weeklyData.length) {
                                  return Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text(
                                          widget.weeklyData[value.toInt()]
                                                  ['day']
                                              .toString()
                                              .substring(0, 3),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(fontSize: 9.sp)));
                                }
                                return const SizedBox();
                              },
                              reservedSize: 3.h)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 2000,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                    '${(value / 1000).toStringAsFixed(0)}k',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 8.sp));
                              },
                              reservedSize: 8.w))),
                  borderData: FlBorderData(show: false),
                  barGroups: widget.weeklyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final isSelected = selectedIndex == index;

                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: (data['steps'] as int).toDouble(),
                          color: isSelected
                              ? AppTheme.accentLight
                              : AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.8),
                          width: 4.w,
                          borderRadius: BorderRadius.circular(2),
                          backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: widget.weeklyData
                                      .map((e) => e['steps'] as int)
                                      .reduce((a, b) => a > b ? a : b) *
                                  1.2,
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1))),
                    ]);
                  }).toList(),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.dividerLight.withValues(alpha: 0.3),
                            strokeWidth: 1);
                      })))),
        ]));
  }
}
