import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawon_ibu_app/core/di/core_injection.dart';
import 'package:pawon_ibu_app/features/map_picker/presentation/cubit/address_map_picker_cubit.dart';
import 'package:pawon_ibu_app/features/map_picker/presentation/cubit/address_map_picker_state.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/address_picker_map.dart';
import '../widgets/address_selection_container.dart';

class AddressMapPickerScreen extends StatefulWidget {
  const AddressMapPickerScreen({super.key});

  @override
  State<AddressMapPickerScreen> createState() => _AddressMapPickerScreenState();
}

class _AddressMapPickerScreenState extends State<AddressMapPickerScreen> {
  late AddressMapPickerCubit _cubit;
  late MapController _mapController;

  final _prefs = sl<SharedPreferences>();
  late double lat;
  late double long;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AddressMapPickerCubit>()..init();
    lat = _prefs.getDouble('lat') ?? 0;
    long = _prefs.getDouble('long') ?? 0;
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: BlocBuilder<AddressMapPickerCubit, AddressMapPickerState>(
          builder: (context, state) {
            final addressDetail = state.addressDetail;
            String addressFromLatLng =
                '${addressDetail?.street}, ${addressDetail?.locality}, ${addressDetail?.subLocality}, ${addressDetail?.subAdministrativeArea}, ${addressDetail?.administrativeArea}';
            return Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: AddressPickerMap(
                      mapController: _mapController,
                      latLong: LatLng(lat, long),
                      onPointerUp: (latlong) {
                        context
                            .read<AddressMapPickerCubit>()
                            .getAddressFromLonglat(latlong);
                        context
                            .read<AddressMapPickerCubit>()
                            .setCurrentLatLong(latlng: latlong);
                      },
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AddressSelectionContainer(
                    address: addressFromLatLng,
                    latlong: LatLng(lat, long),
                    onPressed: () async {
                      await sl<SharedPreferences>().setDouble(
                        'picked_lat',
                        state.currentLatLng?.latitude ?? lat,
                      );
                      await sl<SharedPreferences>().setDouble(
                        'picked_long',
                        state.currentLatLng?.longitude ?? long,
                      );
                      if (context.mounted) {
                        Navigator.pop(context, addressFromLatLng);
                      }
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: whiteColor,
      elevation: 0.0,
      title: const Text(
        'Tentukan Pinpoint',
      ),
      automaticallyImplyLeading: false,
    );
  }
}
