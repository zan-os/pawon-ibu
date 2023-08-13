import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/utils/error_logger.dart';
import 'package:pawon_ibu_app/features/payment/presentation/cubit/payment_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/model/transaction_detail_model.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../core/di/core_injection.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentState(status: CubitState.initial));

  final _supabase = sl<SupabaseClient>();
  final _userId = sl<SharedPreferences>().getInt('user_id');
  final _transactionId =
      sl<SharedPreferences>().getInt('created_transaction_id');

  void fetchTransaction() async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final List response = await _supabase
          .from('transaction_detail')
          .select(
            '*,transaction:transaction_id (*, payment_type:payment_id(*)), product:product_id (name, image)',
          )
          .eq('user_id', _userId)
          .eq('transaction_id', _transactionId);

      log('ojan ${jsonEncode(response)}');
      final List<TransactionDetailModel> transaction =
          response.map((e) => TransactionDetailModel.fromJson(e)).toList();

      emit(state.copyWith(totalBill: transaction.first.transaction?.totalBill));
      Future.delayed(const Duration(seconds: 1)).then((value) {
        emit(state.copyWith(
            status: CubitState.finishLoading, transaction: transaction));
        emit(state.copyWith(status: CubitState.initial));
      });
    } catch (e, s) {
      errorLogger(e, s);
    }
  }
}
