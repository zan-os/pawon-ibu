import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/model/product_model.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';
import '../../data/cart_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState(status: CubitState.initial));

  final _supabase = sl<SupabaseClient>();
  final _userId = sl<SharedPreferences>().getInt('user_id');

  void init() {
    fetchCart();
  }

  void fetchCart() async {
    try {
      log('ojan $_userId');
      await _supabase.from('cart').select('''id, qty, total_bill,
    product:product_id (*)''').eq('user_id', _userId).then(
            (response) {
              final encoded = jsonEncode(response);
              final List decoded = jsonDecode(encoded);
              final cartDetail =
                  decoded.map((e) => CartModel.fromJson(e)).toList();

              emit(state.copyWith(
                  status: CubitState.initial, cartDetail: cartDetail));

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
          status: CubitState.error, message: 'Gagal menghapus cart'));
    }
  }

  void addItemCart({required ProductModel product}) async {
    try {
      await _supabase.rpc(
        'add_to_cart',
        params: {
          'p_user_id': _userId,
          'p_product_id': product.id,
          'p_product_price': product.price,
          'p_product_qty': 1,
        },
      ).then(
        (value) {
          emit(
            state.copyWith(
              status: CubitState.hasData,
              message: 'Berhasil menambahkan barang',
            ),
          );

          init();
        },
      );

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
    }
  }

  void removeItemCart({required ProductModel product}) async {
    try {
      await _supabase.rpc(
        'remove_one_item_cart',
        params: {
          'p_product_id': product.id,
          'p_product_price': product.price,
          'p_user_id': _userId
        },
      ).then(
        (value) {
          emit(
            state.copyWith(
              status: CubitState.hasData,
              message: 'Berhasil menambahkan barang',
            ),
          );

          fetchCart();
        },
      );

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
    }
  }

  void deleteItem({required int id}) {
    _supabase
        .from('cart')
        .delete()
        .match({'id': id}).then((value) => fetchCart());
  }
}
