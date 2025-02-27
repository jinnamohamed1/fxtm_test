import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/models/trade_history_model.dart';

abstract class TradeHistoryModelMapper {
  TradeHistoryModel map(String symbol, List<ForexCandleModel> candles);
}

class TradeHistoryModelMapperImpl implements TradeHistoryModelMapper {
  @override
  TradeHistoryModel map(String symbol, List<ForexCandleModel> candles) {
    return TradeHistoryModel(symbol: symbol, candles: candles);
  }
}
