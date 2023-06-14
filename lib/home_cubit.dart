import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:point_of_sales/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  init() {
    getCurrentLatlong();
  }

  Future<void> getCurrentLatlong() async {
    emit(state.copyWith(status: Status.loading));

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
            errorMessage: 'Location permissions are denied'));
      }
    }

    // Check if permission denied
    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(
          status: Status.error,
          errorMessage:
              'Location permissions are permanently denied, we cannot request permissions.'));
    }

    try {
      final currentLatlong = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5),
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      emit(state.copyWith(
          status: Status.complete, latlongPosition: currentLatlong));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> getAddressFromLonglat(LatLng? position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position?.latitude ?? 0, position?.longitude ?? 0);
      Placemark place = placemarks.first;
      log('addressDetail ==> $place');
      emit(state.copyWith(status: Status.complete, addressDetail: place));
      log('ojan cubit ==> ${state.addressDetail}');
    } catch (e) {
      log('Error when reversing geocode ==> $e');
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
