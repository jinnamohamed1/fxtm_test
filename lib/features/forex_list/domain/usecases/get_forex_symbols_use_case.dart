import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/repositories/forex_symbols_repository.dart';

abstract class GetForexSymbolsUseCase {
  Future<List<ForexSymbolModel>> call({required String exchange});
}

class GetForexSymbolsUseCaseImpl implements GetForexSymbolsUseCase {
  late final ForexSymbolsRepository _repository;

  GetForexSymbolsUseCaseImpl({required ForexSymbolsRepository repository}) {
    _repository = repository;
  }

  @override
  Future<List<ForexSymbolModel>> call({required String exchange}) async {
    return await _repository.fetchForexSymbols(exchange: exchange);
  }
}
