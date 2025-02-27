import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/data/repositories/forex_price_repository_impl.dart';
import 'package:fxtm_test_app/features/forex_list/domain/entities/forex_price_model.dart';

abstract class SubscribeForexPriceUseCase {
  Stream<Map<String, ForexPrice>> call(List<ForexSymbolModel> symbols);
}

class SubscribeForexPriceUseCaseImpl implements SubscribeForexPriceUseCase {
  final ForexPriceRepository _repository;

  SubscribeForexPriceUseCaseImpl({required ForexPriceRepository repository})
      : _repository = repository;

  @override
  Stream<Map<String, ForexPrice>> call(List<ForexSymbolModel> symbols) {
    return _repository.subscribeToForexPrice(symbols: symbols);
  }
}
