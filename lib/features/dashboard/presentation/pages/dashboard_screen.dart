// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/router/app_router.dart';
import 'package:pawon_ibu_app/common/utils/currency_formatter.dart';
import 'package:pawon_ibu_app/common/utils/currency_shorter.dart';
import 'package:pawon_ibu_app/features/dashboard/data/model/sales_model.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardDataScreen extends StatelessWidget {
  const DashboardDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return ListView(
              children: [
                SfCartesianChart(
                  crosshairBehavior: CrosshairBehavior(enable: true),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                  ),
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Penjualan Tahun 2023'),
                  // Enable legend
                  legend: const Legend(isVisible: true),
                  onChartTouchInteractionDown: (tapArgs) {
                    log('tap');
                  },

                  series: <ChartSeries<SalesModel, String>>[
                    BarSeries<SalesModel, String>(
                      dataLabelMapper: (datum, index) {
                        return currencyShorter(
                                state.sales[index].incomes ?? 0) ??
                            '';
                      },
                      isVisibleInLegend: false,
                      dataSource: state.sales,
                      xValueMapper: (SalesModel sales, _) => sales.month,
                      yValueMapper: (SalesModel sales, _) => sales.sales,
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true, textStyle: TextStyle(fontSize: 10)),
                    )
                  ],
                ),
                _FinancialRecordsTile(
                  title: 'Hasil Penjualan',
                  amount: state.grossIncome,
                  textStyle: blackTextStyle,
                ),
                _FinancialRecordsTile(
                  title: 'Total Pengeluaran',
                  amount: state.totalExpense,
                  textStyle: blackTextStyle,
                ),
                _FinancialRecordsTile(
                  title: 'Total Pendapatan',
                  amount: state.netIncome,
                  textStyle: productNameStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.order),
                  child: const Text('orders'),
                ),
                ElevatedButton(
                  onPressed: () => context.read<DashboardCubit>().init(),
                  child: const Text('orders'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ExpansionTile(
                    title: const Text('Total Penjualan Kue'),
                    children: [
                      Table(
                        border: TableBorder.all(color: greyColor),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: blueColor),
                            children: [
                              _TableCell(
                                title: 'Nama Kue',
                                textStyle: whiteTextStyle,
                              ),
                              _TableCell(
                                title: 'Harga',
                                textStyle: whiteTextStyle,
                              ),
                              _TableCell(
                                title: 'Terjual',
                                textStyle: whiteTextStyle,
                              ),
                            ],
                          ),
                          ...List.generate(state.bestSales.length, (index) {
                            final bestSales = state.bestSales[index];
                            return TableRow(
                              children: [
                                _TableCell(
                                  title: bestSales.productName ?? '',
                                  textStyle: blackTextStyle,
                                ),
                                _TableCell(
                                  title: formatRupiah(bestSales.productPrice),
                                  textStyle: blackTextStyle,
                                ),
                                _TableCell(
                                  title: bestSales.totalSold.toString(),
                                  textStyle: blackTextStyle,
                                ),
                              ],
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FinancialRecordsTile extends StatelessWidget {
  const _FinancialRecordsTile({
    Key? key,
    required this.title,
    required this.amount,
    required this.textStyle,
  }) : super(key: key);

  final String title;
  final int amount;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle),
          Text(formatRupiah(amount), style: textStyle),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    Key? key,
    required this.title,
    required this.textStyle,
  }) : super(key: key);

  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: textStyle,
        ),
      ),
    );
  }
}
