import 'package:equatable/equatable.dart';

import '../../../../common/utils/cubit_state.dart';

class AuthenticateState extends Equatable {
  final CubitState status;
  final String message;

  const AuthenticateState({
    required this.status,
    this.message = '',
  });

  AuthenticateState copyWith({
    CubitState? status,
    String? message,
    String? userId,
  }) {
    return AuthenticateState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
