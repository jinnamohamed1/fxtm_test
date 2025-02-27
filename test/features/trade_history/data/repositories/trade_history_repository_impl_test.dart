import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/trade_history/data/datasource/local/trade_history_local_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/datasource/remote/trade_history_remote_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:fxtm_test_app/features/trade_history/data/repositories/trade_history_repository_impl.dart';
import 'package:fxtm_test_app/features/trade_history/domain/repositories/trade_history_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late TradeHistoryRemoteDataSource remoteDataSource;
  late TradeHistoryLocalDataSource localDataSource;
  late TradeHistoryRepository repository;
  setUp(() {
    remoteDataSource = MockTradeHistoryRemoteDataSource();
    localDataSource = MockTradeHistoryLocalDataSource();
    repository = TradeHistoryRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });
  test('fetchHistoricalData should call fetchHistoricalData remote datasource',
      () async {
    // arrange
    const expected = [
      ForexCandleModel(
          close: 1.0,
          high: 1.0,
          low: 1.0,
          open: 1.0,
          status: 'ok',
          timestamp: 12345678,
          volume: 123456)
    ];
    when(() => remoteDataSource.fetchHistoricalData(
          symbol: 'symbol',
          fromTimeStamp: 12345678,
          toTimeStamp: 12345678,
          resoultion: 'D',
        )).thenAnswer((_) async => expected);
    final actual = await repository.fetchHistoricalData(
      symbol: 'symbol',
      fromTimeStamp: 12345678,
      toTimeStamp: 12345678,
      resoultion: 'D',
    );

    // assert
    verify(() => remoteDataSource.fetchHistoricalData(
          symbol: 'symbol',
          fromTimeStamp: 12345678,
          toTimeStamp: 12345678,
          resoultion: 'D',
        )).called(1);
    expect(actual, expected);
  });
}

class MockTradeHistoryLocalDataSource extends Mock
    implements TradeHistoryLocalDataSource {}

class MockTradeHistoryRemoteDataSource extends Mock
    implements TradeHistoryRemoteDataSource {}
