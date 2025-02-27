// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forex_trade_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForexTradeResponse _$ForexTradeResponseFromJson(Map<String, dynamic> json) =>
    ForexTradeResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ForexTradeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ForexTradeResponseToJson(ForexTradeResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': instance.type,
    };

ForexTradeData _$ForexTradeDataFromJson(Map<String, dynamic> json) =>
    ForexTradeData(
      price: (json['p'] as num).toDouble(),
      symbol: json['s'] as String,
      timestamp: (json['t'] as num).toInt(),
      volume: (json['v'] as num).toDouble(),
    );

Map<String, dynamic> _$ForexTradeDataToJson(ForexTradeData instance) =>
    <String, dynamic>{
      'p': instance.price,
      's': instance.symbol,
      't': instance.timestamp,
      'v': instance.volume,
    };
