import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm_test_app/core/errors/exceptions.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/get_forex_symbols_use_case.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/subscribe_forex_price_use_case.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_event.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_state.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/mappers/forex_price_display_mapper.dart';

class ForexListBloc extends Bloc<ForexListEvent, ForexListState> {
  final GetForexSymbolsUseCase _getForexSymbolsUseCase;
  final SubscribeForexPriceUseCase _subscribeForexPriceUseCase;
  final ForexPriceDisplayMapper _forexPriceDisplayMapper;

  ForexListBloc({
    required GetForexSymbolsUseCase getForexSymbolsUseCase,
    required SubscribeForexPriceUseCase subscribeForexPriceUseCase,
    required ForexPriceDisplayMapper forexPriceDisplayMapper,
  })  : _getForexSymbolsUseCase = getForexSymbolsUseCase,
        _subscribeForexPriceUseCase = subscribeForexPriceUseCase,
        _forexPriceDisplayMapper = forexPriceDisplayMapper,
        super(ForexListLoadingState()) {
    on<ForexListLoadEvent>(_onForexListLoadEvent);
    on<ForexListPriceSubscribeEvent>(_onForexListPriceSubscribeEvent);
    on<ForexListRefreshEvent>(_onForexListRefreshEvent);
  }

  FutureOr<void> _onForexListLoadEvent(
    ForexListLoadEvent event,
    Emitter<ForexListState> emit,
  ) async {
    emit(ForexListLoadingState());
    try {
      final symbols = await _getForexSymbolsUseCase(exchange: event.exchange);
      final forexDisplayModels = _forexPriceDisplayMapper.map(symbols: symbols);
      emit(ForexListLoadedState(forexDisplayModels));

      add(ForexListPriceSubscribeEvent(symbols: symbols));
    } on AppException catch (e) {
      emit(ForexListErrorState(e.message));
    } catch (e) {
      emit(ForexListErrorState(e.toString()));
    }
  }

  FutureOr<void> _onForexListPriceSubscribeEvent(
    ForexListPriceSubscribeEvent event,
    Emitter<ForexListState> emit,
  ) async {
    try {
      await for (final forexPrices
          in _subscribeForexPriceUseCase(event.symbols)) {
        final displayModels = _forexPriceDisplayMapper.map(
            symbols: event.symbols, forexPriceMap: forexPrices);
        emit(ForexListLoadedState(displayModels));
      }
    } catch (e) {
      emit(ForexListErrorState(e.toString()));
    }
  }

  FutureOr<void> _onForexListRefreshEvent(
      ForexListRefreshEvent event, Emitter<ForexListState> emit) {
    add(ForexListLoadEvent(exchange: event.exchange));
  }
}
