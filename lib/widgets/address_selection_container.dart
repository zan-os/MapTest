import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AddressSelectionContainer extends StatelessWidget {
  const AddressSelectionContainer({
    super.key,
    required this.addressDetail,
  });

  final Placemark? addressDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTile(),
          _buildAddressText(),
          const SizedBox(height: 16.0),
          _buildConfirmButton(context)
        ],
      ),
    );
  }

  SizedBox _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(
            Color(0xFF7B5E8C),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: const Text(
          'Konfirmasi',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Padding _buildAddressText() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        '${addressDetail?.street}, ${addressDetail?.locality}, ${addressDetail?.subLocality}, ${addressDetail?.subAdministrativeArea}, ${addressDetail?.administrativeArea}',
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        overflow: TextOverflow.fade,
        maxLines: 3,
      ),
    );
  }

  Text _buildTile() {
    return const Text(
      'Pilih Pinpoint Alamat',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
