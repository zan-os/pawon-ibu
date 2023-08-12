import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../ui/helper/show_snackbar.dart';
import '../../../../ui/widgets/rounded_bordered_text_field.dart';
import '../../../../ui/widgets/rounded_button.dart';
import '../cubit/auth_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final unfocusNode = FocusNode();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isFormValid(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedBorderedTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: true,
                label: 'Email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedBorderedTextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obsecureText: true,
                enabled: true,
                label: 'Password',
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: RoundedButton(
                onTap: () {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  FocusScope.of(context).requestFocus(unfocusNode);
                  (isFormValid(email, password))
                      ? context
                          .read<AuthCubit>()
                          .loginWithEmail(email, password)
                      : ScaffoldMessenger.of(context).showSnackBar(
                          showSnackBar('Harap isi form dengan benar',
                              isError: true),
                        );
                },
                title: 'Sign In',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
