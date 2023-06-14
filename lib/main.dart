import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:point_of_sales/home_cubit.dart';
import 'package:point_of_sales/home_state.dart';
import 'package:point_of_sales/widgets/address_picker_map.dart';
import 'package:point_of_sales/widgets/address_selection_container.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: MaterialApp(
        title: "Point Of Sales App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng _pointed = LatLng(0, 0);
  LatLng _latLong = LatLng(0, 0);
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    context.read<HomeCubit>().getCurrentLatlong();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.status == Status.loading) {
              log('ui loading');
            }
            if (state.status == Status.complete) {
              final position = state.latlongPosition;
              setState(() {
                _latLong =
                    LatLng(position?.latitude ?? 0, position?.longitude ?? 0);
                _mapController.move(_latLong, _mapController.zoom);
                _pointed =
                    LatLng(position?.latitude ?? 0, position?.longitude ?? 0);
                LatLng(position?.latitude ?? 0, position?.longitude ?? 0);
                log(_latLong.toString());
              });

              log('ui completed');
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: AddressPickerMap(mapController: _mapController)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      final addressDetail = state.addressDetail;
                      log('ojan ==> $addressDetail');
                      if (addressDetail != null) {
                        log('ojan success');
                        return AddressSelectionContainer(
                            addressDetail: addressDetail);
                      }
                      log('ojan null');
                      return const AddressSelectionContainer(
                          addressDetail: null);
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeCubit>().getCurrentLatlong();
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
