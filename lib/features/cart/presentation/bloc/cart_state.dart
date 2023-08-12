import 'package:equatable/equatable.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../data/cart_model.dart';

class CartState extends Equatable {
  final CubitState status;
  final String message;
  final int totalBill;
  final bool enableButton;
  final int createdTransactionId;
  final List<CartModel> cartDetail;

  const CartState({
    this.status = CubitState.initial,
    this.message = '',
    this.totalBill = 0,
    this.enableButton = false,
    this.createdTransactionId = 0,
    this.cartDetail = const [],
  });

  CartState copyWith({
    CubitState? status,
    String? message,
    int? totalBill,
    bool? enableButton,
    int? createdTransactionId,
    List<CartModel>? cartDetail,
  }) {
    return CartState(
      status: status ?? this.status,
      message: message ?? this.message,
      totalBill: totalBill ?? this.totalBill,
      enableButton: enableButton ?? this.enableButton,
      createdTransactionId: createdTransactionId ?? this.createdTransactionId,
      cartDetail: cartDetail ?? this.cartDetail,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      message,
      totalBill,
      enableButton,
      createdTransactionId,
      cartDetail,
    ];
  }
}
