import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pawon_ibu_app/common/router/app_router.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/currency_formatter.dart';
import '../../../../ui/helper/show_snackbar.dart';
import '../../../../ui/widgets/divider_widget.dart';
import '../../../../ui/widgets/product_list_tile.dart';
import '../../../../ui/widgets/rounded_button_widget.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        elevation: 1,
        backgroundColor: whiteColor,
      ),
      body: const _ScaffoldBody(),
    );
  }
}

class _ScaffoldBody extends StatelessWidget {
  const _ScaffoldBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return SafeArea(
      child: BlocConsumer<CartCubit, CartState>(
        bloc: cubit..init(),
        listener: (context, state) {
          if (state.status == CubitState.loading) {
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
          if (state.status == CubitState.success) {
            // (state.createdTransactionId != 0)
            //     ? Navigator.pushNamed(
            //         context,
            //         AppRouter.transaction,
            //         arguments: {
            //           'transaction_id': state.createdTransactionId,
            //           'total_bill': state.totalBill
            //         },
            //       ).then((value) => cubit.init())
            //     : ScaffoldMessenger.of(context).showSnackBar(
            //         showSnackBar('Gagal mendapatkan id transaksi',
            //             isError: true),
            //       );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              color: whiteColor,
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _OrderedItemSection(),
                    _PaymentDetailSection(),
                    DividerWidget(),
                    SizedBox(height: 8.0),
                    _TotalBillSection(),
                    _CheckoutButton()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return RoundedButtonWidget(
            enable: state.cartDetail.isNotEmpty,
            title: 'Beli',
            onTap: () {
              if (state.cartDetail.isNotEmpty && state.enableButton) {
                Navigator.pushNamed(context, AppRouter.checkout);
              }
              return;
            },
          );
        },
      ),
    );
  }
}

class _TotalBillSection extends StatelessWidget {
  const _TotalBillSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total Pembelian', style: sectionTitleStyle),
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) =>
              Text(formatRupiah(state.totalBill), style: sectionTitleStyle),
        )
      ],
    );
  }
}

class _PaymentDetailSection extends StatelessWidget {
  const _PaymentDetailSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan Belanja', style: sectionTitleStyle),
        const DividerWidget(),
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.cartDetail.length,
              itemBuilder: (context, index) {
                final cart = state.cartDetail[index];
                final totalPrice = cart.totalBill ?? 0;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        cart.product?.name ?? '',
                        style: blackTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        formatRupiah(totalPrice),
                        style: blackTextStyle,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _OrderedItemSection extends StatelessWidget {
  const _OrderedItemSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('List Pesanan', style: sectionTitleStyle),
                if (state.cartDetail.isNotEmpty) ...{
                  GestureDetector(
                    onTap: () => cubit.deleteAllCart(),
                    child: Text(
                      'Kosongkan Cart',
                      style: redTextStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                }
              ],
            ),
            const DividerWidget(),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: state.cartDetail.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final cart = state.cartDetail[index];

                return ProductListTile(
                  inCart: true,
                  image: cart.product?.image ?? '',
                  productName: cart.product?.name,
                  productPrice: cart.totalBill ?? 0,
                  productQty: cart.qty.toString(),
                  onAddTap: () {
                    cubit.addItemCart(product: cart.product!);
                  },
                  onMinTap: () {
                    if (cart.qty! <= 1) {
                      cubit.deleteItem(id: cart.id!);
                      return;
                    } else {
                      cubit.removeItemCart(product: cart.product!);
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
