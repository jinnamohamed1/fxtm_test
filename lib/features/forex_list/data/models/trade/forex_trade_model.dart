import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forex_trade_model.g.dart';

@JsonSerializable()
class ForexTradeResponse extends Equatable {
  final List<ForexTradeData> data;
  final String type;

  const ForexTradeResponse({required this.data, required this.type});

  factory ForexTradeResponse.fromJson(Map<String, dynamic> json) =>
      _$ForexTradeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ForexTradeResponseToJson(this);

  @override
  List<Object?> get props => [data, type];
}

@JsonSerializable()
class ForexTradeData extends Equatable {
  @JsonKey(name: 'p')
  final double price;

  @JsonKey(name: 's')
  final String symbol;

  @JsonKey(name: 't')
  final int timestamp;

  @JsonKey(name: 'v')
  final double volume;

  const ForexTradeData({
    required this.price,
    required this.symbol,
    required this.timestamp,
    required this.volume,
  });

  factory ForexTradeData.fromJson(Map<String, dynamic> json) =>
      _$ForexTradeDataFromJson(json);
  Map<String, dynamic> toJson() => _$ForexTradeDataToJson(this);

  @override
  List<Object?> get props => [price, symbol, timestamp, volume];
}
