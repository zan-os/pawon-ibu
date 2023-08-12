// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/router/app_router.dart';
import 'package:pawon_ibu_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:pawon_ibu_app/features/order/presentation/cubit/order_state.dart';
import 'package:pawon_ibu_app/features/order/presentation/widgets/order_card_widget.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/core_injection.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap: false,
              children: [
                OrderStatusSection(
                  orderCount: state.notConfirmedTotal,
                  title: 'Menunggu Konfirmasi',
                  onTap: () => Navigator.pushNamed(
                      context, AppRouter.orderSection,
                      arguments: {
                        'title': 'Menunggu Konfirmasi',
                        'status': 1,
                      }).then(
                    (value) => cubit.init(),
                  ),
                ),
                const SizedBox(height: 16.0),
                OrderStatusSection(
                  orderCount: state.orderInProgressTotal,
                  title: 'Sedang Diproses',
                  onTap: () => Navigator.pushNamed(
                      context, AppRouter.orderSection,
                      arguments: {
                        'title': 'Sedang Diproses',
                        'status': 2,
                      }).then(
                    (value) => cubit.init(),
                  ),
                ),
                const SizedBox(height: 16.0),
                OrderStatusSection(
                  orderCount: state.readyToDeliverTotal,
                  title: 'Pesanan Siap Antar',
                  onTap: () => Navigator.pushNamed(
                      context, AppRouter.orderSection,
                      arguments: {
                        'title': 'Pesanan Siap Antar',
                        'status': 3,
                      }).then(
                    (value) => cubit.init(),
                  ),
                ),
                const SizedBox(height: 16.0),
                OrderStatusSection(
                  orderCount: state.inDeliverTotal,
                  title: 'Sedang Diantar',
                  onTap: () => Navigator.pushNamed(
                      context, AppRouter.orderSection,
                      arguments: {
                        'title': 'Sedang Diantar',
                        'status': 4,
                      }).then(
                    (value) => cubit.init(),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];

                        final buyerName =
                            '${order.user!.firstName!} ${order.user!.lastName!}';
                        return InkWell(
                          onTap: () {
                            sl<SharedPreferences>().setInt(
                              'created_transaction_id',
                              order.id!,
                            );
                            Navigator.pushNamed(
                              context,
                              AppRouter.orderDetail,
                              arguments: buyerName,
                            );
                          },
                          child: OrderCard(
                            status: order.transactionStatus ?? 1,
                            firstName: order.user?.firstName ?? '',
                            lastName: order.user?.lastName ?? '',
                            createdOrder: order.createdAt!,
                            totalBill: order.totalBill ?? 0,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class OrderStatusSection extends StatelessWidget {
  final String title;
  final Function onTap;
  final int orderCount;
  const OrderStatusSection({
    Key? key,
    required this.title,
    required this.onTap,
    required this.orderCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: blackTextStyle,
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                      child: (orderCount > 0)
                          ? Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: redColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                orderCount.toString(),
                                style: whiteTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                  const WidgetSpan(
                    child: Icon(
                      CupertinoIcons.forward,
                      color: blackColor,
                      size: 19,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
