import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../ui/helper/show_snackbar.dart';
import '../../../../ui/widgets/rounded_bordered_text_field.dart';
import '../../../../ui/widgets/rounded_button.dart';
import '../cubit/auth_cubit.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final unfocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isFormValid(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
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
                controller: _firstNameController,
                keyboardType: TextInputType.visiblePassword,
                obsecureText: false,
                enabled: true,
                label: 'Nama Lengkap',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedBorderedTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: true,
                label: 'Email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedBorderedTextField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obsecureText: true,
                enabled: true,
                label: 'Password',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedBorderedTextField(
                controller: _addressController,
                keyboardType: TextInputType.visiblePassword,
                obsecureText: false,
                enabled: true,
                label: 'Alamat',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedBorderedTextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.visiblePassword,
                obsecureText: false,
                enabled: true,
                label: 'Nomor Handphone',
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: RoundedButton(
                onTap: () {
                  final String email = _emailController.text.trim();
                  final String password = _passwordController.text.trim();
                  final String firstName = _firstNameController.text.trim();
                  final String lastName = _addressController.text.trim();

                  FocusScope.of(context).requestFocus(unfocusNode);

                  (isFormValid(email, password))
                      ? context.read<AuthCubit>().singUpWithEmail(
                          email: email,
                          password: password,
                          firstName: firstName,
                          lastName: lastName)
                      : ScaffoldMessenger.of(context).showSnackBar(
                          showSnackBar('Harap isi form dengan benar',
                              isError: true),
                        );
                },
                title: 'Sign Up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
