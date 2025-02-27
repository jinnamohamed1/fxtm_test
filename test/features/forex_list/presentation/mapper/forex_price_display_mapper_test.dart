import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/entities/forex_price_model.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/mappers/forex_price_display_mapper.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/models/forex_price_display_model.dart';

void main() {
  group('ForexPriceDisplayMapper', () {
    late ForexPriceDisplayMapper mapper;

    setUp(() {
      mapper = ForexPriceDisplayMapperImpl();
    });

    test('should map symbols to display models without forexPriceMap', () {
      // Arrange
      final symbols = [
        const ForexSymbolModel(
          symbol: 'OANDA:EUR/USD',
          description: 'Euro / US Dollar',
          displaySymbol: 'EUR/USD',
        ),
        const ForexSymbolModel(
          symbol: 'OANDA:GBP/USD',
          description: 'British Pound / US Dollar',
          displaySymbol: 'GBP/USD',
        ),
      ];
      // Act
      final displayModels = mapper.map(symbols: symbols);

      // Assert
      expect(displayModels, [
        const ForexPriceDisplayModel(
          symbol: 'OANDA:EUR/USD',
          displaySymbol: 'EUR/USD',
          price: '0.0',
          description: 'Euro / US Dollar',
        ),
        const ForexPriceDisplayModel(
          symbol: 'OANDA:GBP/USD',
          displaySymbol: 'GBP/USD',
          price: '0.0',
          description: 'British Pound / US Dollar',
        ),
      ]);
    });

    test('should map symbols to display models with forexPriceMap', () {
      // Arrange
      final symbols = [
        const ForexSymbolModel(
          symbol: 'OANDA:EUR/USD',
          description: 'Euro / US Dollar',
          displaySymbol: 'EUR/USD',
        ),
        const ForexSymbolModel(
          symbol: 'OANDA:GBP/USD',
          description: 'British Pound / US Dollar',
          displaySymbol: 'GBP/USD',
        ),
      ];

      final forexPriceMap = {
        "OANDA:EUR/USD":
            const ForexPrice(symbol: "OANDA:EUR/USD", price: 1.2345),
        "OANDA:GBP/USD":
            const ForexPrice(symbol: "OANDA:GBP/USD", price: 1.5678),
      };

      // Act
      final displayModels = mapper.map(
        symbols: symbols,
        forexPriceMap: forexPriceMap,
      );

      // Assert
      expect(displayModels, [
        const ForexPriceDisplayModel(
          symbol: 'OANDA:EUR/USD',
          displaySymbol: 'EUR/USD',
          price: '1.23',
          description: 'Euro / US Dollar',
        ),
        const ForexPriceDisplayModel(
          symbol: 'OANDA:GBP/USD',
          displaySymbol: 'GBP/USD',
          price: '1.57',
          description: 'British Pound / US Dollar',
        ),
      ]);
    });
    test('should return empty list when given an empty symbol list', () {
      // Act
      final result = mapper.map(symbols: []);

      // Assert
      expect(result, isEmpty);
    });
  });
}
