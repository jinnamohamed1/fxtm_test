import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';

class TradeHistoryModel {
  final String symbol;
  final List<ForexCandleModel> candles;

  TradeHistoryModel({required this.symbol, required this.candles});
}
