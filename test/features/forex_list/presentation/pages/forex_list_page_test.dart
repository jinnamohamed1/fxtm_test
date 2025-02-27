import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/core/widgets/app_error_widget.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_bloc.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_event.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_state.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/models/forex_price_display_model.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/pages/forex_list_page.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ForexListBloc mockBloc;
  const exchange = 'OANDA';

  setUp(() {
    mockBloc = MockForexListBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
        home: BlocProvider<ForexListBloc>.value(
      value: mockBloc,
      child: const ForexListPage(
        exchange: exchange,
      ),
    ));
  }

  testWidgets('Displays loading indicator when state is loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(ForexListLoadingState());
    whenListen(mockBloc, Stream.value(ForexListLoadingState()));

    await tester.pumpWidget(createTestWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays list of forex prices when state is loaded',
      (tester) async {
    final forexPrices = [
      const ForexPriceDisplayModel(
          displaySymbol: 'EUR/USD',
          symbol: 'OANDA:EUR/USD',
          price: '1.12',
          description: 'Euro/US Dollar'),
      const ForexPriceDisplayModel(
          displaySymbol: 'GBP/USD',
          symbol: 'OANDA:GBP/USD',
          price: '1.35',
          description: 'British Pound/US Dollar'),
    ];

    when(() => mockBloc.state).thenReturn(ForexListLoadedState(forexPrices));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('EUR/USD'), findsOneWidget);
    expect(find.text('GBP/USD'), findsOneWidget);
    expect(find.text('1.12'), findsOneWidget);
    expect(find.text('1.35'), findsOneWidget);
  });

  testWidgets('Displays error widget when state is error', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(ForexListErrorState('Failed to load data'));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(AppErrorWidget), findsOneWidget);
    expect(find.text('Failed to load data'), findsOneWidget);
  });
}

class MockForexListBloc extends MockBloc<ForexListEvent, ForexListState>
    implements ForexListBloc {}
