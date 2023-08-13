// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/utils/currency_formatter.dart';
import '../../common/utils/date_time_formatter.dart';
import '../theme/app_theme.dart';
import 'divider_widget.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.createdOrder,
    required this.totalBill,
    required this.status,
    required this.bankName,
    required this.bankImage,
  }) : super(key: key);

  final String firstName;
  final String lastName;
  final DateTime createdOrder;
  final int totalBill;
  final int status;
  final String bankName;
  final String bankImage;

  String getStatus({required int status}) {
    switch (status) {
      case 1:
        return 'Menunggu Pembayaran';
      case 2:
        return 'Sedang Diproses';
      case 3:
        return 'Pesanan Sudah Jadi';
      case 4:
        return 'Sedang Diantar';
      case 5:
        return 'Pesanan Selesai';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: firstName,
                        style: productNameStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(right: 3.0),
                        ),
                      ),
                      TextSpan(
                        text: lastName,
                        style: productNameStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dipesan Pada',
                      style: descStyle.copyWith(fontSize: 11),
                    ),
                    Text(
                      dateTimeFormatter(createdOrder),
                      style: productNameStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const DividerWidget(padding: 4.0),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: SvgPicture.network(
                      bankImage,
                      height: 16,
                      width: 16,
                    ),
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                    ),
                  ),
                  TextSpan(
                    text: bankName,
                    style: productNameStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const DividerWidget(padding: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: descStyle.copyWith(fontSize: 11),
                    ),
                    Text(
                      formatRupiah(totalBill),
                      style: productNameStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greenColor),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    getStatus(status: status),
                    style: greenTextStyle.copyWith(fontSize: 13),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
