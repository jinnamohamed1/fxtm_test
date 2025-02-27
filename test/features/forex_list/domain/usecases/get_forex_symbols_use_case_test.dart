import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/repositories/forex_symbols_repository.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/get_forex_symbols_use_case.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ForexSymbolsRepository repository;
  late GetForexSymbolsUseCase useCase;

  setUp(() {
    repository = MockForexSymbolsRepository();
    useCase = GetForexSymbolsUseCaseImpl(repository: repository);
  });

  group('GetForexSymbolsUseCase', () {
    test('should return a list of ForexSymbolModel', () async {
      // Arrange
      const forexSymbolsList = [
        ForexSymbolModel(
          symbol: 'symbol',
          description: 'description',
          displaySymbol: 'displaySymbol',
        ),
      ];
      when(() => repository.fetchForexSymbols(exchange: 'exchange'))
          .thenAnswer((_) async => forexSymbolsList);
      // Act
      final result = await useCase(exchange: 'exchange');
      // Assert
      expect(result, forexSymbolsList);
    });
  });
}

class MockForexSymbolsRepository extends Mock
    implements ForexSymbolsRepository {}
