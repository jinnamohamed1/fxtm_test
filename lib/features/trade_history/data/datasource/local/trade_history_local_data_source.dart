import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';

abstract class TradeHistoryLocalDataSource {
  Future<List<ForexCandleModel>> fetchHistoricalData();
}

class TradeHistoryLocalDataSourceImpl implements TradeHistoryLocalDataSource {
  @override
  Future<List<ForexCandleModel>> fetchHistoricalData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/candle_data.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      return List.generate(
        jsonData["t"].length,
        (i) => ForexCandleModel.fromJson({
          "c": jsonData["c"][i],
          "h": jsonData["h"][i],
          "l": jsonData["l"][i],
          "o": jsonData["o"][i],
          "t": jsonData["t"][i],
          "v": jsonData["v"][i],
          "s": 'ok',
        }),
      );
    } catch (e) {
      throw Exception("Failed to load candle data: $e");
    }
  }
}
