import 'package:fxtm_test_app/features/trade_history/presentation/models/trade_history_model.dart';

sealed class TradeHistoryState {}

class TradeHistoryInitialState extends TradeHistoryState {}

class TradeHistoryLoadingState extends TradeHistoryState {}

class TradeHistoryLoadedState extends TradeHistoryState {
  final TradeHistoryModel tradeHistoryModel;

  TradeHistoryLoadedState({required this.tradeHistoryModel});
}

class TradeHistoryErrorState extends TradeHistoryState {
  final String message;

  TradeHistoryErrorState(this.message);
}
