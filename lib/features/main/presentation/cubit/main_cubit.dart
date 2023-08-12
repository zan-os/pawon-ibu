import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/utils/cubit_state.dart';
import '../../../../common/utils/error_logger.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState(status: CubitState.initial));

  final _role = sl<SharedPreferences>().getInt('role');

  getRole() {
    if (_role == 1) {
      emit(state.copyWith(isAdmin: true));
    } else {
      emit(state.copyWith(isAdmin: false));
    }
  }

  changeIndex(int index) {
    try {
      emit(state.copyWith(currentIndex: index));
    } catch (e) {
      errorLogger(e);
    }
  }
}
