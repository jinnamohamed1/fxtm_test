import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm_test_app/features/trade_history/domain/usecases/get_trade_history_data_use_case.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_event.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_state.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/models/trade_history_model.dart';

class TradeHistoryBloc extends Bloc<TradeHistoryEvent, TradeHistoryState> {
  final GetTradeHistoryDataUseCase _getCandleDataUseCase;

  TradeHistoryBloc({required GetTradeHistoryDataUseCase getCandleDataUseCase})
      : _getCandleDataUseCase = getCandleDataUseCase,
        super(TradeHistoryInitialState()) {
    on<GetTradeHistoryDataEvent>(_onGetHistoryData);
  }

  Future<void> _onGetHistoryData(
      GetTradeHistoryDataEvent event, Emitter<TradeHistoryState> emit) async {
    emit(TradeHistoryLoadingState());
    try {
      final candles = await _getCandleDataUseCase(
        symbol: event.symbol,
        fromTimeStamp: DateTime.now().millisecondsSinceEpoch,
        toTimeStamp: DateTime.now()
            .subtract(const Duration(days: 5))
            .millisecondsSinceEpoch,
        resoultion: 'D',
      );

      emit(TradeHistoryLoadedState(
          tradeHistoryModel: TradeHistoryModel(
        symbol: event.symbol,
        candles: candles,
      )));
    } catch (e) {
      emit(TradeHistoryErrorState(e.toString()));
    }
  }
}
