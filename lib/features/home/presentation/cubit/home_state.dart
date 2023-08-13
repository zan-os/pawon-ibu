import 'package:equatable/equatable.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/product_model.dart';
import '../../../../common/utils/cubit_state.dart';

class HomeState extends Equatable {
  final CubitState status;
  final List<ProductModel> products;
  final List<ProductModel> bestSales;
  final List<CategoryModel> categories;

  const HomeState({
    this.status = CubitState.initial,
    this.products = const [],
    this.bestSales = const [],
    this.categories = const [],
  });

  HomeState copyWith({
    CubitState? status,
    List<ProductModel>? products,
    List<ProductModel>? bestSales,
    List<CategoryModel>? categories,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      bestSales: bestSales ?? this.bestSales,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [status, products, bestSales, categories];
}
