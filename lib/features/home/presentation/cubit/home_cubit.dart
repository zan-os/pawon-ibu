import 'dart:convert';

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
  // final _supabase = Supabase.instance.client;

  init() {
    fetchCategories();
    fetchProducts();
  }

  fetchProducts() async {
    try {
      final response = await _supabase.from('product').select('*');
      final encoded = jsonEncode(response);
      final List decoded = jsonDecode(encoded);
      final List<ProductModel> products =
          decoded.map((e) => ProductModel.fromJson(e)).toList();
      emit(state.copyWith(products: products));
    } catch (e) {
      errorLogger(e);
    }
  }

  fetchCategories() async {
    try {
      final response = await _supabase.from('category').select('*');

      final encoded = jsonEncode(response);
      final List decoded = jsonDecode(encoded);
      final List<CategoryModel> categories =
          decoded.map((e) => CategoryModel.fromJson(e)).toList();
      emit(state.copyWith(categories: categories));
    } catch (e) {
      errorLogger(e);
    }
  }
}
