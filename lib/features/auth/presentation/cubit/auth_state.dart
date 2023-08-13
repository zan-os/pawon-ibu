import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../common/utils/cubit_state.dart';

class AuthenticateState extends Equatable {
  final CubitState status;
  final String message;
  final LatLng currentLatLng;

  const AuthenticateState({
    required this.status,
    this.message = '',
    this.currentLatLng = const LatLng(0, 0),
  });

  AuthenticateState copyWith({
    CubitState? status,
    String? message,
    LatLng? currentLatLng,
  }) {
    return AuthenticateState(
      status: status ?? this.status,
      message: message ?? this.message,
      currentLatLng: currentLatLng ?? this.currentLatLng,
    );
  }

  @override
  List<Object> get props => [status, message, currentLatLng];
}
