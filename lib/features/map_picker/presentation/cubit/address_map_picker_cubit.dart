import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_map_picker_state.dart';

class AddressMapPickerCubit extends Cubit<AddressMapPickerState> {
  AddressMapPickerCubit() : super(const AddressMapPickerState());

  final lat = sl<SharedPreferences>().getDouble('lat');
  final long = sl<SharedPreferences>().getDouble('long');

  init() {
    getAddressFromLonglat(LatLng(lat!, long!));
  }

  void setCurrentLatLong({required LatLng latlng}) {
    emit(state.copyWith(currentLatLng: latlng));
  }

  Future<void> getCurrentLatlong() async {
    // Check if gps is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(
          status: Status.error,
          errorMessage: 'Location services are disabled.'));
    }

    // Check permission to access gps
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: 'Location permissions are denied',
        ));
      }
    }

    // Check if permission denied
    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage:
            'Location permissions are permanently denied, we cannot request permissions.',
      ));
    }

    try {
      emit(state.copyWith(status: Status.loading));
      final position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5),
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      final currentLatlong = LatLng(position.latitude, position.longitude);
      emit(state.copyWith(
          status: Status.complete,
          latlongPosition: position,
          currentLatLng: currentLatlong));
      getAddressFromLonglat(currentLatlong);
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> getAddressFromLonglat(LatLng? position) async {
    try {
      emit(state.copyWith(status: Status.loading, addressDetail: null));
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position?.latitude ?? 0, position?.longitude ?? 0);
      Placemark place = placemarks.first;
      emit(state.copyWith(status: Status.complete, addressDetail: place));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
