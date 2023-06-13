import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:point_of_sales/home_cubit.dart';
import 'package:point_of_sales/home_state.dart';
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
    return MaterialApp(
      title: "Point Of Sales App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bloc = HomeCubit();

  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              log(state.status.toString());
              if (state.status == Status.loading) {
                log('loading');
                return Container();
              }
              final String errorMessage = state.errorMessage ?? '';
              if (state.status == Status.error) {
                log('Error ==> $errorMessage');
                return Container();
              }

              final Position? currentLatlong = state.latlongPosition;
              final LatLng latLong = LatLng(currentLatlong?.latitude ?? 0,
                  currentLatlong?.longitude ?? 0);
              if (state.status == Status.complete) {
                log('Success buka map');
                return FlutterMap(
                  options: MapOptions(
                      interactiveFlags:
                          InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      center: latLong,
                      zoom: 15.9),
                  nonRotatedChildren: [
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright'),
                          ),
                        ),
                      ],
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.point_of_sales',
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bloc.getCurrentLatlong();
          },
          child: const Icon(Icons.location_on),
        ),
      ),
    );
  }
}
