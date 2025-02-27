import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:fxtm_test_app/features/trade_history/domain/repositories/trade_history_repository.dart';
import 'package:fxtm_test_app/features/trade_history/domain/usecases/get_trade_history_data_use_case.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GetTradeHistoryDataUseCase getHistoricalDataUseCase;
  late TradeHistoryRepository repository;

  setUp(() {
    repository = MockTradeHistoryRepository();
    getHistoricalDataUseCase =
        GetTradeHistoryDataUseCaseImpl(repository: repository);
  });
  test(
      'getHistoricalDataUseCase should call fetchHistoricalData in TradeHistoryRepository',
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
    when(() => repository.fetchHistoricalData(
          symbol: 'symbol',
          fromTimeStamp: 12345678,
          toTimeStamp: 12345678,
          resoultion: 'D',
        )).thenAnswer((_) async => expected);

// act
    final actual = await getHistoricalDataUseCase(
      symbol: 'symbol',
      fromTimeStamp: 12345678,
      toTimeStamp: 12345678,
      resoultion: 'D',
    );

// assert
    verify(() => repository.fetchHistoricalData(
          symbol: 'symbol',
          fromTimeStamp: 12345678,
          toTimeStamp: 12345678,
          resoultion: 'D',
        )).called(1);
    expect(actual, expected);
  });
}

class MockTradeHistoryRepository extends Mock
    implements TradeHistoryRepository {}
