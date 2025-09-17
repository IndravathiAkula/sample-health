import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AdherenceChart extends StatefulWidget {
  final List<Map<String, dynamic>> adherenceData;

  const AdherenceChart({
    Key? key,
    required this.adherenceData,
  }) : super(key: key);

  @override
  State<AdherenceChart> createState() => _AdherenceChartState();
}

class _AdherenceChartState extends State<AdherenceChart>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isWeeklyView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Adherence Trends',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Container(
                        decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20)),
                        child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(20)),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor:
                            AppTheme.lightTheme.colorScheme.primary,
                            labelStyle: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            unselectedLabelStyle:
                            AppTheme.lightTheme.textTheme.labelSmall,
                            tabs: const [
                              Tab(text: 'Weekly'),
                              Tab(text: 'Monthly'),
                            ],
                            onTap: (index) {
                              setState(() {
                                _isWeeklyView = index == 0;
                              });
                            })),
                  ])),
          Container(
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final data = _isWeeklyView
                                    ? _getWeeklyData()
                                    : _getMonthlyData();
                                if (value.toInt() >= 0 &&
                                    value.toInt() < data.length) {
                                  return Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text(
                                          data[value.toInt()]['label']
                                          as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                              color: AppTheme
                                                  .lightTheme
                                                  .colorScheme
                                                  .onSurfaceVariant)));
                                }
                                return const SizedBox.shrink();
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                        color: AppTheme.lightTheme
                                            .colorScheme.onSurfaceVariant));
                              }))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (_isWeeklyView
                      ? _getWeeklyData().length
                      : _getMonthlyData().length) -
                      1.0,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                        spots: _getChartSpots(),
                        isCurved: true,
                        gradient: LinearGradient(colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.accentLight,
                        ]),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                  AppTheme.lightTheme.colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  AppTheme.accentLight.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              return LineTooltipItem(
                                  '${barSpot.y.toInt()}%',
                                  AppTheme.lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600) ??
                                      const TextStyle());
                            }).toList();
                          }))))),
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInsightItem(
                        'Average',
                        '${_calculateAverage().toInt()}%',
                        AppTheme.lightTheme.colorScheme.primary),
                    _buildInsightItem('Best Day', '${_getBestDay().toInt()}%',
                        AppTheme.accentLight),
                    _buildInsightItem('Trend', _getTrend(), _getTrendColor()),
                  ])),
        ]));
  }

  List<FlSpot> _getChartSpots() {
    final data = _isWeeklyView ? _getWeeklyData() : _getMonthlyData();
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), (entry.value['adherence'] as double));
    }).toList();
  }

  List<Map<String, dynamic>> _getWeeklyData() {
    return [
      {'label': 'Mon', 'adherence': 95.0},
      {'label': 'Tue', 'adherence': 88.0},
      {'label': 'Wed', 'adherence': 92.0},
      {'label': 'Thu', 'adherence': 85.0},
      {'label': 'Fri', 'adherence': 90.0},
      {'label': 'Sat', 'adherence': 78.0},
      {'label': 'Sun', 'adherence': 82.0},
    ];
  }

  List<Map<String, dynamic>> _getMonthlyData() {
    return [
      {'label': 'Week 1', 'adherence': 92.0},
      {'label': 'Week 2', 'adherence': 88.0},
      {'label': 'Week 3', 'adherence': 85.0},
      {'label': 'Week 4', 'adherence': 90.0},
    ];
  }

  double _calculateAverage() {
    final data = _isWeeklyView ? _getWeeklyData() : _getMonthlyData();
    final total = data.fold<double>(
        0, (sum, item) => sum + (item['adherence'] as double));
    return total / data.length;
  }

  double _getBestDay() {
    final data = _isWeeklyView ? _getWeeklyData() : _getMonthlyData();
    return data
        .map((item) => item['adherence'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  String _getTrend() {
    final data = _isWeeklyView ? _getWeeklyData() : _getMonthlyData();
    if (data.length < 2) return 'Stable';

    final first = data.first['adherence'] as double;
    final last = data.last['adherence'] as double;

    if (last > first + 5) return 'Improving';
    if (last < first - 5) return 'Declining';
    return 'Stable';
  }

  Color _getTrendColor() {
    final trend = _getTrend();
    switch (trend) {
      case 'Improving':
        return AppTheme.accentLight;
      case 'Declining':
        return AppTheme.errorLight;
      default:
        return AppTheme.warningLight;
    }
  }

  Widget _buildInsightItem(String label, String value, Color color) {
    return Column(children: [
      Text(value,
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700, color: color)),
      SizedBox(height: 0.5.h),
      Text(label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
    ]);
  }
}
