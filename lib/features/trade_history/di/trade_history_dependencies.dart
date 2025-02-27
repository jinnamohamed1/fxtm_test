import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/features/trade_history/data/datasource/local/trade_history_local_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/datasource/remote/trade_history_remote_data_source.dart';
import 'package:fxtm_test_app/features/trade_history/data/repositories/trade_history_repository_impl.dart';
import 'package:fxtm_test_app/features/trade_history/domain/repositories/trade_history_repository.dart';
import 'package:fxtm_test_app/features/trade_history/domain/usecases/get_trade_history_data_use_case.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupTradeHistoryDependencies() {
  // Register the dependencies
  // Remote Data Source
  getIt.registerFactory<TradeHistoryRemoteDataSource>(
      () => TradeHistoryRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));
  // Local Data Source
  getIt.registerFactory<TradeHistoryLocalDataSource>(
      () => TradeHistoryLocalDataSourceImpl());
  // Repository
  getIt
      .registerFactory<TradeHistoryRepository>(() => TradeHistoryRepositoryImpl(
            remoteDataSource: getIt<TradeHistoryRemoteDataSource>(),
            localDataSource: getIt<TradeHistoryLocalDataSource>(),
          ));
  // Use Cases
  getIt.registerFactory<GetTradeHistoryDataUseCase>(() =>
      GetTradeHistoryDataUseCaseImpl(
          repository: getIt<TradeHistoryRepository>()));
  // Bloc
  getIt.registerFactory<TradeHistoryBloc>(() => TradeHistoryBloc(
      getCandleDataUseCase: getIt<GetTradeHistoryDataUseCase>()));
}
