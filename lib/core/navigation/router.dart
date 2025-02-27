import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm_test_app/core/navigation/routes.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/bloc/forex_list_bloc.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/pages/forex_list_page.dart';
import 'package:fxtm_test_app/features/trade_history/presentation/bloc/trade_history_bloc.dart';
import 'package:fxtm_test_app/features/trade_history/trade_history_page.dart';
import 'package:get_it/get_it.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case forexList:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<ForexListBloc>(
                  create: (BuildContext context) => GetIt.I<ForexListBloc>(),
                  child: ForexListPage(
                    exchange: settings.arguments as String,
                  ),
                ));
      case tradeHistory:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<TradeHistoryBloc>(
                  create: (BuildContext context) => GetIt.I<TradeHistoryBloc>(),
                  child: TradeHistoryPage(
                    symbol: settings.arguments as String,
                  ),
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
