import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/router/app_router.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/widgets/rounded_blue_drawable.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/utils/currency_formatter.dart';
import '../../../../core/di/core_injection.dart';
import '../../../../ui/drawable/rounded_white_drawable.dart';
import '../../../../ui/widgets/order_card_widget.dart';
import '../../../../ui/widgets/statistic_data_widget.dart';
import '../../data/model/feature_grid_model.dart';
import '../cubit/dashboard_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Scaffold(
      body: EasyRefresh(
        onRefresh: () => cubit.init(),
        triggerAxis: Axis.vertical,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              _buildHomeHeader(),
              _buildHomeBody(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeBody({required BuildContext context}) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 16.0),
        _buildStatisticData(),
        _buildGridView(),
        const SizedBox(height: 16.0),
        _buildNewTransaction(context)
      ],
    );
  }

  Column _buildNewTransaction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pesanan Baru', style: sectionTitleStyle),
        const SizedBox(height: 8.0),
        BlocBuilder<DashboardCubit, DashboardState>(
          bloc: context.read<DashboardCubit>()..init(),
          builder: (context, state) {
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.newOrder.length,
                itemBuilder: (context, index) {
                  final order = state.newOrder[index];
                  final buyerName =
                      '${order.user!.firstName!} ${order.user!.lastName!}';
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () async {
                        sl<SharedPreferences>().setInt(
                          'created_transaction_id',
                          order.id!,
                        );
                        Navigator.pushNamed(
                          context,
                          AppRouter.orderDetail,
                          arguments: buyerName,
                        ).then(
                            (value) => context.read<DashboardCubit>().init());
                      },
                      child: OrderCard(
                        bankImage: order.paymentType!.image!,
                        bankName: order.paymentType!.name!,
                        status: order.transactionStatus ?? 1,
                        createdOrder: order.createdAt!,
                        firstName: order.user!.firstName!,
                        lastName: order.user!.lastName!,
                        totalBill: order.totalBill!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  GridView _buildGridView() {
    final List<FeatureGridModel> featureGridItem = [
      const FeatureGridModel(
        icon: Icons.add_box_outlined,
        title: 'Tambah Produk',
        page: AppRouter.addProduct,
      ),
      const FeatureGridModel(
        icon: Icons.add_business_outlined,
        title: 'Catatan Penjualan',
        page: AppRouter.salesData,
      ),
      const FeatureGridModel(
        icon: Icons.stacked_bar_chart_outlined,
        title: 'List Transaksi',
        page: AppRouter.order,
      ),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: featureGridItem.length,
      itemBuilder: (context, index) {
        final item = featureGridItem[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedContainerDrawable(
            onTap: () {
              if (item.page.isNotEmpty) {
                Navigator.pushNamed(context, item.page);
              }
            },
            padding: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Set the icon/logo of features from here
                Icon(item.icon, size: 40.0),
                const SizedBox(height: 14.0),
                // Set the title of features from here
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeHeader() {
    return const RoundedBlueDrawable();
  }

  Widget _buildStatisticData() {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) => RoundedContainerDrawable(
        onTap: () {},
        child: StatisticDataWidget(
          tProduct: state.totalProdct,
          tNewOrder: state.totalNewOrder,
          tTransaction: state.totalTransaction,
          tIncome: formatRupiah(state.netIncome),
        ),
      ),
    );
  }
}
