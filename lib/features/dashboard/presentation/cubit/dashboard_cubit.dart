import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/model/transaction_model.dart';
import '../../../../common/utils/error_logger.dart';
import '../../../../core/di/core_injection.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  final _supabase = sl<SupabaseClient>();

  init() async {
    fetchNewOrder();
    getTotalTransaction();
    getTotalProduct();
    getTotalExpense();
    await getGrossIncome();
    getNetIncome();
  }

  void fetchNewOrder() async {
    try {
      final List response = await _supabase
          .from('transaction')
          .select(
            '*, user:user_id( id, first_name, last_name, address, telepon, lat, long), transaction_detail:id(*), payment_type:payment_id(*)',
          )
          .eq('transaction_status', 1);

      final List<TransactionModel> transaction =
          response.map((e) => TransactionModel.fromJson(e)).toList();

      emit(state.copyWith(
        newOrder: transaction,
        totalNewOrder: transaction.length,
      ));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void getTotalProduct() async {
    try {
      final List response = await _supabase.from('product').select(
            '*',
          );
      emit(state.copyWith(totalProdct: response.length));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  void getTotalTransaction() async {
    try {
      final List response = await _supabase.from('transaction').select(
            '*',
          );
      emit(state.copyWith(totalTransaction: response.length));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  Future<void> getGrossIncome() async {
    try {
      final int? response = await _supabase.rpc('total_income');
      emit(state.copyWith(grossIncome: response ?? 0));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  Future<void> getTotalExpense() async {
    try {
      final int response = await _supabase.rpc('total_expenses');
      emit(state.copyWith(totalExpense: response));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  getNetIncome() {
    int netIncome = state.grossIncome - state.totalExpense;
    if (netIncome.isNegative) {
      netIncome = 0;
    }

    emit(state.copyWith(netIncome: netIncome));
  }
}
