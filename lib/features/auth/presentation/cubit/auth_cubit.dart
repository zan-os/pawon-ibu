import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
  static final _prefrences = sl<SharedPreferences>();

  init() {
    getCurrentLatlong();
  }

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
    } catch (e, s) {
      errorLogger(e, s);
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
    } catch (e, s) {
      errorLogger(e, s);
      emit(state.copyWith(status: CubitState.finishLoading));
    }
  }

  Future<void> getCurrentLatlong() async {
    log('ojan executed');
    // Check if gps is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(
          status: CubitState.error,
          message: 'Location services are disabled.'));
    }

    // Check permission to access gps
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(
          status: CubitState.error,
          message: 'Location permissions are denied',
        ));
      }
    }

    // Check if permission denied
    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(
        status: CubitState.error,
        message:
            'Location permissions are permanently denied, we cannot request permissions.',
      ));
    }

    try {
      emit(state.copyWith(status: CubitState.loading));
      // final position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.bestForNavigation,
      // );

      // final currentLatlong = LatLng(position.latitude, position.longitude);
      // await _prefrences.setDouble('lat', currentLatlong.latitude);
      // await _prefrences.setDouble('long', currentLatlong.longitude);

      log('ojan lat ${_prefrences.getDouble('lat')}');
      log('ojan long ${_prefrences.getDouble('long')}');
    } catch (e) {
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }
}
