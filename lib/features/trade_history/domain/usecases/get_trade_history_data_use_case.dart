import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:fxtm_test_app/features/trade_history/domain/repositories/trade_history_repository.dart';

abstract class GetTradeHistoryDataUseCase {
  Future<List<ForexCandleModel>> call({
    required String symbol,
    required int fromTimeStamp,
    required int toTimeStamp,
    required String resoultion,
  });
}

class GetTradeHistoryDataUseCaseImpl implements GetTradeHistoryDataUseCase {
  final TradeHistoryRepository _repository;
  GetTradeHistoryDataUseCaseImpl({required TradeHistoryRepository repository})
      : _repository = repository;
  @override
  Future<List<ForexCandleModel>> call({
    required String symbol,
    required int fromTimeStamp,
    required int toTimeStamp,
    required String resoultion,
  }) async {
    return _repository.fetchHistoricalData(
        symbol: symbol,
        fromTimeStamp: fromTimeStamp,
        toTimeStamp: toTimeStamp,
        resoultion: resoultion);
  }
}
