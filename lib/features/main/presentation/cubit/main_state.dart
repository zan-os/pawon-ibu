import 'package:equatable/equatable.dart';

import '../../../../common/utils/cubit_state.dart';

class MainState extends Equatable {
  final CubitState status;
  final int currentIndex;
  final bool isAdmin;

  const MainState({
    this.status = CubitState.initial,
    this.currentIndex = 0,
    this.isAdmin = false,
  });

  MainState copyWith({
    CubitState? status,
    int? currentIndex,
    bool? isAdmin,
  }) {
    return MainState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  List<Object> get props => [status, currentIndex, isAdmin];
}
