import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pawon_ibu_app/ui/widgets/product_item_card.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../ui/helper/show_snackbar.dart';
import '../../../../ui/widgets/category_picker.dart';
import '../../../../ui/widgets/round_bordered_text_field.dart';
import '../cubit/add_product_cubit.dart';
import '../cubit/add_product_state.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode unfocusNode = FocusNode();
    return BlocProvider<AddProductCubit>(
      create: (context) => AddProductCubit(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
        child: const _AddProductContent(),
      ),
    );
  }
}

class _AddProductContent extends StatefulWidget {
  const _AddProductContent();

  @override
  State<_AddProductContent> createState() => _AddProductContentState();
}

class _AddProductContentState extends State<_AddProductContent> {
  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final descController = TextEditingController();

  final categoryController = TextEditingController();

  static const invalidFormSnackbar = SnackBar(
    content: Text('Harap isi semua data'),
    backgroundColor: CupertinoColors.systemRed,
  );

  static const uploadSuccess = SnackBar(
    content: Text('Berhasil menambahkan produk'),
    backgroundColor: CupertinoColors.systemGreen,
  );

  String _name = '-';
  String _desc = '-';
  int _price = 0;

  File? _image;

  late AddProductCubit cubit;

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Gallery'),
              onPressed: () {
                cubit.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Text('Or'),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              child: const Text('Camera'),
              onPressed: () {
                cubit.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker({required List<CategoryModel> categories}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoryPicker(
        categories: categories,
        onSelectButtonTap: (category) {
          cubit.setSelectedCategory(categoryModel: category);
          categoryController.text = category.name ?? '';
        },
      ),
    );
  }

  SafeArea _scaffoldBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          padding: MediaQuery.of(context).viewInsets,
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            _previewCard(),
            const SizedBox(
              height: 16.0,
            ),
            _imagePickerText(),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Nama Produk',
              controller: nameController,
              onChange: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Harga Produk',
              keyboardType: TextInputType.number,
              controller: priceController,
              onChange: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _price = int.parse(value);
                  });
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            BlocBuilder<AddProductCubit, AddProductState>(
              builder: (context, state) => GestureDetector(
                onTap: () {
                  _showCategoryPicker(categories: state.categories);
                },
                child: RoundBorderedTextFIeld(
                  enabled: false,
                  label: 'Kategori Produk',
                  controller: categoryController,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Deskripsi',
              keyboardType: TextInputType.text,
              controller: descController,
              onChange: (value) {
                setState(() {
                  _desc = value;
                });
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            _addButton(),
          ],
        ),
      ),
    );
  }

  GestureDetector _imagePickerText() {
    return GestureDetector(
      onTap: () => _showImageSourcePicker(),
      child: const SizedBox(
        height: 25,
        width: 100,
        child: Center(
          child: Text(
            'Upload Foto',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Center _previewCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Preview Product',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16.0,
          ),
          SizedBox(
            width: 200,
            height: 216,
            child: ProductItemCard(
              isPreview: true,
              imagePath: _image,
              name: _name,
              price: _price,
              desc: _desc,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return ElevatedButton(
      child: const Text('Tambah Produk'),
      onPressed: () {
        final stock = descController.text;
        (_formValidator())
            ? context.read<AddProductCubit>().uploadProduct(
                name: nameController.text.trim(),
                price: priceController.text.trim(),
                stock: (stock.isEmpty) ? '0' : stock,
                description: descController.text.trim())
            : ScaffoldMessenger.of(context).showSnackBar(invalidFormSnackbar);
      },
    );
  }

  bool _formValidator() {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    if (name.isNotEmpty && price.isNotEmpty && _image != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => cubit.fetchCategories());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit = BlocProvider.of<AddProductCubit>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode unfocusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Tambah Produk')),
      backgroundColor: Colors.white,
      body: BlocConsumer<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state.status == CubitState.hasData) {
            setState(() {
              _image = state.image;
            });
          }
          if (state.status == CubitState.success) {
            ScaffoldMessenger.of(context).showSnackBar(uploadSuccess);
          }
          if (state.status == CubitState.loading) {
            FocusScope.of(context).requestFocus(unfocusNode);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          }
          if (state.status == CubitState.finishLoading) {
            Navigator.pop(context);
          }
          if (state.status == CubitState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar(state.message, isError: true),
            );
          }
        },
        builder: (context, state) {
          return _scaffoldBody();
        },
      ),
    );
  }
}
