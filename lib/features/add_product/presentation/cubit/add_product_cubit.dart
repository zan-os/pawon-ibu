import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pawon_ibu_app/common/utils/error_logger.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/utils/cubit_state.dart';
import 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(const AddProductState(status: CubitState.initial));

  final _supabase = sl<SupabaseClient>();

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(sourcePath: img);
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }

  Future<File?> cropImage({required File sourcePath}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
    );

    if (croppedFile == null) return null;
    emit(state.copyWith(
        status: CubitState.hasData, image: File(croppedFile.path)));
    return File(croppedFile.path);
  }

  void fetchCategories() async {
    try {
      final tes = await _supabase.from('category').select('*');
      final response = jsonEncode(tes);
      final List json = jsonDecode(response);
      final categories = json.map((e) => CategoryModel.fromJson(e)).toList();

      emit(state.copyWith(categories: categories));
      emit(state.copyWith(status: CubitState.initial));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }

  void setSelectedCategory({required CategoryModel categoryModel}) {
    emit(state.copyWith(selectedCategory: categoryModel));
  }

  void uploadProduct({
    required String name,
    required String price,
    required String stock,
    required String description,
  }) async {
    try {
      final imagePath =
          'images/product/${basename(state.image?.path ?? '')}${math.Random().nextInt(10000)}';

      await _supabase.storage.from('pawon-ibu').upload(
            imagePath,
            state.image ?? File(''),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      await _supabase.from('product').insert({
        'name': name,
        'price': price,
        'category_id': state.selectedCategory?.id ?? 1,
        'description': description,
        'image':
            'https://jjeriwxysibjwhadsjqn.supabase.co/storage/v1/object/public/pawon-ibu/$imagePath'
      }).select();

      emit(state.copyWith(status: CubitState.success));
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Gagal menambahkan produk',
      ));
    }
  }
}
