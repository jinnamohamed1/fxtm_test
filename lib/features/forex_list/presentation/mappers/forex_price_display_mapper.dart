import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/entities/forex_price_model.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/models/forex_price_display_model.dart';

abstract class ForexPriceDisplayMapper {
  List<ForexPriceDisplayModel> map({
    required List<ForexSymbolModel> symbols,
    Map<String, ForexPrice>? forexPriceMap,
  });
}

class ForexPriceDisplayMapperImpl implements ForexPriceDisplayMapper {
  @override
  List<ForexPriceDisplayModel> map({
    required List<ForexSymbolModel> symbols,
    Map<String, ForexPrice>? forexPriceMap,
  }) {
    return symbols.map((symbolModel) {
      final price =
          forexPriceMap?[symbolModel.symbol]?.price.toStringAsFixed(2) ?? '0.0';
      return ForexPriceDisplayModel(
        symbol: symbolModel.symbol,
        displaySymbol: symbolModel.displaySymbol,
        description: symbolModel.description,
        price: price,
      );
    }).toList();
  }
}
