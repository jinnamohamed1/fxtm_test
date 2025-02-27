import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/core/api_client/api_response.dart';
import 'package:fxtm_test_app/features/trade_history/data/datasource/remote/trade_history_remote_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late TradeHistoryRemoteDataSource dataSource;
  late ApiClient apiClient;

  setUp(() {
    apiClient = MockApiClient();
    dataSource = TradeHistoryRemoteDataSourceImpl(apiClient: apiClient);
  });
  test('fetchHistoricalData calls API and returns successful response',
      () async {
    // Arrange
    final candleResponse = [
      {
        "c": 1.0,
        "h": 1.0,
        "l": 1.0,
        "o": 1.0,
        "s": "status",
        "t": 11111111,
        "v": 1,
      }
    ];
    when(() => apiClient.get<List<dynamic>>(
            path: '/forex/candle',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => ApiResponse(data: candleResponse));
    final expected =
        candleResponse.map((json) => ForexCandleModel.fromJson(json)).toList();
    // Act
    final forexCandles = await dataSource.fetchHistoricalData(
      symbol: 'symbol',
      fromTimeStamp: 11111111,
      toTimeStamp: 11111111,
      resoultion: 'D',
    );

    // Assert
    expect(forexCandles, expected);
  });

  test('fetchHistoricalData calls API and returns error response', () async {
    // Arrange
    when(() => apiClient.get<List<dynamic>>(
            path: '/forex/candle',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => ApiResponse(error: 'error'));

    // Act
    final call = dataSource.fetchHistoricalData(
      symbol: 'symbol',
      fromTimeStamp: 11111111,
      toTimeStamp: 11111111,
      resoultion: 'D',
    );

    // Assert
    expect(() => call, throwsException);
  });
}

class MockApiClient extends Mock implements ApiClient {}
