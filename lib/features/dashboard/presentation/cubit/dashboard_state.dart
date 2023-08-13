// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:pawon_ibu_app/common/data/model/transaction_model.dart';

import '../../../../common/utils/cubit_state.dart';

class DashboardState extends Equatable {
  final CubitState status;
  final String message;
  final int grossIncome;
  final int totalExpense;
  final int netIncome;
  final int totalProdct;
  final int totalTransaction;
  final int totalNewOrder;
  final List<TransactionModel> newOrder;

  const DashboardState({
    this.status = CubitState.initial,
    this.message = '',
    this.grossIncome = 0,
    this.totalExpense = 0,
    this.netIncome = 0,
    this.totalProdct = 0,
    this.totalTransaction = 0,
    this.totalNewOrder = 0,
    this.newOrder = const [],
  });

  DashboardState copyWith({
    CubitState? status,
    String? message,
    int? grossIncome,
    int? totalExpense,
    int? netIncome,
    int? totalProdct,
    int? totalTransaction,
    int? totalNewOrder,
    List<TransactionModel>? newOrder,
  }) {
    return DashboardState(
      status: status ?? this.status,
      message: message ?? this.message,
      grossIncome: grossIncome ?? this.grossIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netIncome: netIncome ?? this.netIncome,
      totalProdct: totalProdct ?? this.totalProdct,
      totalTransaction: totalTransaction ?? this.totalTransaction,
      totalNewOrder: totalNewOrder ?? this.totalNewOrder,
      newOrder: newOrder ?? this.newOrder,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      message,
      grossIncome,
      totalExpense,
      netIncome,
      totalProdct,
      totalTransaction,
      totalNewOrder,
      newOrder,
    ];
  }
}
