import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../ui/theme/app_theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../cubit/main_cubit.dart';
import '../cubit/main_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<SalomonBottomBarItem> _bottomBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.favorite_border),
      title: const Text("Likes"),
      selectedColor: Colors.pink,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.search),
      title: const Text("Search"),
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
    const Center(
      child: Text('Likes'),
    ),
    const Center(
      child: Text('Search'),
    ),
    const Center(
      child: Text('Profile'),
    ),
  ];

  static final List<Widget> _adminBodyList = [
    const DashboardDataScreen(),
    const Center(
      child: Text('Likes'),
    ),
    const Center(
      child: Text('Search'),
    ),
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
              items: _bottomBarItems,
              currentIndex: state.currentIndex,
              onTap: (index) => cubit.changeIndex(index),
            ),
          ),
        );
      },
    );
  }
}
