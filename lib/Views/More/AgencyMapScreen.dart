import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgencyMapScreen extends StatefulWidget {
  const AgencyMapScreen({super.key});

  @override
  _AgencyMapScreenState createState() => _AgencyMapScreenState();
}

class _AgencyMapScreenState extends State<AgencyMapScreen> {
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _textColor = Color(0xFF1B1D4D);

  // Define agency locations
  final List<Map<String, dynamic>> _agencies = [
    {
      'title': 'Centre-ville Tunis',
      'lat': 36.799, // Approximate latitude for Tunis
      'lng': 10.180, // Approximate longitude for Tunis
      'address': 'Avenue Habib Bourguiba, 1001 Tunis',
    },
    {
      'title': 'La Marsa',
      'lat': 36.878, // Approximate latitude for La Marsa
      'lng': 10.325, // Approximate longitude for La Marsa
      'address': 'Rue de la Plage, 2078 La Marsa',
    },
  ];

  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Move the camera to a central point covering both agencies
    _mapController?.moveCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(36.8385, 10.2525), // Approximate midpoint between Tunis and La Marsa
        11.0, // Zoom level to show both markers
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nos agences',
          style: TextStyle(
            color: _textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(36.8385, 10.2525),
          zoom: 11.0,
        ),
        markers: _agencies.map((agency) {
          return Marker(
            markerId: MarkerId(agency['title']),
            position: LatLng(agency['lat'], agency['lng']),
            infoWindow: InfoWindow(
              title: agency['title'],
              snippet: agency['address'],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          );
        }).toSet(),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}