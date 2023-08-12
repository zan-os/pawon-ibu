import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pawon_ibu_app/common/router/app_router.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/currency_formatter.dart';
import '../../../../ui/helper/show_snackbar.dart';
import '../../../../ui/widgets/divider_widget.dart';
import '../../../../ui/widgets/rounded_button_widget.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
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
    final cubit = context.read<CheckoutCubit>();
    return SafeArea(
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
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
          if (state.status == CubitState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar(state.message, isError: true),
            );
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

  Future<void> _showPaymentDialog(
    BuildContext context,
    int totalBill,
    Function onPayTap,
  ) {
    final cubit = context.read<CheckoutCubit>();
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          backgroundColor: lightBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pembayaran baru dapat dilakukan dengan transfer bank & pengecekan secara manual',
                style: blackTextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Tagihan',
                      style: sectionTitleStyle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      formatRupiah(totalBill),
                      style: sectionTitleStyle,
                    ),
                  ],
                ),
                BlocBuilder<CheckoutCubit, CheckoutState>(
                  bloc: cubit,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        onPayTap();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Lanjut Bayar'),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        bloc: cubit,
        builder: (context, state) {
          return RoundedButtonWidget(
            enable: state.cartDetail.isNotEmpty,
            title: 'Bayar',
            onTap: () {
              if (state.cartDetail.isNotEmpty && state.enableButton) {
                _showPaymentDialog(
                    context, state.cartDetail.first.totalBill ?? 0, () async {
                  await cubit.createOrder();
                  cubit.deleteAllCart();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouter.payment,
                      arguments: state.createdTransactionId,
                    );
                  }
                });
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
        Text('Subtotal', style: sectionTitleStyle),
        BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) => Text(
            formatRupiah(state.totalBill),
            style: sectionTitleStyle,
          ),
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
        Text('Detail Pembayaran', style: sectionTitleStyle),
        const DividerWidget(),
        BlocBuilder<CheckoutCubit, CheckoutState>(
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
    final cubit = context.read<CheckoutCubit>();
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final user = state.userData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alamat Pengiriman',
              style: sectionTitleStyle,
            ),
            const DividerWidget(),
            Text('${user.firstName} ${user.lastName}',
                style: blackTextStyle.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w500)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(user.telepon ?? '',
                  style: blackTextStyle.copyWith(fontSize: 13)),
            ),
            Text(
              user.address ?? '',
              style: greyTextStyle.copyWith(fontSize: 13),
            ),
            const DividerWidget(),
          ],
        );
      },
    );
  }
}
