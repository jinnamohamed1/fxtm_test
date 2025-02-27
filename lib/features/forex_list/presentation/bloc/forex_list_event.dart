import 'package:equatable/equatable.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';

sealed class ForexListEvent extends Equatable {}

class ForexListLoadEvent extends ForexListEvent {
  final String exchange;
  ForexListLoadEvent({required this.exchange});

  @override
  List<Object?> get props => [exchange];
}

class ForexListPriceSubscribeEvent extends ForexListEvent {
  final List<ForexSymbolModel> symbols;
  ForexListPriceSubscribeEvent({required this.symbols});

  @override
  List<Object?> get props => [symbols];
}

class ForexListRefreshEvent extends ForexListEvent {
  final String exchange;
  ForexListRefreshEvent({required this.exchange});

  @override
  List<Object?> get props => [exchange];
}
