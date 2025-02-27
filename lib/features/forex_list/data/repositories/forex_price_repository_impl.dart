import 'dart:async';

import 'package:fxtm_test_app/core/errors/error_mapper.dart';
import 'package:fxtm_test_app/features/forex_list/data/datasource/remote/forex_price_socket_data_source.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/entities/forex_price_model.dart';

abstract class ForexPriceRepository {
  Stream<Map<String, ForexPrice>> subscribeToForexPrice(
      {required List<ForexSymbolModel> symbols});
  void dispose();
}

class ForexPriceRepositoryImpl implements ForexPriceRepository {
  final ForexPriceSocketDataSource _dataSource;
  ForexPriceRepositoryImpl({required ForexPriceSocketDataSource dataSource})
      : _dataSource = dataSource;

  final StreamController<Map<String, ForexPrice>> _priceMapStreamController =
      StreamController<Map<String, ForexPrice>>.broadcast();
  StreamSubscription? _socketSubscription;

  // Accumulated prices map
  final Map<String, ForexPrice> _accumulatedPrices = {};

  Timer? _throttleTimer;
  bool _hasPendingUpdates = false;
  static const Duration _throttleDuration = Duration(milliseconds: 100);

  @override
  Stream<Map<String, ForexPrice>> subscribeToForexPrice(
      {required List<ForexSymbolModel> symbols}) async* {
    try {
      for (var symbolModel in symbols) {
        // Initialize with 0.0
        _accumulatedPrices[symbolModel.symbol] =
            ForexPrice(symbol: symbolModel.symbol, price: 0.0);
        await _dataSource.subscribeToSymbol(symbolModel.symbol);
      }

      _priceMapStreamController.add(Map.from(_accumulatedPrices));

      _socketSubscription = _dataSource.priceUpdates.listen((response) {
        if (response != null && response.type == 'trade') {
          bool updatedAny = false;

          for (var forexTradeData in response.data) {
            final forexPrice = ForexPrice(
                symbol: forexTradeData.symbol, price: forexTradeData.price);
            // Update the accumulated prices map
            _accumulatedPrices[forexTradeData.symbol] = forexPrice;
            updatedAny = true;
          }
          if (updatedAny) {
            _throttleLimit();
          }
        }
      }, onError: (error) {
        final appError = ErrorMapper.mapToAppException(error);
        _priceMapStreamController.addError(appError);
      });
      yield* _priceMapStreamController.stream;
    } catch (e) {
      throw ErrorMapper.mapToAppException(e);
    }
  }

  void _throttleLimit() {
    _hasPendingUpdates = true;
    if (_throttleTimer?.isActive != true) {
      _throttleTimer = Timer(_throttleDuration, () {
        if (_hasPendingUpdates) {
          _priceMapStreamController.add(Map.from(_accumulatedPrices));
          _hasPendingUpdates = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    _throttleTimer?.cancel();
    _priceMapStreamController.close();
    _dataSource.close();
  }
}
