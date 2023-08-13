import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:pawon_ibu_app/ui/widgets/divider_widget.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../ui/widgets/product_list_tile.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buyerName = ModalRoute.of(context)!.settings.arguments as String;
    final cubit = context.read<TransactionCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
        elevation: 1,
      ),
      body: EasyRefresh(
        onRefresh: () => cubit.init(),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: whiteColor,
              child: BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  final totalBill = state.totalBill;
                  return Column(
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
                      Text(
                        state.user.address ?? '-',
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
                            state.orderDetail.firstOrNull?.transaction
                                    ?.paymentType?.name ??
                                '',
                            style: sectionTitleStyle,
                          ),
                          SvgPicture.network(
                            state.orderDetail.firstOrNull?.transaction
                                    ?.paymentType?.image ??
                                '',
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Nomor Rekening',
                                style: descStyle.copyWith(fontSize: 12),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                state.orderDetail.firstOrNull?.transaction
                                        ?.paymentType?.accountNumber ??
                                    '',
                                style: sectionTitleStyle,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async => await Clipboard.setData(
                              ClipboardData(
                                text: state.orderDetail.firstOrNull?.transaction
                                        ?.paymentType?.accountNumber ??
                                    '',
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
                                        CupertinoIcons
                                            .square_fill_on_square_fill,
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
                      Row(
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
                                        CupertinoIcons
                                            .square_fill_on_square_fill,
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
                      const DividerWidget(
                        padding: 1,
                      ),
                    ],
                  );
                },
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
                  BlocBuilder<TransactionCubit, TransactionState>(
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
                  BlocBuilder<TransactionCubit, TransactionState>(
                      builder: (context, state) {
                    final orderStatus = state.orderStatus;
                    if (orderStatus < 5) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            cubit.reachSeller();
                          },
                          child: const Text('Hubungi Penjual'),
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
      ),
    );
  }
}
