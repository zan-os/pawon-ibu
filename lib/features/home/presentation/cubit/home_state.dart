import 'package:equatable/equatable.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/product_model.dart';
import '../../../../common/utils/cubit_state.dart';

class HomeState extends Equatable {
  final CubitState status;
  final List<ProductModel> products;
  final List<CategoryModel> categories;

  const HomeState({
    this.status = CubitState.initial,
    this.products = const [],
    this.categories = const [],
  });

  HomeState copyWith({
    CubitState? status,
    List<ProductModel>? products,
    List<CategoryModel>? categories,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [status, products, categories];
}
