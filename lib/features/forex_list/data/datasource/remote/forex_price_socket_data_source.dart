import 'dart:async';
import 'dart:convert';

import 'package:fxtm_test_app/features/forex_list/data/models/trade/forex_trade_model.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ForexPriceSocketDataSource {
  Future<void> subscribeToSymbol(String symbol);
  Stream<ForexTradeResponse?> get priceUpdates;
  void close();
}

class ForexPriceSocketDataSourceImpl implements ForexPriceSocketDataSource {
  static const int _maxReconnectAttempts = 5;
  static const Duration _initialReconnectDelay = Duration(seconds: 1);
  static const String _subscribeType = 'subscribe';

  WebSocketChannel? _channel;
  final List<String> _subscribedSymbols = [];
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;
  bool _isClosedIntentionally = false;

  final String _baseSocketUrl;
  final String _token;

  final StreamController<ForexTradeResponse?> _priceStreamController =
      StreamController.broadcast();

  ForexPriceSocketDataSourceImpl(
      {required String baseSocketUrl, required String token})
      : _baseSocketUrl = baseSocketUrl,
        _token = token;

  @override
  Future<void> subscribeToSymbol(String symbol) async {
    if (!_subscribedSymbols.contains(symbol)) {
      _subscribedSymbols.add(symbol);
    }
    await _initializeWebSocketIfNeeded();
    _subscribeSymbol(symbol);
  }

  @override
  Stream<ForexTradeResponse?> get priceUpdates => _priceStreamController.stream;

  Future<void> _initializeWebSocketIfNeeded() async {
    if (_channel != null) return;
    _isClosedIntentionally = false;
    final socketUrl = '$_baseSocketUrl?token=$_token';
    try {
      _channel = WebSocketChannel.connect(Uri.parse(socketUrl));

      _channel?.stream.listen((message) {
        _reconnectAttempts = 0;
        final tradeResponse = _parseMessage(message);
        if (tradeResponse != null) {
          _priceStreamController.add(tradeResponse);
        }
      }, onDone: () {
        if (_isClosedIntentionally) {
          _attemptReconnect();
        }
      }, onError: (error) {
        _priceStreamController.addError(error);
        if (_isClosedIntentionally) {
          _attemptReconnect();
        }
      });
      for (final symbol in _subscribedSymbols) {
        _subscribeSymbol(symbol);
      }
    } catch (e) {
      _priceStreamController.addError(e);
      if (!_isClosedIntentionally) {
        _attemptReconnect();
      }
    }
  }

  void _attemptReconnect() {
    _channel = null;
    if (_reconnectAttempts >= _maxReconnectAttempts || _isClosedIntentionally) {
      return;
    }
    final delay = _initialReconnectDelay * (1 << _reconnectAttempts);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      _reconnectAttempts++;
      await _initializeWebSocketIfNeeded();
    });
  }

  ForexTradeResponse? _parseMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      if (data is! Map<String, dynamic>) return null;
      return ForexTradeResponse.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  void _subscribeSymbol(String symbol) {
    _channel?.sink.add(jsonEncode({"type": _subscribeType, "symbol": symbol}));
  }

  @override
  void close() {
    _isClosedIntentionally = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channel?.sink.close(status.goingAway);
    _channel = null;
    _priceStreamController.close();
  }
}
