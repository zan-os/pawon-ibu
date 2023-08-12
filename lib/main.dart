import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/constants/app_constants.dart';
import 'package:pawon_ibu_app/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:pawon_ibu_app/features/cart/presentation/ui/cart_screen.dart';
import 'package:pawon_ibu_app/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:pawon_ibu_app/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:pawon_ibu_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:pawon_ibu_app/features/order/presentation/pages/order_detail_screen.dart';
import 'package:pawon_ibu_app/features/order/presentation/pages/order_screen.dart';
import 'package:pawon_ibu_app/features/order/presentation/pages/order_section_screen.dart';
import 'package:pawon_ibu_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:pawon_ibu_app/features/payment/presentation/page/payment_screen.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common/router/app_router.dart';
import 'core/di/core_injection.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/detail_product/presentation/pages/product_detail_page.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/main/presentation/cubit/main_cubit.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'registered_injection.dart' as di;

Future main() async {
  await sl.allReady();
  await Supabase.initialize(
    url: AppConstants.projectUrl,
    anonKey: AppConstants.anonKey,
  );
  di.RegisteredInjection.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      initialRoute: AppRouter.auth,
      routes: {
        AppRouter.auth: (context) => BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
              child: const AuthPage(),
            ),
        AppRouter.main: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<MainCubit>(
                  create: (context) => MainCubit()..getRole(),
                ),
                BlocProvider<HomeCubit>(
                  create: (context) => HomeCubit(),
                ),
                BlocProvider(
                  create: (context) => DashboardCubit()..init(),
                )
              ],
              child: const MainPage(),
            ),
        AppRouter.cart: (context) => BlocProvider<CartCubit>(
              create: (context) => CartCubit(),
              child: const CartScreen(),
            ),
        AppRouter.checkout: (context) => BlocProvider<CheckoutCubit>(
              create: (context) => CheckoutCubit(),
              child: const CheckoutScreen(),
            ),
        AppRouter.payment: (context) => BlocProvider<PaymentCubit>(
              create: (context) => PaymentCubit()..fetchTransaction(),
              child: const PaymentScreen(),
            ),
        AppRouter.order: (context) => BlocProvider<OrderCubit>(
              create: (context) => OrderCubit()..init(),
              child: const OrderScreen(),
            ),
        AppRouter.orderSection: (context) => BlocProvider<OrderCubit>(
              create: (context) => OrderCubit(),
              child: const OrderSectionScreen(),
            ),
        AppRouter.orderDetail: (context) => BlocProvider<OrderCubit>(
              create: (context) => OrderCubit()..fetchOrderDetail(),
              child: const OrderDetailScreen(),
            ),
        AppRouter.detailProduct: (context) => const ProductDetailPage(),
      },
    );
  }
}
