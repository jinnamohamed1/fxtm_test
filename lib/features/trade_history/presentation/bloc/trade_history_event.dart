sealed class TradeHistoryEvent {}

class GetTradeHistoryDataEvent extends TradeHistoryEvent {
  final String symbol;

  GetTradeHistoryDataEvent(this.symbol);
}
