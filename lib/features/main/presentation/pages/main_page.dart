import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/features/cart/presentation/ui/cart_screen.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:pawon_ibu_app/features/transaction/presentation/pages/transaction_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../ui/theme/app_theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../cubit/main_cubit.dart';
import '../cubit/main_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<SalomonBottomBarItem> _adminBottomItems = [
    SalomonBottomBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: const Text("Dashboard"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(CupertinoIcons.bag),
      title: const Text("Shop"),
      selectedColor: Colors.pink,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profile"),
      selectedColor: Colors.teal,
    ),
  ];

  static final List<SalomonBottomBarItem> _customerBottomItems = [
    SalomonBottomBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: const Text("Home"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(CupertinoIcons.shopping_cart),
      title: const Text("Keranjang"),
      selectedColor: Colors.pink,
    ),
    SalomonBottomBarItem(
      icon: const Icon(CupertinoIcons.square_favorites_fill),
      title: const Text("Transaksi"),
      selectedColor: Colors.orange,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profile"),
      selectedColor: Colors.teal,
    ),
  ];

  static final List<Widget> _customerBodyList = [
    const HomePage(),
    const CartScreen(),
    const TransactionScreen(),
    const Center(
      child: Text('Profile'),
    ),
  ];

  static final List<Widget> _adminBodyList = [
    const DashboardScreen(),
    const HomePage(),
    const Center(
      child: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (_, state) {
        final MainCubit cubit = context.read<MainCubit>();
        return Scaffold(
          body: (state.isAdmin)
              ? _adminBodyList[state.currentIndex]
              : _customerBodyList[state.currentIndex],
          bottomNavigationBar: Material(
            elevation: 2,
            child: SalomonBottomBar(
              backgroundColor: whiteColor,
              items: (state.isAdmin) ? _adminBottomItems : _customerBottomItems,
              currentIndex: state.currentIndex,
              onTap: (index) => cubit.changeIndex(index),
            ),
          ),
        );
      },
    );
  }
}
