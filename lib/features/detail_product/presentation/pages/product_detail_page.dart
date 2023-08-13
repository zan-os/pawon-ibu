import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/data/model/product_model.dart';
import 'package:pawon_ibu_app/features/detail_product/presentation/cubit/product_detail_cubit.dart';
import 'package:pawon_ibu_app/features/detail_product/presentation/cubit/product_detail_state.dart';
import 'package:pawon_ibu_app/ui/helper/format_currency.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../../../ui/helper/show_snackbar.dart';
import '../../../../ui/theme/app_theme.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    return BlocProvider<ProductDetailCubit>(
      create: (context) => ProductDetailCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: const Text(
            'Detail Produk',
          ),
        ),
        body: _ScaffoldBody(product: product),
        bottomSheet: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            return _ActionButton(
              order: () => context.read<ProductDetailCubit>().addToCart(
                    product: product,
                  ),
              addQty: () => context.read<ProductDetailCubit>().qtyIncement(),
              removeQty: () =>
                  context.read<ProductDetailCubit>().qtyDecrement(),
              qty: state.qty,
            );
          },
        ),
      ),
    );
  }
}

class _ScaffoldBody extends StatelessWidget {
  const _ScaffoldBody({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listener: (context, state) {
        if (state.status == CubitState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar(state.message, isError: false),
          );
        }
      },
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          children: [
            _productImage(context),
            _productDetail(),
            const SizedBox(height: 1.5),
            _coupon(),
            const SizedBox(height: 1.5),
          ],
        );
      },
    );
  }

  Container _coupon() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: whiteColor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Have a coupon code?',
            style: descStyle,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: lightGreyColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'P4W0N',
              style: priceStyle,
            ),
          )
        ],
      ),
    );
  }

  Container _productDetail() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: whiteColor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.name,
            style: productNameStyle.copyWith(
                fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            product.description,
            style: descStyle,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            formatCurrency(product.price),
            style: priceStyle.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Container _productImage(BuildContext context) {
    return Container(
      color: greyColor,
      height: MediaQuery.of(context).size.height * 0.36,
      child: CachedNetworkImage(
        imageUrl: product.image ?? '',
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final int qty;
  final Function addQty;
  final Function removeQty;
  final Function order;
  const _ActionButton(
      {required this.qty,
      required this.addQty,
      required this.removeQty,
      required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: whiteColor,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityButtonControl(
            icon: Icons.remove_rounded,
            addQty: false,
            onTap: () => removeQty(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              qty.toString(),
              style: priceStyle.copyWith(fontSize: 20),
            ),
          ),
          QuantityButtonControl(
            icon: Icons.add_rounded,
            addQty: true,
            onTap: () => addQty(),
          ),
          const SizedBox(width: 24.0),
          Expanded(
            child: SizedBox(
              child: ElevatedButton(
                onPressed: () => order(),
                child: const Text('Tambahkan'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class QuantityButtonControl extends StatelessWidget {
  final IconData icon;
  final bool addQty;
  final Function onTap;
  const QuantityButtonControl({
    super.key,
    required this.icon,
    required this.addQty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (addQty) {
          onTap();
        } else {
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: blueColor),
        ),
        child: Icon(
          icon,
          color: whiteColor,
        ),
      ),
    );
  }
}
