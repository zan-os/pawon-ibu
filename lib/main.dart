import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawon_ibu_app/common/constants/app_constants.dart';
import 'package:pawon_ibu_app/features/add_product/presentation/cubit/add_product_cubit.dart';
import 'package:pawon_ibu_app/features/add_product/presentation/ui/add_product_screen.dart';
import 'package:pawon_ibu_app/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:pawon_ibu_app/features/cart/presentation/ui/cart_screen.dart';
import 'package:pawon_ibu_app/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:pawon_ibu_app/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:pawon_ibu_app/features/map_picker/presentation/cubit/address_map_picker_cubit.dart';
import 'package:pawon_ibu_app/features/map_picker/presentation/pages/address_map_picker_screen.dart';
import 'package:pawon_ibu_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:pawon_ibu_app/features/order/presentation/pages/order_detail_screen.dart';
import 'package:pawon_ibu_app/features/order/presentation/pages/order_screen.dart';
import 'package:pawon_ibu_app/features/order/presentation/pages/order_section_screen.dart';
import 'package:pawon_ibu_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:pawon_ibu_app/features/payment/presentation/page/payment_screen.dart';
import 'package:pawon_ibu_app/features/sales_data/presentation/cubit/sales_data_cubit.dart';
import 'package:pawon_ibu_app/features/sales_data/presentation/pages/sales_data_screen.dart';
import 'package:pawon_ibu_app/features/transaction/presentation/cubit/transaction_cubit.dart';
import 'package:pawon_ibu_app/features/transaction/presentation/pages/transaction_detail_screen.dart';
import 'package:pawon_ibu_app/features/transaction/presentation/pages/transaction_screen.dart';
import 'package:pawon_ibu_app/features/transaction/presentation/pages/transaction_section_screen.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

main() async {
  await sl.allReady();
  await Supabase.initialize(
    url: AppConstants.projectUrl,
    anonKey: AppConstants.anonKey,
  );
  di.RegisteredInjection.init();

  // Check if gps is enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {}

  // Check permission to access gps
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );

  final currentLatlong = LatLng(position.latitude, position.longitude);
  await sl<SharedPreferences>().setDouble('lat', currentLatlong.latitude);
  await sl<SharedPreferences>().setDouble('long', currentLatlong.longitude);
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
              create: (context) => AuthCubit()..init(),
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
                BlocProvider<DashboardCubit>(
                  create: (context) => DashboardCubit()..init(),
                ),
                BlocProvider<TransactionCubit>(
                  create: (context) => TransactionCubit()..init(),
                ),
                BlocProvider<CartCubit>(
                  create: (context) => CartCubit()..init(),
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
        AppRouter.transaction: (context) => BlocProvider<TransactionCubit>(
              create: (context) => TransactionCubit()..init(),
              child: const TransactionScreen(),
            ),
        AppRouter.transactionSection: (context) =>
            BlocProvider<TransactionCubit>(
              create: (context) => TransactionCubit(),
              child: const TransactionSectionScreen(),
            ),
        AppRouter.transactionDetail: (context) =>
            BlocProvider<TransactionCubit>(
              create: (context) => TransactionCubit()..fetchOrderDetail(),
              child: const TransactionDetailScreen(),
            ),
        AppRouter.salesData: (context) => BlocProvider<SalesDataCubit>(
              create: (context) => SalesDataCubit()..init(),
              child: const SalesDataScreen(),
            ),
        AppRouter.addProduct: (context) => BlocProvider<AddProductCubit>(
              create: (context) => AddProductCubit(),
              child: const AddProductScreen(),
            ),
        AppRouter.addressMapPicker: (context) =>
            BlocProvider<AddressMapPickerCubit>(
              create: (context) => AddressMapPickerCubit()..init(),
              child: const AddressMapPickerScreen(),
            ),
        AppRouter.detailProduct: (context) => const ProductDetailPage(),
      },
    );
  }
}
