import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm_test_app/core/navigation/routes.dart';
import 'package:fxtm_test_app/core/widgets/app_error_widget.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_bloc.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_event.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_state.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/models/forex_price_display_model.dart';

class ForexListPage extends StatefulWidget {
  final String exchange;
  const ForexListPage({super.key, required this.exchange});

  @override
  State<ForexListPage> createState() => _ForexListPageState();
}

class _ForexListPageState extends State<ForexListPage> {
  late ForexListBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = context.read<ForexListBloc>();
    _bloc.add(ForexListLoadEvent(exchange: widget.exchange));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FXTM Forex Tracker'),
      ),
      body: BlocBuilder<ForexListBloc, ForexListState>(
        bloc: _bloc,
        builder: _onStateChangeBuilder,
      ),
    );
  }

  Widget _buildForexList(BuildContext context, ForexListState state) {
    List<ForexPriceDisplayModel> items = [];

    if (state is ForexListLoadedState) {
      items = state.forexPrices;
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final symbol = items[index].displaySymbol;
        final price = items[index].price;
        return ListTile(
          title: Text(symbol),
          trailing: Text(price.toString()),
          onTap: () =>
              Navigator.pushNamed(context, tradeHistory, arguments: symbol),
        );
      },
    );
  }

  Widget _onStateChangeBuilder(BuildContext context, ForexListState state) {
    if (state is ForexListLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ForexListLoadedState) {
      return _buildForexList(context, state);
    } else if (state is ForexListErrorState) {
      return AppErrorWidget(
        key: const Key('forex_list_error_key'),
        message: state.message,
        onRetry: () {
          _bloc.add(ForexListLoadEvent(exchange: widget.exchange));
        },
      );
    }
    return const Center(child: Text('Error: Something went wrong'));
  }
}
