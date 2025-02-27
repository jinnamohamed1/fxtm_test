import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/core/api_client/api_response.dart';
import 'package:fxtm_test_app/features/forex_list/data/datasource/remote/forex_symbols_remote_data_source.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ApiClient apiClient;
  late ForexSymbolsRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockApiClient();
    dataSource = ForexSymbolsRemoteDataSourceImpl(apiClient: apiClient);
  });

  test(
      'calling fetchForexSymbols with an empty exchange value should throw exception',
      () async {
    // Arrange
    const exchange = '';
    // Act
    // Assert
    expect(
      () async => await dataSource.fetchForexSymbols(exchange: exchange),
      throwsA(
        predicate((e) =>
            e is Exception &&
            e.toString() == 'Exception: Exchange cannot be empty'),
      ),
    );
  });

  test('calling fetchForexSymbols should return a list of ForexSymbolModel',
      () async {
    // Arrange
    const exchange = 'exchange';
    final response = [
      {
        "symbol": "symbol",
        "description": "description",
        "displaySymbol": "displaySymbol",
      },
    ];
    final expected =
        response.map((json) => ForexSymbolModel.fromJson(json)).toList();
    when(() => apiClient.get<List<dynamic>>(
            path: '/forex/symbol',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => ApiResponse(data: response, error: null));
    // Act
    final result = await dataSource.fetchForexSymbols(exchange: exchange);
    // Assert
    expect(result, expected);
  });

  test('calling fetchForexSymbols should throw exception if response is null',
      () async {
    // Arrange
    const exchange = 'exchange';
    when(() => apiClient.get<List<dynamic>>(
            path: '/forex/symbol',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => ApiResponse(data: null, error: 'error'));
    // Act
    // Assert
    expect(
      () async => await dataSource.fetchForexSymbols(exchange: exchange),
      throwsA(
        predicate((e) => e is Exception && e.toString() == 'Exception: error'),
      ),
    );
  });
}

class MockApiClient extends Mock implements ApiClient {}
