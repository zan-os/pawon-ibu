import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/common/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';
import '../../../../core/di/core_injection.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthenticateState> {
  AuthCubit() : super(const AuthenticateState(status: CubitState.initial));

  static final _supabase = sl<SupabaseClient>();

  void loginWithEmail(String email, String password) async {
    emit(state.copyWith(status: CubitState.loading));

    try {
      final response = await _supabase
          .from('user')
          .select()
          .eq('email', email)
          .eq('password', password)
          .single();

      final user = UserModel.fromJson(response);

      sl<SharedPreferences>().setString('email', email);
      sl<SharedPreferences>().setInt('user_id', user.id!);
      sl<SharedPreferences>().setInt('role', user.roleId!);

      emit(state.copyWith(status: CubitState.success));
      emit(state.copyWith(status: CubitState.initial));
    } catch (e) {
      errorLogger(e);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
        status: CubitState.error,
        message: 'Something went wrong',
      ));
    }
  }

  void singUpWithEmail(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      await _supabase.from('user').insert({
        'role_id': 2,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'email': email,
      });
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.hasData));

      loginWithEmail(email, password);
    } catch (e) {
      errorLogger(e);
      emit(state.copyWith(status: CubitState.finishLoading));
    }
  }
}
