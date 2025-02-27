import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/core/api_client/api_client_config.dart';
import 'package:fxtm_test_app/features/forex_list/data/datasource/remote/forex_price_socket_data_source.dart';
import 'package:fxtm_test_app/features/forex_list/data/datasource/remote/forex_symbols_remote_data_source.dart';
import 'package:fxtm_test_app/features/forex_list/data/repositories/forex_price_repository_impl.dart';
import 'package:fxtm_test_app/features/forex_list/data/repositories/forex_symbols_repository_impl.dart';
import 'package:fxtm_test_app/features/forex_list/domain/repositories/forex_symbols_repository.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/get_forex_symbols_use_case.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/subscribe_forex_price_use_case.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_bloc.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/mappers/forex_price_display_mapper.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupForexListDependencies() {
  // Register the dependencies
  // Remote Data Source
  getIt.registerFactory<ForexSymbolsRemoteDataSource>(
      () => ForexSymbolsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));
  getIt.registerFactory<ForexPriceSocketDataSource>(() =>
      ForexPriceSocketDataSourceImpl(
          baseSocketUrl: ApiClientConfig.webSocketUrl,
          token: ApiClientConfig.apiToken));
  // Repository
  getIt.registerFactory<ForexSymbolsRepository>(() =>
      ForexSymbolsRepositoryImpl(
          remoteDataSource: getIt<ForexSymbolsRemoteDataSource>()));
  getIt.registerFactory<ForexPriceRepository>(() => ForexPriceRepositoryImpl(
      dataSource: getIt<ForexPriceSocketDataSource>()));
  // Use Cases
  getIt.registerFactory<GetForexSymbolsUseCase>(() =>
      GetForexSymbolsUseCaseImpl(repository: getIt<ForexSymbolsRepository>()));
  getIt.registerFactory<SubscribeForexPriceUseCase>(
      () => SubscribeForexPriceUseCaseImpl(
            repository: getIt<ForexPriceRepository>(),
          ));
  // Mappers
  getIt.registerFactory<ForexPriceDisplayMapper>(
      () => ForexPriceDisplayMapperImpl());

  // Bloc
  getIt.registerFactory<ForexListBloc>(() => ForexListBloc(
        getForexSymbolsUseCase: getIt<GetForexSymbolsUseCase>(),
        subscribeForexPriceUseCase: getIt<SubscribeForexPriceUseCase>(),
        forexPriceDisplayMapper: getIt<ForexPriceDisplayMapper>(),
      ));
}
