import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_bloc.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_event.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_state.dart';
import 'package:fxtm_test_app/core/widgets/app_error_widget.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/widgets/trade_history_loaded_widget.dart';

class TradeHistoryPage extends StatefulWidget {
  final String symbol;

  const TradeHistoryPage({super.key, required this.symbol});

  @override
  State<TradeHistoryPage> createState() => _TradeHistoryPageState();
}

class _TradeHistoryPageState extends State<TradeHistoryPage> {
  late TradeHistoryBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = context.read<TradeHistoryBloc>();
    _bloc.add(GetTradeHistoryDataEvent(widget.symbol));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
      ),
      body: BlocBuilder<TradeHistoryBloc, TradeHistoryState>(
        bloc: _bloc,
        builder: _onStateChangeBuilder,
      ),
    );
  }

  Widget _onStateChangeBuilder(
    BuildContext context,
    TradeHistoryState state,
  ) {
    if (state is TradeHistoryLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TradeHistoryLoadedState) {
      return TradeHistoryLoadedWidget(
          key: const Key('trade_history_loaded_key'),
          tradeHistoryModel: state.tradeHistoryModel);
    } else if (state is TradeHistoryErrorState) {
      return AppErrorWidget(
        key: const Key('trade_history_error_key'),
        message: state.message,
        onRetry: () {
          _bloc.add(GetTradeHistoryDataEvent(widget.symbol));
        },
      );
    }
    return AppErrorWidget(
      key: const Key('trade_history_error_key'),
      message: 'Something went wrong',
      onRetry: () {
        _bloc.add(GetTradeHistoryDataEvent(widget.symbol));
      },
    );
  }
}
