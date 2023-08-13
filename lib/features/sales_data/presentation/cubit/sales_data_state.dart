import 'package:equatable/equatable.dart';
import 'package:pawon_ibu_app/features/sales_data/data/model/best_sales_model.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../data/model/sales_model.dart';

class SalesDataState extends Equatable {
  final CubitState status;
  final String message;
  final int grossIncome;
  final int totalExpense;
  final int netIncome;
  final List<SalesModel> sales;
  final List<BestSalesModel> bestSales;

  const SalesDataState({
    this.status = CubitState.initial,
    this.message = '',
    this.grossIncome = 0,
    this.totalExpense = 0,
    this.netIncome = 0,
    this.sales = const [],
    this.bestSales = const [],
  });

  SalesDataState copyWith({
    CubitState? status,
    String? message,
    int? grossIncome,
    int? totalExpense,
    int? netIncome,
    List<SalesModel>? sales,
    List<BestSalesModel>? bestSales,
  }) {
    return SalesDataState(
      status: status ?? this.status,
      message: message ?? this.message,
      grossIncome: grossIncome ?? this.grossIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netIncome: netIncome ?? this.netIncome,
      sales: sales ?? this.sales,
      bestSales: bestSales ?? this.bestSales,
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
      sales,
      bestSales,
    ];
  }
}
