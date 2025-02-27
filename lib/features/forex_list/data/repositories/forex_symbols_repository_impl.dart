import 'package:fxtm_test_app/features/forex_list/data/datasource/remote/forex_symbols_remote_data_source.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/repositories/forex_symbols_repository.dart';

class ForexSymbolsRepositoryImpl implements ForexSymbolsRepository {
  final ForexSymbolsRemoteDataSource _remoteDataSource;

  ForexSymbolsRepositoryImpl(
      {required ForexSymbolsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ForexSymbolModel>> fetchForexSymbols(
      {required String exchange}) async {
    return await _remoteDataSource.fetchForexSymbols(exchange: exchange);
  }
}
