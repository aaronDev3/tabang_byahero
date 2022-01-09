import 'dart:io';

import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ByaheroMap extends StatefulWidget {
  @override
  _ByaheroMapState createState() => _ByaheroMapState();
}

class _ByaheroMapState extends State<ByaheroMap> {
  LatLng initialPosition = LatLng(8.5380, 124.7889); //(latitude,longitude)
  GoogleMapController controller;
  BitmapDescriptor autoshopIcon;
  BitmapDescriptor gasolineIcon;
  BitmapDescriptor mechanicIcon;
  final Set<Marker> markers = new Set();

  getAllGasoline() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllGasoline();
    print(queryRows);
    return queryRows;
  }

  getAllMechanic() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllMechanic();
    print(queryRows);
    return queryRows;
  }

  createMarker1(context) {
    if (autoshopIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/image/autoshop.png')
          .then((icon) {
        setState(() {
          autoshopIcon = icon;
        });
      });
    }
  }

  createMarker2(context) {
    if (gasolineIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/image/gasoline.png')
          .then((icon) {
        setState(() {
          gasolineIcon = icon;
        });
      });
    }
  }

  createMarker3(context) {
    if (mechanicIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/image/mechanic.png')
          .then((icon) {
        setState(() {
          mechanicIcon = icon;
        });
      });
    }
  }

  getAutoshopService(String _shopId) async {
    List<Map> search =
        await DatabaseHelper.instance.searchAutoshopService(_shopId);
    return search;
  }

  getGasService(String _gasId) async {
    List<Map> search = await DatabaseHelper.instance.searchGasService(_gasId);
    return search;
  }

  getMechanicService(String _mechanicId) async {
    List<Map> search =
        await DatabaseHelper.instance.searchMechanicService(_mechanicId);
    return search;
  }

  void showInfo(
      String id,
      String img,
      String name,
      String contactNo,
      String address,
      String startDay,
      String endDay,
      String startTime,
      String endTime,
      String userType,
      int distanceMeters) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DefaultTabController(
          length: 1,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  children: [
                    Image(
                      image: Image.file(
                        File(img),
                        fit: BoxFit.cover,
                      ).image,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.8,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, top: 5),
                      width: 162,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.blue,
                                ),
                                Text(
                                  contactNo,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            onTap: () {
                              String phoneno = "tel:$contactNo";
                              launch(phoneno);
                            }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5, top: 5),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: Text(
                                "X",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 8, left: 20, right: 15, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 11),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.blue),
                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11),
                Row(
                  children: [
                    Icon(Icons.access_time_outlined, color: Colors.blue),
                    Text('Open: $startDay - $endDay ($startTime - $endTime)',
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                SizedBox(height: 11),
                Row(
                  children: [
                    Icon(Icons.directions_outlined, color: Colors.blue),
                    Text('$distanceMeters meters away',
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                FutureBuilder(
                    future: userType == 'autoshop'
                        ? getAutoshopService(id)
                        : userType == 'gasoline'
                            ? getGasService(id)
                            : userType == 'mechanic'
                                ? getMechanicService(id)
                                : '',
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Expanded(
                        child: TabBarView(children: <Widget>[
                          Container(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) => Card(
                                child: ListTile(
                                  title: Text(userType == 'autoshop'
                                      ? snapshot.data[index]['shopServiceName']
                                      : userType == 'gasoline'
                                          ? snapshot.data[index]['gasFuelName']
                                          : userType == 'mechanic'
                                              ? snapshot.data[index]
                                                  ['mechanicServiceName']
                                              : ''),
                                  trailing: Text(userType == 'autoshop'
                                      ? '₱${snapshot.data[index]['shopServicePrice']}'
                                      : userType == 'gasoline'
                                          ? '₱${snapshot.data[index]['gasFuelPrice']}'
                                          : userType == 'mechanic'
                                              ? '₱${snapshot.data[index]['mechanicServicePrice']}'
                                              : ''),
                                ),
                              ),
                            ),
                          )
                        ]),
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    createMarker1(context);
    createMarker2(context);
    createMarker3(context);
    //final Set<Marker> markers = new Set();

    getAllMarker() async {
      List<Map<String, dynamic>> queryAllShop, queryAllGas, queryAllMechanic;
      queryAllShop = await DatabaseHelper.instance.queryAllAutoshop();

      queryAllGas = await DatabaseHelper.instance.queryAllGasoline();

      queryAllMechanic = await DatabaseHelper.instance.queryAllMechanic();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      for (var i = 0; i < queryAllShop.length; i++) {
        double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            queryAllShop[i]['shopLatitude'],
            queryAllShop[i]['shopLongitude']);

        int distanceMeters = distanceInMeters.toInt();
        markers.add(Marker(
            markerId: MarkerId(queryAllShop[i]['shopId']),
            position: LatLng(queryAllShop[i]['shopLatitude'],
                queryAllShop[i]['shopLongitude']),
            infoWindow: InfoWindow(title: queryAllShop[i]['shopName']),
            icon: autoshopIcon,
            onTap: () {
              String strImage = queryAllShop[i]['shopImage'];
              print(queryAllShop.length);

              showInfo(
                  queryAllShop[i]['shopId'],
                  strImage,
                  queryAllShop[i]['shopName'],
                  queryAllShop[i]['shopContact'],
                  queryAllShop[i]['shopAddress'],
                  queryAllShop[i]['shopStartDay'],
                  queryAllShop[i]['shopEndDay'],
                  queryAllShop[i]['shopStartTime'],
                  queryAllShop[i]['shopEndTime'],
                  'autoshop',
                  distanceMeters);
            }));
      }

      for (var i = 0; i < queryAllGas.length; i++) {
        double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            queryAllGas[i]['gasLatitude'],
            queryAllGas[i]['gasLongitude']);
        int distanceMeters = distanceInMeters.toInt();
        markers.add(
          Marker(
              markerId: MarkerId(queryAllGas[i]['gasId']),
              position: LatLng(queryAllGas[i]['gasLatitude'],
                  queryAllGas[i]['gasLongitude']),
              infoWindow: InfoWindow(title: queryAllGas[i]['gasName']),
              icon: gasolineIcon,
              onTap: () async {
                String strImage = queryAllGas[i]['gasImage'];

                showInfo(
                    queryAllGas[i]['gasId'],
                    strImage,
                    queryAllGas[i]['gasName'],
                    queryAllGas[i]['gasContact'],
                    queryAllGas[i]['gasAddress'],
                    queryAllGas[i]['gasStartDay'],
                    queryAllGas[i]['gasEndDay'],
                    queryAllGas[i]['gasStartTime'],
                    queryAllGas[i]['gasEndTime'],
                    'gasoline',
                    distanceMeters);
              }),
        );
      }

      for (var i = 0; i < queryAllMechanic.length; i++) {
        double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            queryAllMechanic[i]['mechanicLatitude'],
            queryAllMechanic[i]['mechanicLongitude']);
        int distanceMeters = distanceInMeters.toInt();
        markers.add(Marker(
            markerId: MarkerId(queryAllMechanic[i]['mechanicId']),
            position: LatLng(queryAllMechanic[i]['mechanicLatitude'],
                queryAllMechanic[i]['mechanicLongitude']),
            infoWindow: InfoWindow(title: queryAllMechanic[i]['mechanicName']),
            icon: mechanicIcon,
            onTap: () {
              String strImage = queryAllMechanic[i]['mechanicImage'];

              showInfo(
                  queryAllMechanic[i]['mechanicId'],
                  strImage,
                  queryAllMechanic[i]['mechanicName'],
                  queryAllMechanic[i]['mechanicContact'],
                  queryAllMechanic[i]['mechanicAddress'],
                  queryAllMechanic[i]['mechanicStartDay'],
                  queryAllMechanic[i]['mechanicEndDay'],
                  queryAllMechanic[i]['mechanicStartTime'],
                  queryAllMechanic[i]['mechanicEndTime'],
                  'mechanic',
                  distanceMeters);
            }));
      }

      return queryAllShop;
    }

    return FutureBuilder(
        future: getAllMarker(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Tabang Byahero"),
              centerTitle: true,
              actions: <Widget>[
                TextButton(
                  child: Row(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(
                        Icons.login_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 18.5,
                ),
                mapType: MapType.hybrid,
                myLocationEnabled: true,
                markers: markers,
                minMaxZoomPreference: MinMaxZoomPreference(17.0, 20.0),
                cameraTargetBounds: new CameraTargetBounds(
                  new LatLngBounds(
                      southwest: LatLng(8.41284365914289, 124.60562566983957),
                      northeast: LatLng(8.55032519047117, 124.81002709805455)),
                ),
              ),
            ),
          );
        });
  }
}
