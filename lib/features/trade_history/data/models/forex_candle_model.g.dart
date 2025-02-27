// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forex_candle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForexCandleModel _$ForexCandleModelFromJson(Map<String, dynamic> json) =>
    ForexCandleModel(
      close: (json['c'] as num).toDouble(),
      high: (json['h'] as num).toDouble(),
      low: (json['l'] as num).toDouble(),
      open: (json['o'] as num).toDouble(),
      status: json['s'] as String,
      timestamp: (json['t'] as num).toInt(),
      volume: (json['v'] as num).toDouble(),
    );

Map<String, dynamic> _$ForexCandleModelToJson(ForexCandleModel instance) =>
    <String, dynamic>{
      'c': instance.close,
      'h': instance.high,
      'l': instance.low,
      'o': instance.open,
      's': instance.status,
      't': instance.timestamp,
      'v': instance.volume,
    };
