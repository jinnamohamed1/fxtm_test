import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm_test_app/core/errors/error_types.dart';
import 'package:fxtm_test_app/core/errors/exceptions.dart';
import 'package:fxtm_test_app/features/forex_list/data/models/symbols/forex_symbol_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/entities/forex_price_model.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/get_forex_symbols_use_case.dart';
import 'package:fxtm_test_app/features/forex_list/domain/usecases/subscribe_forex_price_use_case.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_bloc.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_event.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_state.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/mappers/forex_price_display_mapper.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/models/forex_price_display_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetForexSymbolsUseCase extends Mock
    implements GetForexSymbolsUseCase {}

class MockSubscribeForexPriceUseCase extends Mock
    implements SubscribeForexPriceUseCase {}

void main() {
  group('ForexListBloc', () {
    late MockGetForexSymbolsUseCase mockGetForexSymbolsUseCase;
    late MockSubscribeForexPriceUseCase mockSubscribeForexPriceUseCase;
    late ForexPriceDisplayMapper forexPriceDisplayMapper;
    late ForexListBloc bloc;

    const String exchange = 'OANDA';

    final List<ForexSymbolModel> testSymbols = [
      const ForexSymbolModel(
          symbol: 'OANDA:EUR/USD',
          description: 'Euro / US Dollar',
          displaySymbol: 'EUR/USD'),
      const ForexSymbolModel(
          symbol: 'OANDA:GBP/USD',
          description: 'British Pound / US Dollar',
          displaySymbol: 'GBP/USD'),
    ];

    final Map<String, ForexPrice> testPriceMap = {
      'OANDA:EUR/USD': const ForexPrice(symbol: 'OANDA:EUR/USD', price: 1.2345),
      'OANDA:GBP/USD': const ForexPrice(symbol: 'OANDA:GBP/USD', price: 1.3446),
    };

    final List<ForexPriceDisplayModel> initialTestDisplayModels = [
      const ForexPriceDisplayModel(
        symbol: 'OANDA:EUR/USD',
        displaySymbol: 'EUR/USD',
        price: '0.0',
        description: 'Euro / US Dollar',
      ),
      const ForexPriceDisplayModel(
        symbol: 'OANDA:GBP/USD',
        displaySymbol: 'GBP/USD',
        price: '0.0',
        description: 'British Pound / US Dollar',
      ),
    ];

    final List<ForexPriceDisplayModel> forexPriceDisplayModels = [
      const ForexPriceDisplayModel(
        symbol: 'OANDA:EUR/USD',
        displaySymbol: 'EUR/USD',
        price: '1.23',
        description: 'Euro / US Dollar',
      ),
      const ForexPriceDisplayModel(
        symbol: 'OANDA:GBP/USD',
        displaySymbol: 'GBP/USD',
        price: '1.34',
        description: 'British Pound / US Dollar',
      ),
    ];

    setUpAll(() {
      registerFallbackValue(testSymbols);
    });

    setUp(() {
      mockGetForexSymbolsUseCase = MockGetForexSymbolsUseCase();
      mockSubscribeForexPriceUseCase = MockSubscribeForexPriceUseCase();
      forexPriceDisplayMapper = ForexPriceDisplayMapperImpl();

      bloc = ForexListBloc(
        getForexSymbolsUseCase: mockGetForexSymbolsUseCase,
        subscribeForexPriceUseCase: mockSubscribeForexPriceUseCase,
        forexPriceDisplayMapper: forexPriceDisplayMapper,
      );
    });

    tearDown(() {
      reset(mockSubscribeForexPriceUseCase);
      reset(mockGetForexSymbolsUseCase);
      bloc.close();
    });

    test('initial state should be ForexListLoadingState', () {
      expect(bloc.state, isA<ForexListLoadingState>());
    });

    blocTest<ForexListBloc, ForexListState>(
      'emits [ForexListLoadingState, ForexListLoadedState] when ForexListLoadEvent is added successfully',
      build: () {
        when(() => mockGetForexSymbolsUseCase(exchange: exchange))
            .thenAnswer((_) async => testSymbols);

        // Mock the price subscription to return an empty stream
        when(() => mockSubscribeForexPriceUseCase(testSymbols))
            .thenAnswer((_) => const Stream.empty());

        return bloc;
      },
      act: (bloc) => bloc.add(ForexListLoadEvent(exchange: exchange)),
      expect: () => [
        isA<ForexListLoadingState>(),
        isA<ForexListLoadedState>().having(
          (state) => state.forexPrices,
          'forexPrices',
          equals(initialTestDisplayModels),
        ),
      ],
      verify: (_) {
        verify(() => mockGetForexSymbolsUseCase(exchange: exchange)).called(1);
        verify(() => mockSubscribeForexPriceUseCase(testSymbols)).called(1);
      },
    );

    blocTest<ForexListBloc, ForexListState>(
      'emits [ForexListLoadingState, ForexListErrorState] when GetForexSymbolsUseCase throws',
      build: () {
        when(() => mockGetForexSymbolsUseCase(exchange: exchange)).thenThrow(
            AppException(
                message: 'Failed to load forex symbols',
                type: ForexErrorType.server));

        return bloc;
      },
      act: (bloc) => bloc.add(ForexListLoadEvent(exchange: exchange)),
      expect: () => [
        isA<ForexListLoadingState>(),
        isA<ForexListErrorState>().having(
          (state) => state.message,
          'message',
          equals('Failed to load forex symbols'),
        ),
      ],
    );

    blocTest<ForexListBloc, ForexListState>(
      'emits updated ForexListLoadedState when price updates are received',
      build: () {
        // Setup for initial load
        when(() => mockGetForexSymbolsUseCase(exchange: exchange))
            .thenAnswer((_) async => testSymbols);

        // Create a controller to simulate price updates
        final controller = StreamController<Map<String, ForexPrice>>();
        when(() => mockSubscribeForexPriceUseCase(testSymbols)).thenAnswer((_) {
          return controller.stream;
        });
        Future.delayed(Duration.zero, () {
          controller.add(testPriceMap);
        });

        return bloc;
      },
      act: (bloc) => bloc.add(ForexListLoadEvent(exchange: exchange)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ForexListLoadingState(),
        ForexListLoadedState(initialTestDisplayModels),
        ForexListLoadedState(forexPriceDisplayModels),
      ],
    );

    blocTest<ForexListBloc, ForexListState>(
      'emits ForexListErrorState when price subscription emits error',
      build: () {
        // Setup for initial load
        when(() => mockGetForexSymbolsUseCase(exchange: exchange))
            .thenAnswer((_) async => testSymbols);

        // Create a controller to simulate price updates with error
        final controller = StreamController<Map<String, ForexPrice>>();
        when(() => mockSubscribeForexPriceUseCase(testSymbols))
            .thenAnswer((_) => controller.stream);

        // Add error after a delay
        Future.delayed(const Duration(milliseconds: 100), () {
          controller.addError('Connection error');
        });

        return bloc;
      },
      act: (bloc) => bloc.add(ForexListLoadEvent(exchange: exchange)),
      wait: const Duration(milliseconds: 150),
      expect: () => [
        isA<ForexListLoadingState>(),
        isA<ForexListLoadedState>(),
        isA<ForexListErrorState>().having(
          (state) => state.message,
          'error message',
          equals('Connection error'),
        ),
      ],
    );

    blocTest<ForexListBloc, ForexListState>(
      'ForexListRefreshEvent should trigger a full reload',
      build: () {
        when(() => mockGetForexSymbolsUseCase(exchange: exchange))
            .thenAnswer((_) async => testSymbols);
        when(() => mockSubscribeForexPriceUseCase(testSymbols))
            .thenAnswer((_) => const Stream.empty());

        return bloc;
      },
      act: (bloc) => bloc.add(ForexListRefreshEvent(exchange: exchange)),
      expect: () => [
        isA<ForexListLoadingState>(),
        isA<ForexListLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetForexSymbolsUseCase(exchange: exchange)).called(1);
      },
    );
  });
}
