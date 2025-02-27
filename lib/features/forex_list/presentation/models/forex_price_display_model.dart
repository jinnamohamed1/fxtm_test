import 'package:equatable/equatable.dart';

class ForexPriceDisplayModel extends Equatable {
  final String symbol;
  final String displaySymbol;
  final String description;
  final String price;

  const ForexPriceDisplayModel({
    required this.symbol,
    required this.displaySymbol,
    required this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [symbol, displaySymbol, description, price];
}
