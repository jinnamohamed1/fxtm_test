import 'package:fxtm_test_app/features/trade_history/data/datasource/local/trade_history_local_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/datasource/remote/trade_history_remote_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:fxtm_test_app/features/trade_history/domain/repositories/trade_history_repository.dart';

class TradeHistoryRepositoryImpl implements TradeHistoryRepository {
  final TradeHistoryRemoteDataSource _remoteDataSource;
  final TradeHistoryLocalDataSource _localDataSource;

  TradeHistoryRepositoryImpl({
    required TradeHistoryRemoteDataSource remoteDataSource,
    required TradeHistoryLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<ForexCandleModel>> fetchHistoricalData({
    required String symbol,
    required int fromTimeStamp,
    required int toTimeStamp,
    required String resoultion,
  }) async {
    try {
      return await _remoteDataSource.fetchHistoricalData(
        symbol: symbol,
        fromTimeStamp: fromTimeStamp,
        toTimeStamp: toTimeStamp,
        resoultion: resoultion,
      );
    } catch (e) {
      return await _localDataSource.fetchHistoricalData();
    }
  }
}
