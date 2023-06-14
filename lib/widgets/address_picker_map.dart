import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:point_of_sales/home_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressPickerMap extends StatefulWidget {
  final MapController mapController;

  const AddressPickerMap({super.key, required this.mapController});

  @override
  State<AddressPickerMap> createState() => _AddressPickerMapState();
}

class _AddressPickerMapState extends State<AddressPickerMap> {
  final _bloc = HomeCubit();
  LatLng _pointed = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: _buildMapOptions(),
      nonRotatedChildren: [
        _buildRichAttributWidget(),
      ],
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
          point: _pointed,
          builder: (context) => Image.asset('assets/icons/ic-pinpoint-map.png'),
        )
      ],
    );
  }

  TileLayer _buildTileLayer() {
    return TileLayer(
      maxNativeZoom: 18,
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.point_of_sales',
    );
  }

  RichAttributionWidget _buildRichAttributWidget() {
    return RichAttributionWidget(
      attributions: [
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () => launchUrl(
            Uri.parse('https://openstreetmap.org/copyright'),
          ),
        ),
      ],
    );
  }

  MapOptions _buildMapOptions() {
    return MapOptions(
      maxZoom: 18,
      onPointerDown: (event, point) {
        setState(() {
          _pointed = point;
        });
        context.read<HomeCubit>().getAddressFromLonglat(point);
      },
      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
      center: LatLng(0, 0),
      zoom: 18,
    );
  }
}
