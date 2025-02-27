import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';

abstract class ForexSymbolsRepository {
  Future<List<ForexSymbolModel>> fetchForexSymbols({required String exchange});
}
