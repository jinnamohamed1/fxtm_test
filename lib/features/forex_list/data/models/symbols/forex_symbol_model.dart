import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forex_symbol_model.g.dart';

@JsonSerializable()
class ForexSymbolModel extends Equatable {
  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'displaySymbol')
  final String displaySymbol;

  @JsonKey(name: 'symbol')
  final String symbol;

  const ForexSymbolModel({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
  });

  /// Factory method to create `ForexSymbolModel` from JSON
  factory ForexSymbolModel.fromJson(Map<String, dynamic> json) =>
      _$ForexSymbolModelFromJson(json);

  /// Method to convert `ForexSymbolModel` to JSON
  Map<String, dynamic> toJson() => _$ForexSymbolModelToJson(this);

  @override
  List<Object?> get props => [description, displaySymbol, symbol];
}
