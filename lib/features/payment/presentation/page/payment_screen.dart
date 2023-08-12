import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawon_ibu_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:pawon_ibu_app/ui/widgets/divider_widget.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../ui/widgets/product_list_tile.dart';
import '../cubit/payment_state.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const bcaAccount = '7425419188';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        leading: InkWell(
          onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: const Icon(Icons.arrow_back),
        ),
        elevation: 1,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: whiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                BlocBuilder<PaymentCubit, PaymentState>(
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
                              text: state.totalBill.toString(),
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
                BlocBuilder<PaymentCubit, PaymentState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.transaction.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final transaction = state.transaction[index];

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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ),
                    child: const Text('Belanja yang lain'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
