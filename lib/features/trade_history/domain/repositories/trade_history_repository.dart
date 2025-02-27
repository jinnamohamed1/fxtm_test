import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';

abstract class TradeHistoryRepository {
  Future<List<ForexCandleModel>> fetchHistoricalData({
    required String symbol,
    required int fromTimeStamp,
    required int toTimeStamp,
    required String resoultion,
  });
}
