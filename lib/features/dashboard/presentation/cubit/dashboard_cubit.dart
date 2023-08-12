import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pawon_ibu_app/common/utils/error_logger.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:pawon_ibu_app/features/dashboard/data/model/best_sales_model.dart';
import 'package:pawon_ibu_app/features/dashboard/data/model/sales_model.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  final _supabase = sl<SupabaseClient>();

  init() {
    getBestSalesProduct();
    getTotalExpense();
    getNetIncome();
    getGrossIncome();
    fetchSales();
  }

  fetchSales() async {
    try {
      initializeDateFormatting();
      final response = await _supabase.rpc('monthly_sales');

      final List<SalesModel> sales = [];
      final SalesModel salesModel = SalesModel();

      log(jsonEncode(response));

      for (var i = 1; i <= 12; i++) {
        int month = 1;
        month = i;
        final monthName = DateFormat.MMM('id').format(DateTime(2000, month));
        sales.add(salesModel.copyWith(month: monthName));
        emit(state.copyWith(sales: sales));
      }

      for (final item in response) {
        final month = item['month'];
        final monthName = DateFormat.MMM('id').format(DateTime(2000, month));
        sales.add(salesModel.copyWith(month: monthName));
        final totalIncome = item['total_income'];
        final totalSales = item['total_sales'];

        sales.add(
          salesModel.copyWith(
            month: monthName,
            incomes: totalIncome,
            sales: totalSales,
          ),
        );
      }

      emit(state.copyWith(sales: sales));
    } catch (e) {
      errorLogger(e);
    }
  }

  void getGrossIncome() async {
    try {
      final int response = await _supabase.rpc('total_income');
      emit(state.copyWith(grossIncome: response));
    } catch (e) {
      errorLogger(e);
    }
  }

  getTotalExpense() async {
    try {
      final int response = await _supabase.rpc('total_expenses');
      log('ojan ${jsonEncode(response)}');
      emit(state.copyWith(totalExpense: response));
    } catch (e) {
      errorLogger(e);
    }
  }

  getNetIncome() {
    final netIncome = state.grossIncome - state.totalExpense;
    emit(state.copyWith(netIncome: netIncome));
  }

  void getBestSalesProduct() async {
    try {
      final List response = await _supabase.rpc('get_most_sold_product');
      final bestSales =
          response.map((e) => BestSalesModel.fromJson(e)).toList();
      emit(state.copyWith(bestSales: bestSales));
      log('ojan ${jsonEncode(response)}');
    } catch (e) {
      errorLogger(e);
    }
  }
}
