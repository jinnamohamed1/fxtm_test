import 'package:equatable/equatable.dart';
import 'package:fxtm_test_app/features/forex_list/presentation/models/forex_price_display_model.dart';

sealed class ForexListState extends Equatable {}

class ForexListLoadingState extends ForexListState {
  @override
  List<Object?> get props => [];
}

class ForexListLoadedState extends ForexListState {
  final List<ForexPriceDisplayModel> forexPrices;
  ForexListLoadedState(this.forexPrices);

  @override
  List<Object?> get props => [forexPrices];

  @override
  bool get stringify => true;
}

class ForexListErrorState extends ForexListState {
  final String message;
  ForexListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
