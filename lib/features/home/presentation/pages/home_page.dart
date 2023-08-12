import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/product_model.dart';
import '../../../../common/router/app_router.dart';
import '../../../../ui/theme/app_theme.dart';
import '../../../../ui/widgets/search_text_field.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit cubit = context.read<HomeCubit>();
    final TextEditingController searchController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<HomeCubit, HomeState>(
            bloc: cubit..init(),
            builder: (_, state) {
              final products = state.products;
              final categories = state.categories;
              return ListView(
                children: [
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SearchTextField(
                      onSubmitted: (p0) {},
                      onTap: (p0) {},
                      controller: searchController,
                      onChanged: (p0) {},
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CategoryList(categories: categories),
                  const SizedBox(height: 1.0),
                  ProductSection(
                    products: products,
                    sectionTitle: 'Best Sales',
                  ),
                  const SizedBox(height: 16.0),
                  ProductSection(
                    products: products,
                    sectionTitle: 'Kue Kering',
                  ),
                  const SizedBox(height: 16.0),
                  ProductSection(
                    products: products,
                    sectionTitle: 'Dessert',
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
            child: const Icon(CupertinoIcons.cart),
          ),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.categories,
  });

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      height: 70,
      color: whiteColor,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final colorList = [
            blueVariantColor,
            purpleVariantColor,
            redVariantColor,
            greenVariantColor
          ];
          return CategoryItem(
            colorList: colorList,
            category: category,
            index: index,
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.colorList,
    required this.category,
    required this.index,
  });

  final List<Color> colorList;
  final CategoryModel category;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: colorList[index % colorList.length],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              category.name ?? '',
              style: productNameStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductSection extends StatelessWidget {
  const ProductSection({
    super.key,
    required this.products,
    required this.sectionTitle,
  });

  final String sectionTitle;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              sectionTitle,
              style: sectionTitleStyle,
            ),
          ),
          ProductList(products: products),
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final product = products[index];
          final colorList = [
            blueVariantColor,
            purpleVariantColor,
            redVariantColor,
            greenVariantColor
          ];
          return ProductItem(
            colorList: colorList,
            product: product,
            index: index,
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.colorList,
    required this.product,
    required this.index,
  });

  final List<Color> colorList;
  final ProductModel product;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.detailProduct,
          arguments: product),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
        child: SizedBox(
          height: 150,
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: colorList[index % colorList.length],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(product.name),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      product.name,
                      style: productNameStyle,
                    ),
                  ),
                  Text(
                    product.price.toString(),
                    style: priceStyle,
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                product.description,
                style: descStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
