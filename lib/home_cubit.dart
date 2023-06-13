import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
      return;
    }

    // Check permission to access gps
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(
            status: Status.error,
            errorMessage: 'Location permissions are denied'));
        return;
      }
    }

    // Check if permission denied
    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(
          status: Status.error,
          errorMessage:
              'Location permissions are permanently denied, we cannot request permissions.'));
      return;
    }

    try {
      final currentLatlong = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(state.copyWith(
          status: Status.complete, latlongPosition: currentLatlong));
      log(currentLatlong.toString());
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
