import 'package:flutter/material.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

class StatisticDataWidget extends StatelessWidget {
  final int tProduct, tNewOrder, tTransaction;
  final String tIncome;
  const StatisticDataWidget({
    super.key,
    this.tProduct = 0,
    this.tNewOrder = 0,
    this.tTransaction = 0,
    this.tIncome = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildStatisticWidget(tNewOrder.toString(), 'Pesanan Baru'),
            _buildStatisticWidget(tProduct.toString(), 'Total Produk'),
          ],
        ),
        const SizedBox(height: 8.0),
        const Divider(thickness: 1.0),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildStatisticWidget(tTransaction.toString(), 'Total Transaksi'),
            _buildStatisticWidget(tIncome.toString(), 'Total Pemasukan'),
          ],
        ),
      ],
    );
  }

  Column _buildStatisticWidget(String count, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16.0,
            color: blueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            color: greyColor,
          ),
        ),
      ],
    );
  }
}
