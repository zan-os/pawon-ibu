import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/router/app_router.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ui/widgets/order_card_widget.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';

class TransactionSectionScreen extends StatelessWidget {
  const TransactionSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final cubit = context.read<TransactionCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        bloc: setInitFetch(args['status'], context),
        buildWhen: (previous, current) {
          return current.orderSection != previous.orderSection;
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: EasyRefresh(
              onRefresh: () => cubit.init(),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0);
                },
                itemCount: state.orderSection.length,
                itemBuilder: (context, index) {
                  final order = state.orderSection[index];
                  final buyerName =
                      '${order.user!.firstName!} ${order.user!.lastName!}';
                  return InkWell(
                    onTap: () async {
                      sl<SharedPreferences>().setInt(
                        'created_transaction_id',
                        order.id!,
                      );
                      Navigator.pushNamed(
                        context,
                        AppRouter.transactionDetail,
                        arguments: buyerName,
                      ).then((value) => setInitFetch(args['status'], context));
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  TransactionCubit setInitFetch(int status, BuildContext context) {
    final cubit = context.read<TransactionCubit>();

    switch (status) {
      case 1:
        return cubit..fetchNotConfirmedOrder();
      case 2:
        return cubit..fetchInProgressOrder();
      case 3:
        return cubit..fetchReadyToDeliverOrder();
      case 4:
        return cubit..fetchInDeliverOrder();
      default:
        return cubit..fetchNotConfirmedOrder();
    }
  }
}
