import 'package:equatable/equatable.dart';

class ForexPrice extends Equatable {
  final String symbol;
  final double price;

  const ForexPrice({required this.symbol, required this.price});

  @override
  List<Object?> get props => [symbol, price];
}
