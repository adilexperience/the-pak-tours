import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<PlaceModel> nearbyPlaces = [];

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  LatLng? _currentLocation;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _currentPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // get user current location
    // get places near user location in radius of kilometers
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    await ApiRequests.determinePosition(context).then((value) async {
      await animateToPointer(LatLng(value.latitude, value.longitude));
    });
  }

  Future<void> animateToPointer(
    LatLng latLng, {
    bool displayMarker = true,
    String markerID = "current_location",
    String markerTitle = "My Location",
  }) async {
    _currentLocation = latLng;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: Constants.mapDefaultZoom,
        ),
      ),
    );

    nearbyPlaces = await ApiRequests.getNearbyPlaces(_currentLocation!);
    for (var place in nearbyPlaces) {
      LatLng _latLng = LatLng(
        place.location.latitude,
        place.location.longitude,
      );
      addMarker(
        place.id,
        _latLng,
        place.title,
        description: place.description,
      );
    }

    if (displayMarker) {
      addMarker(markerID, latLng, markerTitle);
    }

    setState(() {});
  }

  void addMarker(String markerID, LatLng latLng, String markerTitle,
      {String? description}) {
    _markers[MarkerId(markerID)] = Marker(
      markerId: MarkerId(markerID),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: markerTitle, snippet: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(bottom: 150.0),
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _currentPosition,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: _markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 80.0,
            left: 0.0,
            right: 0.0,
            child: _currentLocation == null
                ? const SizedBox.shrink()
                : SafeArea(
                    child: SizedBox(
                      height: 230.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                          left: 8.0,
                          bottom: MediaQuery.of(context).size.height * 0.01,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: nearbyPlaces.length,
                        itemBuilder: (BuildContext context, int index) {
                          PlaceModel _place = nearbyPlaces[index];
                          return PlaceCard(
                            isFirstOfList: (index == 0),
                            place: _place,
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
