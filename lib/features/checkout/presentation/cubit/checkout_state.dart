// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:pawon_ibu_app/common/data/model/user_model.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../../cart/data/cart_model.dart';

class CheckoutState extends Equatable {
  final CubitState status;
  final String message;
  final String note;
  final String pickedAddress;
  final int totalBill;
  final bool enableButton;
  final int paymentId;
  final int createdTransactionId;
  final List<CartModel> cartDetail;
  final UserModel userData;

  const CheckoutState({
    this.status = CubitState.initial,
    this.message = '',
    this.note = '',
    this.pickedAddress = '-',
    this.totalBill = 0,
    this.enableButton = false,
    this.paymentId = 1,
    this.createdTransactionId = 0,
    this.cartDetail = const [],
    this.userData = const UserModel(),
  });

  CheckoutState copyWith({
    CubitState? status,
    String? message,
    String? note,
    String? pickedAddress,
    int? totalBill,
    bool? enableButton,
    int? paymentId,
    int? createdTransactionId,
    List<CartModel>? cartDetail,
    UserModel? userData,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      message: message ?? this.message,
      note: note ?? this.note,
      pickedAddress: pickedAddress ?? this.pickedAddress,
      totalBill: totalBill ?? this.totalBill,
      enableButton: enableButton ?? this.enableButton,
      paymentId: paymentId ?? this.paymentId,
      createdTransactionId: createdTransactionId ?? this.createdTransactionId,
      cartDetail: cartDetail ?? this.cartDetail,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      message,
      note,
      pickedAddress,
      totalBill,
      enableButton,
      paymentId,
      createdTransactionId,
      cartDetail,
      userData,
    ];
  }
}
