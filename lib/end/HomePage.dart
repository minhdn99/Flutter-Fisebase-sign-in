import 'package:authentification/end/search_bar.dart';
import 'package:authentification/start/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
// import 'dart:async';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:location/location.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController googleMapController;
  Map<MarkerId,Marker> markers = <MarkerId,Marker>{};
  Position position;
  String addressLocation;
  String country;
  String postalCode;

  void getMarkers(double lat,double long){
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueCyan
      ),
      infoWindow: InfoWindow(snippet: addressLocation));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosition = await GeolocatorPlatform
        .instance
         .getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
    getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      // constraints: BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 600.0,
            child: GoogleMap(
              onTap: (tapped) async{
                final coordinated = new geoCo.Coordinates(
                  tapped.latitude, tapped.longitude);
                var address = await geoCo.Geocoder.local
                    .findAddressesFromCoordinates(coordinated);
                var firstAddress = address.first;
                getMarkers(tapped.latitude, tapped.longitude);
                await FirebaseFirestore.instance
                   .collection('location')
                   .add({
                      'latitude' : tapped.latitude,
                      'longitude' : tapped.longitude,
                      'Adrress' : firstAddress.addressLine,
                      'Country' : firstAddress.countryCode,
                      'PostalCode' : firstAddress.postalCode
                });
                setState(() {
                  country = firstAddress.countryCode;
                  postalCode = firstAddress.postalCode;
                  addressLocation = firstAddress.addressLine;
                });
              },
              // mapType: MapType.hybrid,
              compassEnabled: true,
              trafficEnabled: true,
              onMapCreated: (GoogleMapController controller){
                setState(() {
                  googleMapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    position.latitude.toDouble(),
                    position.longitude.toDouble()),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
          ),

          Text('Adrress : $addressLocation'),
          Text('PostalCode : $postalCode'),
          Text('Country : $country'),
          Positioned(
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    actions: <Widget>[
                      FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.logout),
                        label: Text('Logout'),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: SearchBar(),
                  ),
                ],
          ),
          ),
        ],
      ),
    ));
  }
}



