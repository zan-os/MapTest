import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class HomeState extends Equatable {
  final Position? latlongPosition;
  final String? errorMessage;
  final Status? status;

  const HomeState({
    this.latlongPosition,
    this.errorMessage = "",
    this.status = Status.loading,
  });

  HomeState copyWith(
      {Position? latlongPosition, String? errorMessage, Status? status}) {
    return HomeState(
        latlongPosition: latlongPosition ?? this.latlongPosition,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [latlongPosition, errorMessage, status];
}

enum Status {
  loading,
  complete,
  error,
}
