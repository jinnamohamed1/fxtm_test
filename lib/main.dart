import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fxtm_test_app/core/di/core_dependencies.dart';
import 'package:fxtm_test_app/core/navigation/routes.dart';
import 'package:fxtm_test_app/core/navigation/router.dart' as router;
import 'package:fxtm_test_app/features/forex_list/di/forex_list_dependencies.dart';
import 'package:fxtm_test_app/features/trade_history/di/trade_history_dependencies.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  setUpCoreDependencies();
  setupForexListDependencies();
  setupTradeHistoryDependencies();
  runApp(FXTMApp(defaultExchange: dotenv.env['DEFAULT_EXCHANGE']));
}

class FXTMApp extends StatelessWidget {
  final String? defaultExchange;
  const FXTMApp({super.key, required this.defaultExchange});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM Forex Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: forexList,
      onGenerateInitialRoutes: (String initialRoute) {
        return [
          router.Router.generateRoute(RouteSettings(
            name: forexList,
            arguments: defaultExchange,
          ))
        ];
      },
      onGenerateRoute: router.Router.generateRoute,
    );
  }
}
