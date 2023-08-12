import 'package:flutter/material.dart';
import 'package:pawon_ibu_app/features/auth/presentation/widgets/register_form.dart';

import 'login_form.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Sign In'),
              Tab(text: 'Sign Up'),
            ],
          ),
          SizedBox(
            height: size.height * 0.7,
            width: size.width * 1,
            child: const TabBarView(
              children: [
                LoginForm(),
                RegisterForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
