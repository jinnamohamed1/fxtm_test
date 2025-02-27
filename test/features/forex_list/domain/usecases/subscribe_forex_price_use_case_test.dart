import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/data/repositories/forex_price_repository_impl.dart';
import 'package:fxtm_test_app/features/forex_list/domain/entities/forex_price_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/subscribe_forex_price_use_case.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('SubscribeForexPriceUseCase', () {
    late ForexPriceRepository mockRepository;
    late SubscribeForexPriceUseCase useCase;

    setUp(() {
      mockRepository = MockForexPriceRepository();
      useCase = SubscribeForexPriceUseCaseImpl(repository: mockRepository);
    });

    test('should subscribe to forex prices', () async {
      // Arrange
      final symbols = [
        const ForexSymbolModel(
            symbol: 'OANDA:EUR/USD',
            description: 'Euro / US Dollar',
            displaySymbol: 'EUR/USD'),
      ];
      final forexPriceMap = {
        'EUR/USD': const ForexPrice(symbol: 'EUR/USD', price: 0.0)
      };
      final stream = Stream.value(forexPriceMap);
      when(() => mockRepository.subscribeToForexPrice(symbols: symbols))
          .thenAnswer((_) => stream);

      // Act
      final resultStream = useCase(symbols);

      // Assert
      expectLater(resultStream, emits(forexPriceMap));
      verify(() => mockRepository.subscribeToForexPrice(symbols: symbols))
          .called(1);
    });
  });
}

class MockForexPriceRepository extends Mock implements ForexPriceRepository {}
