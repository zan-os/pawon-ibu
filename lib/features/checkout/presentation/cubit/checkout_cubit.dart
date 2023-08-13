import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/data/model/user_model.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/router/app_router.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';
import '../../../cart/data/cart_model.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState(status: CubitState.initial));

  final _supabase = sl<SupabaseClient>();
  final _userId = sl<SharedPreferences>().getInt('user_id');
  final _pickedAddress = sl<SharedPreferences>().getString('picked_address');

  void init() {
    getUserData();
    fetchCart();
  }

  Future<void> navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      AppRouter.addressMapPicker,
    );

    emit(state.copyWith(pickedAddress: result.toString()));
  }

  void setNote({required String note}) {
    emit(state.copyWith(note: note));
  }

  void getUserData() async {
    try {
      final response =
          await _supabase.from('user').select().eq('id', _userId).single();
      final encoded = jsonEncode(response);
      final decoded = jsonDecode(encoded);
      final userData = UserModel.fromJson(decoded);

      emit(state.copyWith(userData: userData));
      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal mendapatkan data user',
      ));
    }
  }

  void setPaymentType({required int paymentId}) {
    emit(state.copyWith(paymentId: paymentId));
  }

  void fetchCart() async {
    try {
      await _supabase.from('cart').select('''id, qty, total_bill,
    product:product_id (*)''').eq('user_id', _userId).then(
            (response) {
              final encoded = jsonEncode(response);
              final List decoded = jsonDecode(encoded);
              final cartDetail =
                  decoded.map((e) => CartModel.fromJson(e)).toList();

              emit(state.copyWith(
                status: CubitState.initial,
                cartDetail: cartDetail,
              ));

              if (cartDetail.isNotEmpty) {
                getTotalBill();
              }
            },
          );
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal mendapatkan kategori',
      ));
    }
  }

  void deleteAllCart() async {
    try {
      await _supabase.from('cart').delete().eq('user_id', _userId);

      emit(state.copyWith(
          status: CubitState.success,
          message: 'Cart dihapus',
          cartDetail: List.empty(),
          totalBill: 0));
      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal menghapus cart',
      ));
    }
  }

  void getTotalBill() async {
    try {
      final params = {'p_user_id': _userId};
      final totalBill =
          await _supabase.rpc('get_total_bill', params: params).select();
      emit(state.copyWith(status: CubitState.initial, totalBill: totalBill));
      emit(state.copyWith(enableButton: true));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal mendapatkan total bill',
      ));
    }
  }

  Future<void> createOrder() async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      await _supabase.rpc('add_transaction', params: {
        'p_transaction_status': 1,
        'p_user_id': _userId,
        'p_payment_id': state.paymentId,
        'p_address': state.pickedAddress,
        'p_note': state.note,
        'p_telephone': state.userData.telepon
      }).then((createdTransactionId) async {
        await sl<SharedPreferences>()
            .setInt('created_transaction_id', createdTransactionId);
        await _supabase.rpc(
          'add_transaction_detail',
          params: {
            'p_transaction_id': createdTransactionId,
            'p_user_id': _userId,
          },
        );
      });
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal membuat transaksi',
      ));
    }
  }
}
