import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/forex_list/data/datasource/remote/forex_symbols_remote_data_source.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/data/repositories/forex_symbols_repository_impl.dart';
import 'package:fxtm_test_app/features/forex_list/domain/repositories/forex_symbols_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ForexSymbolsRemoteDataSource dataSource;
  late ForexSymbolsRepository repository;

  setUp(() {
    dataSource = MockForexSymbolsRemoteDataSource();
    repository = ForexSymbolsRepositoryImpl(remoteDataSource: dataSource);
  });
  group('ForexSymbolsRepository', () {
    test('should return a list of ForexSymbolModel', () async {
      // Arrange
      const forexSymbolsList = [
        ForexSymbolModel(
          symbol: 'symbol',
          description: 'description',
          displaySymbol: 'displaySymbol',
        ),
      ];
      when(() => dataSource.fetchForexSymbols(exchange: 'exchange'))
          .thenAnswer((_) async => forexSymbolsList);
      // Act
      final result = await repository.fetchForexSymbols(exchange: 'exchange');
      // Assert
      expect(result, forexSymbolsList);
    });
  });
}

class MockForexSymbolsRemoteDataSource extends Mock
    implements ForexSymbolsRemoteDataSource {}
