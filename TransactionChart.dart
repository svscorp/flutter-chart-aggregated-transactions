// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionChart extends StatefulWidget {
  const TransactionChart({
    Key? key,
    this.width,
    this.height,
    this.chartTitle,
    required this.legend,
    required this.backgroundColor,
    this.titleColor,
    required this.transactionDataStream,
    required this.fillAreaBackground,
    required this.showXaxisLabels,
    required this.showYaxisLabels,
    required this.showGrid,
    required this.isGradient,
    this.backgroundColorSecondary,
    required this.showBorders,
    required this.aggregatePerMonth,
    required this.tooltipFillColor,
    required this.chartLineColor,
    required this.showToolTipLabel,
    required this.showXaxis, // Controls visibility of X-axis
    required this.showYaxis, // Controls visibility of Y-axis
    required this.showDataPoints, // Controls visibility of data point markers
    required this.dataPointFillColor, // Data point fill color
    required this.dataPointBorderColor, // Data point border color
    required this.tooltipTextColor, // New parameter for tooltip text color
    required this.tooltipTextSize,
    required this.tooltipTextFamily,
    required this.highlightedAxisLabelColor,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? chartTitle; // Optional chart title
  final bool legend;
  final Color backgroundColor;
  final Color? titleColor;
  final List<TransactionsRecord> transactionDataStream;
  final Color fillAreaBackground;
  final bool showXaxisLabels;
  final bool showYaxisLabels;
  final bool showGrid;
  final bool isGradient; // If true, applies gradient fill under the line
  final Color? backgroundColorSecondary; // Secondary color for gradient
  final bool showBorders; // Controls visibility of chart borders/frame
  final bool aggregatePerMonth; // If true, aggregates transactions per month
  final Color tooltipFillColor; // Fill color of the tooltip
  final Color chartLineColor; // Color of the chart line
  final bool showToolTipLabel; // Controls label visibility in tooltip
  final bool showXaxis; // Controls visibility of X-axis
  final bool showYaxis; // Controls visibility of Y-axis
  final bool showDataPoints; // Controls visibility of data point markers
  final Color dataPointFillColor; // Data point fill color
  final Color dataPointBorderColor; // Data point border color
  final Color tooltipTextColor; // Text color of the tooltip
  final double tooltipTextSize;
  final String tooltipTextFamily;
  final Color highlightedAxisLabelColor;

  @override
  _TransactionChartState createState() => _TransactionChartState();
}

class _ChartDataPoint {
  final DateTime x;
  final double y;

  _ChartDataPoint({
    required this.x,
    required this.y,
  });
}

class _TransactionChartState extends State<TransactionChart> {
  List<_ChartDataPoint> chartData = [];

  ValueNotifier<DateTime?> highlightedAxisValue =
      ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    super.initState();
    // Initialize chart data based on aggregation preference
    if (widget.aggregatePerMonth) {
      chartData = _aggregateTransactionsPerMonth(widget.transactionDataStream);
    } else {
      chartData = _processtransactionData(widget.transactionDataStream);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define fill gradient if isGradient is true
    LinearGradient? fillGradient;
    if (widget.isGradient && widget.backgroundColorSecondary != null) {
      fillGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          widget.fillAreaBackground,
          widget.backgroundColorSecondary!,
        ],
      );
    }

    return ValueListenableBuilder<DateTime?>(
      valueListenable: highlightedAxisValue,
      builder: (context, value, child) {
        return Center(
          child: SfCartesianChart(
            // Always provide a ChartTitle to avoid null error
            title: ChartTitle(
              text: widget.chartTitle ?? '',
              textStyle: widget.titleColor != null
                  ? TextStyle(color: widget.titleColor)
                  : null,
            ),
            legend: Legend(isVisible: widget.legend),
            backgroundColor: widget.backgroundColor,
            borderWidth: widget.showBorders ? 1.0 : 0.0,
            borderColor: widget.showBorders ? Colors.grey : Colors.transparent,
            // Remove inner borders
            plotAreaBorderWidth: widget.showBorders ? 1.0 : 0.0,
            plotAreaBorderColor:
                widget.showBorders ? Colors.grey : Colors.transparent,
            primaryXAxis: DateTimeAxis(
              isVisible: widget.showXaxis,
              // Added dateFormat to display only the month abbreviation
              dateFormat: DateFormat('MMM'),
              // Format X-axis labels
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                DateTime labelDate =
                    DateTime.fromMillisecondsSinceEpoch(args.value.toInt());
                TextStyle labelStyle = args.textStyle;

                if (value != null && _isSameMonth(labelDate, value)) {
                  labelStyle = labelStyle.copyWith(
                      color: widget.highlightedAxisLabelColor);
                }
                return widget.showXaxisLabels
                    ? ChartAxisLabel(args.text, labelStyle)
                    : ChartAxisLabel('', labelStyle);
              },
              axisLine: AxisLine(width: 0), // Hide the axis line
              majorGridLines:
                  widget.showGrid ? MajorGridLines() : MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              isVisible: widget.showYaxis,
              // Format Y-axis labels
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                return widget.showYaxisLabels
                    ? ChartAxisLabel(args.text, args.textStyle)
                    : ChartAxisLabel('', args.textStyle);
              },
              axisLine: AxisLine(width: 0), // Hide the axis line
              majorGridLines:
                  widget.showGrid ? MajorGridLines() : MajorGridLines(width: 0),
            ),
            series: <SplineAreaSeries<_ChartDataPoint, DateTime>>[
              SplineAreaSeries<_ChartDataPoint, DateTime>(
                enableTooltip: true,
                dataSource: chartData,
                xValueMapper: (_ChartDataPoint data, _) => data.x,
                yValueMapper: (_ChartDataPoint data, _) => data.y,
                markerSettings: MarkerSettings(
                  isVisible: widget.showDataPoints,
                  shape: DataMarkerType.circle,
                  color: widget.dataPointFillColor,
                  borderColor: widget.dataPointBorderColor,
                  borderWidth: 2,
                ),
                name: 'Payment Amount',
                dataLabelSettings: DataLabelSettings(isVisible: false),
                gradient: fillGradient,
                color: widget.fillAreaBackground,
                borderColor: widget.chartLineColor,
                borderWidth: 2,
              ),
            ],
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              shouldAlwaysShow:
                  true, 
              lineType: TrackballLineType.vertical,
              lineDashArray: [3, 3],
              lineWidth: 1,
              markerSettings: TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.visible,
                shape: DataMarkerType.circle,
                color: widget.dataPointFillColor,
                borderColor: widget.dataPointBorderColor,
                borderWidth: 2,
              ),
              tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
              tooltipSettings: InteractiveTooltip(
                borderRadius: 5.42,
                borderWidth: 0.5,
                canShowMarker: false,
                color: widget.tooltipFillColor,
                textStyle: TextStyle(
                  color: widget.tooltipTextColor,
                  fontSize: widget.tooltipTextSize,
                  fontFamily: widget.tooltipTextFamily,
                ),
                format: '£ point.y',
              ),
            ),
            onTrackballPositionChanging: (TrackballArgs args) {
              int? index = args.chartPointInfo.dataPointIndex;
              if (index != null && index >= 0 && index < chartData.length) {
                highlightedAxisValue.value = chartData[index].x;
              } else {
                highlightedAxisValue.value = null;
              }
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    highlightedAxisValue.dispose();
    super.dispose();
  }

  List<_ChartDataPoint> _aggregateTransactionsPerMonth(
      List<TransactionsRecord> transactions) {
    Map<String, double> monthlyTotals = {};

    for (var transaction in transactions) {
      double amount = transaction.amount?.toDouble() ?? 0.0;
      DateTime createdAt = transaction.createdAt ?? DateTime.now();
      String monthKey = DateFormat("MMM yyyy").format(createdAt);
      
      // Aggregate amounts per month
      monthlyTotals.update(
        monthKey,
        (existingAmount) => existingAmount + amount,
        ifAbsent: () => amount,
      );
    }

    // Convert to list of _ChartDataPoint
    List<_ChartDataPoint> dataPoints = [];
    monthlyTotals.forEach((monthKey, totalAmount) {
      // Parse monthKey back to DateTime with year
      DateTime date = DateFormat("MMM yyyy").parse(monthKey);
      dataPoints.add(_ChartDataPoint(x: date, y: totalAmount));
    });

    dataPoints.sort((a, b) => a.x.compareTo(b.x));

    return dataPoints;
  }

  // Processes transactions data without aggregation
  List<_ChartDataPoint> _processtransactionData(
      List<TransactionsRecord> transactions) {
    List<_ChartDataPoint> dataPoints = [];
    for (var transaction in transactions) {
      DateTime createdAt = transaction.createdAt ?? DateTime.now();
      double amount = transaction.amount?.toDouble() ?? 0.0;
      dataPoints.add(_ChartDataPoint(x: createdAt, y: amount));
    }

    // Sort data points by date
    dataPoints.sort((a, b) => a.x.compareTo(b.x));

    return dataPoints;
  }

  // Helper method to compare dates
  bool _isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }
}
