import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/product_model.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';
import '../../../../core/di/core_injection.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(status: CubitState.initial));

  static final _supabase = sl<SupabaseClient>();

  init() {
    fetchBestSales();
    fetchCategories();
    fetchProducts();
  }

  fetchProducts() async {
    try {
      final List response = await _supabase.from('product').select('*');

      final List<ProductModel> products =
          response.map((e) => ProductModel.fromJson(e)).toList();
      emit(state.copyWith(products: products));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  fetchBestSales() async {
    try {
      final List response = await _supabase.rpc('get_best_sales');
      log('ojan ${jsonEncode(response)}');
      final List<ProductModel> products =
          response.map((e) => ProductModel.fromJson(e)).toList();
      emit(state.copyWith(bestSales: products));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }

  fetchCategories() async {
    try {
      final List response = await _supabase.from('category').select('*');

      final List<CategoryModel> categories =
          response.map((e) => CategoryModel.fromJson(e)).toList();
      emit(state.copyWith(categories: categories));
    } catch (e, s) {
      errorLogger(e, s);
    }
  }
}
