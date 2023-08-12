import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawon_ibu_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:pawon_ibu_app/features/order/presentation/cubit/order_state.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:pawon_ibu_app/ui/widgets/divider_widget.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../ui/widgets/product_list_tile.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  static const bcaAccount = '7425419188';

  static final TextEditingController _expansesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final buyerName = ModalRoute.of(context)!.settings.arguments as String;
    final cubit = context.read<OrderCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        elevation: 1,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  buyerName,
                  style: productNameStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const DividerWidget(
                  padding: 1,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bank Central Asia',
                      style: sectionTitleStyle,
                    ),
                    SvgPicture.asset(
                      'assets/logo/bca_logo.svg',
                      width: 16,
                      height: 16,
                    )
                  ],
                ),
                const DividerWidget(
                  padding: 1,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nomor Rekening',
                          style: descStyle.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          bcaAccount,
                          style: sectionTitleStyle,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async => await Clipboard.setData(
                        const ClipboardData(text: bcaAccount),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Salin',
                              style: blueTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Icon(
                                  CupertinoIcons.square_fill_on_square_fill,
                                  color: blueColor,
                                  size: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const DividerWidget(padding: 1),
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    final totalBill = state.totalBill;
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: descStyle.copyWith(fontSize: 12),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              formatRupiah(totalBill),
                              style: sectionTitleStyle,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async => await Clipboard.setData(
                            ClipboardData(
                              text: totalBill.toString(),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Salin',
                                  style: blueTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.0),
                                    child: Icon(
                                      CupertinoIcons.square_fill_on_square_fill,
                                      color: blueColor,
                                      size: 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const DividerWidget(
                  padding: 1,
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          // List product section
          Container(
            padding: const EdgeInsets.all(16),
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Produk Yang Dibeli',
                  style: sectionTitleStyle.copyWith(fontSize: 15),
                ),
                const DividerWidget(
                  padding: 1,
                ),
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.orderDetail.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final transaction = state.orderDetail[index];

                        return ProductListTile(
                          inCart: false,
                          image: transaction.product?.image ?? '',
                          productName: transaction.product?.name,
                          productPrice: transaction.price,
                          productQty: transaction.qty.toString(),
                          onAddTap: () {},
                          onMinTap: () {},
                        );
                      },
                    );
                  },
                ),
                const DividerWidget(
                  padding: 1,
                ),
                BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
                  final orderStatus = state.orderStatus;
                  if (orderStatus < 5) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await setAction(orderStatus, context);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          setButtonText(orderStatus),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showOutcomeDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Berapa biaya pengeluaran untuk produk ini?'),
              TextField(
                controller: _expansesController,
                decoration: const InputDecoration(hintText: 'Rp.50.000'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await context.read<OrderCubit>().completeProcess(
                      expanses: int.parse(_expansesController.text),
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            )
          ],
        );
      },
    );
  }

  Future<void>? setAction(int status, BuildContext context) {
    final cubit = context.read<OrderCubit>();

    switch (status) {
      case 1:
        return cubit.confirmOrder();
      case 2:
        return showOutcomeDialog(context);
      case 3:
        return cubit.deliverOrder();
      case 4:
        return cubit.completeOrder();
      default:
        return null;
    }
  }

  String setButtonText(int status) {
    switch (status) {
      case 1:
        return 'Konfirmasi Pesanan';
      case 2:
        return 'Pesanan Sudah Siap';
      case 3:
        return 'Antar Pesanan';
      case 4:
        return 'Pesanan Selesai';
      default:
        return 'Error';
    }
  }
}
