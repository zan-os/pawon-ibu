import 'package:equatable/equatable.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/product_model.dart';
import '../../../../common/utils/cubit_state.dart';

class ProductDetailState extends Equatable {
  final CubitState status;
  final String message;
  final int qty;
  final List<ProductModel> productList;
  final List<CategoryModel> categories;

  const ProductDetailState({
    this.status = CubitState.initial,
    this.message = '',
    this.qty = 1,
    this.productList = const [],
    this.categories = const [],
  });

  ProductDetailState copyWith(
      {CubitState? status,
      String? message,
      int? qty,
      List<ProductModel>? productList,
      List<CategoryModel>? categories}) {
    return ProductDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      qty: qty ?? this.qty,
      productList: productList ?? this.productList,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        productList,
        categories,
        qty,
        message,
      ];
}
