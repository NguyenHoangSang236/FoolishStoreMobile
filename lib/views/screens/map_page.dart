import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:fashionstore/data/repository/map_repository.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/position_extension.dart';
import 'package:fashionstore/views/components/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../data/dto/place.dart';
import '../../service/map_service.dart';
import '../../utils/render/ui_render.dart';

@RoutePage()
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late Position _currentPosition;
  LatLng? _currentLatLng;
  final TextEditingController _searchingController = TextEditingController();
  List<Place> _suggestionLPlaceList = [];

  // on below line we have specified camera position
  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(10.776103859974496, 106.70548616672234),
    zoom: 15,
  );

  final List<Marker> _markers = <Marker>[];

  void _comeBack() {
    context.router.pop();
  }

  void _addMarkerOnMap({
    required LatLng latLng,
  }) async {
    setState(() {
      _currentLatLng = latLng;

      _markers.removeWhere((marker) => marker.markerId.value == 'My Location');
      _markers.add(
        Marker(
          markerId: const MarkerId('My Location'),
          position: latLng,
          infoWindow: const InfoWindow(
            title: 'Searching Location',
          ),
        ),
      );
    });
  }

  void _animateCameraToPosition(LatLng latLng) async {
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 14,
    );

    setState(() {
      _currentLatLng = latLng;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  void _addMarkerAndAnimateCameraToPosition(LatLng latLng) async {
    _addMarkerOnMap(latLng: latLng);

    _animateCameraToPosition(latLng);
  }

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    List<String> results = [];
    final response = await MapRepository().getAddressSuggestion(searchValue);

    response.fold(
      (failure) => results.add(failure.message),
      (list) {
        setState(() {
          _suggestionLPlaceList = List.of(list);

          for (Place place in list) {
            results.add(place.fullAddress);
          }
        });
      },
    );

    return results;
  }

  void _selectPlace(String address) {
    Place selectedPlace = _suggestionLPlaceList.firstWhere(
      (place) => place.fullAddress == address,
    );

    debugPrint('Selected $address');

    _addMarkerAndAnimateCameraToPosition(
      LatLng(selectedPlace.latitude, selectedPlace.longitude),
    );
  }

  void _clearSearchBox() {
    setState(() {
      _searchingController.clear();
    });
  }

  void _confirmLocation() {
    if (_currentLatLng != null) {
      context.read<CartBloc>().add(
            OnLoadAddressCodeRequestEvent(_currentLatLng!),
          );

      context.router.pop();
    } else {
      UiRender.showDialog(
        context,
        '',
        'Please choose a location for us to ship your order!',
      );
    }
  }

  @override
  void initState() {
    MapService.getUserCurrentLocation(context)
        .then((value) => _currentPosition = value);

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: _cameraPosition,
              markers: Set<Marker>.of(_markers),
              mapType: MapType.terrain,
              myLocationEnabled: false,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Positioned(
            top: 40.height,
            left: 10.width,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50.radius),
                  ),
                  child: IconButton(
                    onPressed: _comeBack,
                    alignment: Alignment.center,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                20.horizontalSpace,
                Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  decoration: const BoxDecoration(color: Colors.white),
                  alignment: Alignment.center,
                  child: EasyAutocomplete(
                    controller: _searchingController,
                    asyncSuggestions: _fetchSuggestions,
                    progressIndicatorBuilder: UiRender.loadingCircle(),
                    suggestionBuilder: _suggestionPlace,
                    inputTextStyle: TextStyle(
                      fontSize: 14.size,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search your location here...',
                      hintStyle: TextStyle(
                        fontSize: 14.size,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.width,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.radius),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.radius),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                        ),
                      ),
                      suffixIcon: SizedBox(
                        height: 25.size,
                        width: 25.size,
                        child: IconButton(
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.orange,
                          ),
                          onPressed: _clearSearchBox,
                        ),
                      ),
                    ),
                    onSubmitted: _selectPlace,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GradientElevatedButton(
              text: 'Confirm Location',
              onPress: _confirmLocation,
              buttonMargin: EdgeInsets.zero,
              buttonHeight: 50.height,
            ),
            FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () => _addMarkerAndAnimateCameraToPosition(
                _currentPosition.toLatLng,
              ),
              child: const Icon(Icons.my_location, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _suggestionPlace(String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.height),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            color: Colors.orange,
          ),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.orange,
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15.size,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
