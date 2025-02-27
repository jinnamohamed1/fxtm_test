import 'package:fxtm_test_app/core/api_client/api_client.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';

abstract class TradeHistoryRemoteDataSource {
  Future<List<ForexCandleModel>> fetchHistoricalData({
    required String symbol,
    required int fromTimeStamp,
    required int toTimeStamp,
    required String resoultion,
  });
}

class TradeHistoryRemoteDataSourceImpl implements TradeHistoryRemoteDataSource {
  final ApiClient _apiClient;

  TradeHistoryRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<ForexCandleModel>> fetchHistoricalData({
    required String symbol,
    required int fromTimeStamp,
    required int toTimeStamp,
    required String resoultion,
  }) async {
    final response = await _apiClient.get<List<dynamic>>(
      path: "/forex/candle",
      queryParameters: {
        "symbol": symbol,
        "from": fromTimeStamp,
        "to": toTimeStamp,
        "resolution": resoultion,
      },
    );
    final responseData = response.data;
    if (responseData != null) {
      return responseData
          .map((json) => ForexCandleModel.fromJson(json))
          .toList();
    } else {
      throw Exception(response.error);
    }
  }
}
