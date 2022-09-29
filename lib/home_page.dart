import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocationData currentPosition;
  late GoogleMapController mapController;
  Location location = Location();
  LatLng initialcameraposition = LatLng(14.965892, 103.094505);

  late Marker marker;
  List<Marker> markers = <Marker>[];

  String myLocation = 'no';
  late BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context, initialcameraposition);
                  print(
                      'save ${initialcameraposition.longitude} : ${initialcameraposition.latitude}');
                },
                icon: Icon(Icons.save),
              ),
            ],
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: initialcameraposition,
          zoom: 15,
        ),
        markers: Set<Marker>.of(markers),
        mapType: MapType.normal,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getLoc,
        label: Text('Me'),
        icon: Icon(Icons.near_me),
      ),
    );
  }

  void getLoc() async {
    myLocation = 'yes';
    print('myLocation $myLocation');
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
    double? latitude = 16.244761;
    double? longitude = 103.2472083;
    location.onLocationChanged.listen(
      (LocationData currentLocation) {
        setState(() {
          print(
              'Current Loc ${currentPosition.latitude} : ${currentPosition.longitude}');
          initialcameraposition = LatLng(latitude, longitude);
          mapController
              .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
          setMarkers();
        });
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print(
        'oncreted ${initialcameraposition.longitude} : ${initialcameraposition.latitude}');
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: initialcameraposition, zoom: 12),
      ),
    );
    setMarkers();
  }

  void setMarkers() {
    createMarker(context);
    markers.add(
      Marker(
        markerId: MarkerId('Home'),
        position: initialcameraposition,
        icon: customIcon,
        infoWindow: InfoWindow(
          title: myLocation,
        ),
      ),
    );
    setState(() {});
  }

  createMarker(context) {
    if (myLocation == 'yes') {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
              'images\flag.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }
}
