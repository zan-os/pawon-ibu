// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawon_ibu_app/common/utils/cubit_state.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

import '../cubit/address_map_picker_cubit.dart';
import '../cubit/address_map_picker_state.dart';

class AddressSelectionContainer extends StatefulWidget {
  final String address;
  final LatLng latlong;
  final Function onPressed;

  const AddressSelectionContainer({
    Key? key,
    required this.address,
    required this.latlong,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AddressSelectionContainer> createState() =>
      _AddressSelectionContainerState();
}

class _AddressSelectionContainerState extends State<AddressSelectionContainer> {
  bool _isReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AddressMapPickerCubit>().getAddressFromLonglat(widget.latlong);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressMapPickerCubit, AddressMapPickerState>(
      listener: (context, state) {
        if (state.status == CubitState.hasData && state.addressDetail != null) {
          setState(() {
            _isReady = true;
          });
        }
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        height: 230,
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTile(context),
            _buildAddressText(),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildConfirmButton(context),
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onPressed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Konfirmasi',
            style: whiteTextStyle,
          ),
        ],
      ),
    );
  }

  Padding _buildAddressText() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        widget.address,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        overflow: TextOverflow.fade,
        maxLines: 3,
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Pinpoint Alamat',
          style: blackTextStyle,
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Atur Ulang',
            style: blackTextStyle,
          ),
        ),
      ],
    );
  }
}
