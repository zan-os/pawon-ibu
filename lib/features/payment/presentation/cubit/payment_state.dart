// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:pawon_ibu_app/common/data/model/transaction_detail_model.dart';

import '../../../../common/utils/cubit_state.dart';

class PaymentState extends Equatable {
  final CubitState status;
  final String message;
  final int totalBill;
  final bool isExpanded;
  final List<TransactionDetailModel> transaction;

  const PaymentState({
    this.status = CubitState.initial,
    this.message = '',
    this.totalBill = 0,
    this.isExpanded = false,
    this.transaction = const [],
  });

  PaymentState copyWith({
    CubitState? status,
    String? message,
    int? totalBill,
    bool? isExpanded,
    List<TransactionDetailModel>? transaction,
  }) {
    return PaymentState(
      status: status ?? this.status,
      message: message ?? this.message,
      totalBill: totalBill ?? this.totalBill,
      isExpanded: isExpanded ?? this.isExpanded,
      transaction: transaction ?? this.transaction,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      message,
      totalBill,
      isExpanded,
      transaction,
    ];
  }
}
