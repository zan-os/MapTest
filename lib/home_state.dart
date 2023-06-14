// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeState extends Equatable {
  final Position? latlongPosition;
  final Placemark? addressDetail;
  final String? errorMessage;
  final Status? status;

  const HomeState({
    this.latlongPosition,
    this.addressDetail,
    this.errorMessage = "",
    this.status = Status.loading,
  });

  HomeState copyWith(
      {Position? latlongPosition,
      String? errorMessage,
      Status? status,
      Placemark? addressDetail}) {
    return HomeState(
        latlongPosition: latlongPosition ?? this.latlongPosition,
        addressDetail: addressDetail ?? this.addressDetail,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [
        latlongPosition,
        errorMessage,
        status,
        addressDetail,
      ];
}

enum Status {
  loading,
  complete,
  error,
}
