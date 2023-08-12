import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/router/app_router.dart';
import '../../../../common/utils/cubit_state.dart';
import '../../../../core/di/core_injection.dart';
import '../../../../ui/helper/show_snackbar.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/app_title.dart';
import '../widgets/tab_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Focus.of(context).requestFocus(sl<FocusNode>()),
      child: BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(),
        child: const _AuthScreenContent(),
      ),
    );
  }
}

class _AuthScreenContent extends StatefulWidget {
  const _AuthScreenContent();

  @override
  State<_AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<_AuthScreenContent> {
  final supabase = Supabase.instance.client;
  final unfocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(unfocusNode);
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: const Scaffold(
          backgroundColor: Colors.white,
          body: _AuthBody(),
        ),
      ),
    );
  }
}

class _AuthBody extends StatelessWidget {
  const _AuthBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthenticateState>(
      builder: (context, state) {
        if (state.status == CubitState.loading) {}
        if (state.status == CubitState.hasData) {}
        if (state.status == CubitState.error) {}
        return const SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTitle(),
                TabBarWidget(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == CubitState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                LoadingAnimationWidget.inkDrop(color: Colors.white, size: 50),
          );
        }
        if (state.status == CubitState.finishLoading) {
          Navigator.pop(context);
        }

        if (state.status == CubitState.success) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacementNamed(
            context,
            AppRouter.main,
          );
        }
        if (state.status == CubitState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar(state.message, isError: true),
          );
        }
      },
    );
  }
}
