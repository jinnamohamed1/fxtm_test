import 'package:dio/dio.dart';
import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/core/api_client/api_client_config.dart';
import 'package:fxtm_test_app/core/api_client/api_client_impl.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
void setUpCoreDependencies() async {
  // Register the dependencies
  // Dio
  getIt.registerSingleton<Dio>(Dio());

  // Api Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClientImpl(
        client: getIt<Dio>(),
        baseUrl: ApiClientConfig.baseUrl,
        apiKeyToken: ApiClientConfig.apiToken,
      ));
}
