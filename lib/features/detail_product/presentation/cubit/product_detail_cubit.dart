import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:pawon_ibu_app/features/detail_product/presentation/cubit/product_detail_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/model/product_model.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit()
      : super(const ProductDetailState(status: CubitState.initial));

  final _supabase = sl<SupabaseClient>();
  final prefs = sl<SharedPreferences>();

  void qtyIncement() {
    emit(state.copyWith(qty: state.qty + 1));
  }

  void qtyDecrement() {
    if (state.qty > 1) {
      emit(state.copyWith(qty: state.qty - 1));
    }
  }

  void addToCart({required ProductModel product}) async {
    final userId = prefs.getInt('user_id');
    try {
      await _supabase.rpc(
        'add_to_cart',
        params: {
          'p_user_id': userId,
          'p_product_id': product.id,
          'p_product_price': product.price,
          'p_product_qty': state.qty
        },
      );
      emit(state.copyWith(
        status: CubitState.success,
        message:
            'Berhasil menambahkan ${state.qty} ${product.name} ke keranjang',
      ));

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal menambahkan ke keranjang',
      ));
    }
  }
}
