import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/utils/cubit_state.dart';

class AddProductState extends Equatable {
  final CubitState status;
  final String message;
  final String name;
  final String price;
  final CategoryModel? selectedCategory;
  final String stock;
  final File? image;
  final List<CategoryModel> categories;

  const AddProductState({
    this.status = CubitState.initial,
    this.message = '',
    this.name = '',
    this.price = '',
    this.selectedCategory,
    this.stock = '',
    this.categories = const [],
    this.image,
  });

  AddProductState copyWith(
      {CubitState? status,
      String? message,
      String? name,
      String? price,
      CategoryModel? selectedCategory,
      String? stock,
      File? image,
      List<CategoryModel>? categories}) {
    return AddProductState(
      status: status ?? this.status,
      message: message ?? this.message,
      name: name ?? this.name,
      price: price ?? this.price,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        name,
        price,
        selectedCategory,
        stock,
        image,
        categories,
        message
      ];
}
