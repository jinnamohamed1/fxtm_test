import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/features/trade_history/data/models/forex_candle_model.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_bloc.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_event.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_state.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/models/trade_history_model.dart';
import 'package:fxtm_test_app/features/trade_history/trade_history_page.dart';
import 'package:mocktail/mocktail.dart';

class MockTradeHistoryBloc
    extends MockBloc<TradeHistoryEvent, TradeHistoryState>
    implements TradeHistoryBloc {}

void main() {
  late TradeHistoryBloc mockBloc;
  const symbol = 'EUR/USD';

  setUp(() {
    mockBloc = MockTradeHistoryBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<TradeHistoryBloc>.value(
        value: mockBloc,
        child: const TradeHistoryPage(symbol: symbol),
      ),
    );
  }

  testWidgets('Displays loading indicator when state is loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TradeHistoryLoadingState());
    whenListen(mockBloc, Stream.value(TradeHistoryLoadingState()));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays loaded state when data is available',
      (WidgetTester tester) async {
    final forexData = [
      const ForexCandleModel(
        close: 1.10713,
        high: 1.1074,
        low: 1.09897,
        open: 1.0996,
        status: 'ok',
        timestamp: 1568667600,
        volume: 75789,
      ),
      const ForexCandleModel(
        close: 1.10713,
        high: 1.1074,
        low: 1.09897,
        open: 1.0996,
        status: 'ok',
        timestamp: 1568667600,
        volume: 75789,
      ),
      const ForexCandleModel(
        close: 1.10713,
        high: 1.1074,
        low: 1.09897,
        open: 1.0996,
        status: 'ok',
        timestamp: 1568667600,
        volume: 75789,
      ),
    ];
    final tradeHistoryModel =
        TradeHistoryModel(symbol: symbol, candles: forexData);
    when(() => mockBloc.state).thenReturn(
        TradeHistoryLoadedState(tradeHistoryModel: tradeHistoryModel));
    whenListen(
        mockBloc,
        Stream.value(
            TradeHistoryLoadedState(tradeHistoryModel: tradeHistoryModel)));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byKey(const Key('trade_history_loaded_key')), findsOneWidget);
  });

  testWidgets('Displays error widget when state is error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(TradeHistoryErrorState('Failed to load data'));
    whenListen(
        mockBloc, Stream.value(TradeHistoryErrorState('Failed to load data')));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('Failed to load data'), findsOneWidget);
  });
}
