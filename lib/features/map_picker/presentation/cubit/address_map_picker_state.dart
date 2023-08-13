import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../data/model/noniatim_address_response_model.dart';

class AddressMapPickerState extends Equatable {
  final Position? latlongPosition;
  final Placemark? addressDetail;
  final String errorMessage;
  final Status? status;
  final LatLng? currentLatLng;
  final List<NoniatimAddressResponseModel> addressList;

  const AddressMapPickerState({
    this.latlongPosition,
    this.addressDetail,
    this.currentLatLng,
    this.errorMessage = "",
    this.status = Status.loading,
    this.addressList = const [],
  });

  AddressMapPickerState copyWith(
      {Position? latlongPosition,
      String? errorMessage,
      Status? status,
      Placemark? addressDetail,
      LatLng? currentLatLng,
      List<NoniatimAddressResponseModel>? addressList}) {
    return AddressMapPickerState(
        latlongPosition: latlongPosition ?? this.latlongPosition,
        addressDetail: addressDetail ?? this.addressDetail,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        addressList: addressList ?? this.addressList,
        currentLatLng: currentLatLng ?? this.currentLatLng);
  }

  @override
  List<Object?> get props => [
        latlongPosition,
        errorMessage,
        status,
        addressDetail,
        addressList,
        currentLatLng
      ];
}

enum Status {
  loading,
  complete,
  error,
}
