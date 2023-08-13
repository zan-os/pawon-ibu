import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../cubit/address_map_picker_cubit.dart';

class AddressPickerMap extends StatefulWidget {
  final LatLng latLong;
  final MapController mapController;
  final Function(LatLng)? onPointerUp;

  const AddressPickerMap(
      {super.key,
      required this.mapController,
      required this.latLong,
      this.onPointerUp});

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  late AddressMapPickerCubit bloc;
  final pointSize = 40.0;
  LatLng? latLng;

  @override
  void initState() {
    super.initState();
    latLng = widget.latLong;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<AddressMapPickerCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: _buildMapOptions(),
      children: [
        _buildTileLayer(),
        _buildMarkerLayer(),
      ],
    );
  }

  MarkerLayer _buildMarkerLayer() {
    return MarkerLayer(
      markers: [
        Marker(
          width: 60,
          height: 60,
          point: latLng!,
          builder: (ctx) => Container(
              margin: const EdgeInsets.only(bottom: 23),
              child: const Icon(CupertinoIcons.map_pin)),
        ),
        Marker(
          width: 3,
          height: 3,
          point: latLng!,
          builder: (ctx) => Container(
            color: Colors.amber,
          ),
        )
      ],
    );
  }

  TileLayer _buildTileLayer() {
    return TileLayer(
      maxNativeZoom: 17,
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.point_of_sales',
    );
  }

  MapOptions _buildMapOptions() {
    return MapOptions(
      maxZoom: 17,
      interactiveFlags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
      center: latLng,
      zoom: 17,
      onPointerUp: (event, point) {
        if (widget.onPointerUp != null) {
          widget.onPointerUp!(latLng ?? const LatLng(0, 0));
        }
      },
      onMapEvent: (event) {
        updatePoint(null, context);
      },
    );
  }

  void updatePoint(MapEvent? event, BuildContext context) {
    final pointX = _getPointX(context);
    final pointY = _getPointY(context);
    setState(() {
      latLng = widget.mapController.pointToLatLng(CustomPoint(pointX, pointY));
    });
  }

  double _getPointX(BuildContext context) {
    return MediaQuery.of(context).size.width / 2;
  }

  double _getPointY(BuildContext context) {
    return MediaQuery.of(context).size.height / 3.24;
  }
}
