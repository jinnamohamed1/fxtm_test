import 'package:flutter/material.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/models/trade_history_model.dart';
import 'package:interactive_chart/interactive_chart.dart';

class TradeHistoryLoadedWidget extends StatelessWidget {
  final TradeHistoryModel _tradeHistoryModel;
  const TradeHistoryLoadedWidget(
      {super.key, required TradeHistoryModel tradeHistoryModel})
      : _tradeHistoryModel = tradeHistoryModel;

  @override
  Widget build(BuildContext context) {
    final candles = _tradeHistoryModel.candles;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: candles.isEmpty
          ? const Center(child: Text("No trade data available"))
          : InteractiveChart(
              candles: candles
                  .map(
                    (candle) => CandleData(
                      open: candle.open,
                      high: candle.high,
                      low: candle.low,
                      close: candle.close,
                      volume: candle.volume,
                      timestamp: candle.timestamp,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
