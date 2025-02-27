// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forex_symbol_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForexSymbolModel _$ForexSymbolModelFromJson(Map<String, dynamic> json) =>
    ForexSymbolModel(
      description: json['description'] as String,
      displaySymbol: json['displaySymbol'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$ForexSymbolModelToJson(ForexSymbolModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'displaySymbol': instance.displaySymbol,
      'symbol': instance.symbol,
    };
