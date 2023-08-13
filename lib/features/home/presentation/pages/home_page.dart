import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/ui/widgets/product_item_card.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/product_model.dart';
import '../../../../common/router/app_router.dart';
import '../../../../ui/theme/app_theme.dart';
import '../../../../ui/widgets/search_text_field.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/categori_item.dart';

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
              final bestSales = state.bestSales;
              final categories = state.categories;
              return EasyRefresh(
                onRefresh: () => cubit.init(),
                triggerAxis: Axis.vertical,
                child: ListView(
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
                    _ProductSection(
                      products: bestSales,
                      sectionTitle: 'Best Sales',
                    ),
                    const SizedBox(height: 16.0),
                    _ProductSection(
                      products: products,
                      sectionTitle: 'Kue Kering',
                    ),
                    const SizedBox(height: 16.0),
                    _ProductSection(
                      products: products,
                      sectionTitle: 'Dessert',
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
            child: const Icon(CupertinoIcons.bag),
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

class _ProductSection extends StatelessWidget {
  const _ProductSection({
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
          _ProductList(products: products),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({
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
          return ProductItemCard(
            product: product,
            name: product.name,
            desc: product.description,
            imageUrl: product.image ?? '',
            price: product.price,
            isPreview: false,
          );
        },
      ),
    );
  }
}
