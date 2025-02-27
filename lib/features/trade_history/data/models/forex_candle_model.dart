import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forex_candle_model.g.dart';

@JsonSerializable()
class ForexCandleModel extends Equatable {
  @JsonKey(name: 'c')
  final double close;

  @JsonKey(name: 'h')
  final double high;

  @JsonKey(name: 'l')
  final double low;

  @JsonKey(name: 'o')
  final double open;

  @JsonKey(name: 's')
  final String status;

  @JsonKey(name: 't')
  final int timestamp;

  @JsonKey(name: 'v')
  final double volume;

  const ForexCandleModel({
    required this.close,
    required this.high,
    required this.low,
    required this.open,
    required this.status,
    required this.timestamp,
    required this.volume,
  });

  /// Factory method to create `ForexCandleModel` from JSON
  factory ForexCandleModel.fromJson(Map<String, dynamic> json) =>
      _$ForexCandleModelFromJson(json);

  /// Method to convert `ForexCandleModel` to JSON
  Map<String, dynamic> toJson() => _$ForexCandleModelToJson(this);

  @override
  List<Object?> get props =>
      [close, high, low, open, status, timestamp, volume];
}
