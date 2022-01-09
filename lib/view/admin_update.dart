import 'dart:async';
import 'dart:io';
import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:byahero_app/services/add_marker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AdminUpdate extends StatefulWidget {
  @override
  _AdminUpdateState createState() => _AdminUpdateState();
}

class _AdminUpdateState extends State<AdminUpdate> {
  File _image;

  LatLng mapMarker;
  LatLng updateLoc;
  final picker = ImagePicker();
  var name = new TextEditingController();
  var contact = new TextEditingController();

  var service = new TextEditingController();
  var price = new TextEditingController();

  var address = "";
  var addressTemp = "";
  var myControllersService = [];
  var myControllersPrice = [];
  int countService;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List<String> items = <String>[
    'Select day',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String startTimeChange;

  String startDay = 'Select';
  String endDay = 'Select';

  String _startTime = '00:00';
  String _endTime = '00:00';

  Future<void> startTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _startTime = picked.format(context);
      });
    }
  }

  Future<void> endTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _endTime = picked.format(context);
      });
    }
  }

  List<AddDynamic> listDynamic = [];

  _addDynamic() {
    listDynamic.add(new AddDynamic());
    setState(() {});
  }

  void _pickedMarker(LatLng marker) async {
    setState(() {
      mapMarker = marker;
    });
  }

  void markerPicker() async {
    final getMarker = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => AddMarker()),
    );
    _pickedMarker(getMarker);
  }

  GoogleMapController controller;
  Location location = Location();

  void _onMapCreated(GoogleMapController myController) {
    controller = myController;
    location.onLocationChanged().listen((l) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: mapMarker, zoom: 18.5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    @override
    final List user = ModalRoute.of(context).settings.arguments;

    Marker sampleMarker;

    getDetails() async {
      if (user[1] == 'autoshop') {
        List<Map<String, dynamic>> queryRows =
            await DatabaseHelper.instance.shopFromList(user[0]);

        try {
          if (mapMarker == null) {
            sampleMarker = Marker(
              markerId: MarkerId('Marker1'),
              position: LatLng(
                  queryRows[0]['shopLatitude'], queryRows[0]['shopLongitude']),
            );
          }
        } catch (e) {}
        return queryRows;
      } else if (user[1] == 'gasoline') {
        List<Map<String, dynamic>> queryRows1 =
            await DatabaseHelper.instance.gasFromList(user[0]);

        try {
          if (mapMarker == null) {
            sampleMarker = Marker(
              markerId: MarkerId('Marker1'),
              position: LatLng(
                  queryRows1[0]['gasLatitude'], queryRows1[0]['gasLongitude']),
            );
          }
        } catch (e) {}
        return queryRows1;
      } else if (user[1] == 'mechanic') {
        List<Map<String, dynamic>> queryRows2 =
            await DatabaseHelper.instance.mechanicFromList(user[0]);

        try {
          if (mapMarker == null) {
            sampleMarker = Marker(
              markerId: MarkerId('Marker1'),
              position: LatLng(queryRows2[0]['mechanicLatitude'],
                  queryRows2[0]['mechanicLongitude']),
            );
          }
        } catch (e) {}
        return queryRows2;
      } else if (user[1] == 'autoshopOwner') {
        List<Map<String, dynamic>> queryAutoshop =
            await DatabaseHelper.instance.searchAutoshop('${user[0]}');

        try {
          if (mapMarker == null) {
            sampleMarker = Marker(
              markerId: MarkerId('Marker1'),
              position: LatLng(queryAutoshop[0]['shopLatitude'],
                  queryAutoshop[0]['shopLongitude']),
            );
          }
        } catch (e) {}
        return queryAutoshop;
      } else if (user[1] == 'gasOwner') {
        List<Map<String, dynamic>> queryGasoline =
            await DatabaseHelper.instance.searchGasoline('${user[0]}');

        try {
          if (mapMarker == null) {
            sampleMarker = Marker(
              markerId: MarkerId('Marker1'),
              position: LatLng(queryGasoline[0]['gasLatitude'],
                  queryGasoline[0]['gasLongitude']),
            );
          }
        } catch (e) {}
        return queryGasoline;
      } else if (user[1] == 'mechanicOwner') {
        List<Map<String, dynamic>> queryMechanic =
            await DatabaseHelper.instance.searchMechanic('${user[0]}');

        try {
          if (mapMarker == null) {
            sampleMarker = Marker(
              markerId: MarkerId('Marker1'),
              position: LatLng(queryMechanic[0]['mechanicLatitude'],
                  queryMechanic[0]['mechanicLongitude']),
            );
          }
        } catch (e) {}
        return queryMechanic;
      }
    }

    getAutoshopService(String shopId) async {
      List<Map<String, dynamic>> queryRows =
          await DatabaseHelper.instance.searchAutoshopService(shopId);

      return queryRows;
    }

    getGasolineService(String gasId) async {
      List<Map<String, dynamic>> queryRows =
          await DatabaseHelper.instance.searchGasService(gasId);

      return queryRows;
    }

    getMechanicService(String mechanicId) async {
      List<Map<String, dynamic>> queryRows =
          await DatabaseHelper.instance.searchMechanicService(mechanicId);

      return queryRows;
    }

    sampleMarker = Marker(
      markerId: MarkerId('Marker1'),
      position: mapMarker,
    );

    return FutureBuilder(
        future: getDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/image/service.jpg"),
                    alignment: Alignment.topCenter),
              ),
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: [
                        Container(
                          height: 64,
                          margin: EdgeInsets.only(top: 25, left: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (user[1] == 'autoshop') {
                                          Navigator.pushNamed(
                                              context, '/adminList',
                                              arguments: 'autoshop');
                                        } else if (user[1] == 'gasoline') {
                                          Navigator.pushNamed(
                                              context, '/adminList',
                                              arguments: 'gasoline');
                                        } else if (user[1] == 'mechanic') {
                                          Navigator.pushNamed(
                                              context, '/adminList',
                                              arguments: 'mechanic');
                                        } else if (user[1] == 'autoshopOwner') {
                                          List idAndUserType = [
                                            snapshot.data[0]['userid'],
                                            'autoshop'
                                          ];
                                          Navigator.pushNamed(
                                              context, '/byaheroDetails',
                                              arguments: idAndUserType);
                                        } else if (user[1] == 'gasOwner') {
                                          List idAndUserType = [
                                            snapshot.data[0]['userid'],
                                            'gasoline'
                                          ];
                                          Navigator.pushNamed(
                                              context, '/byaheroDetails',
                                              arguments: idAndUserType);
                                        } else if (user[1] == 'mechanicOwner') {
                                          List idAndUserType = [
                                            snapshot.data[0]['userid'],
                                            'mechanic'
                                          ];
                                          Navigator.pushNamed(
                                              context, '/byaheroDetails',
                                              arguments: idAndUserType);
                                        }
                                      }),
                                  Text(''),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 64,
                          margin: EdgeInsets.only(top: 25, left: 317),
                          //margin: EdgeInsets.only(top: 25, left: 270),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                    onTap: () async {
                                      int updateId;
                                      print("click");

                                      try {
                                        final coordinates = new Coordinates(
                                            mapMarker.latitude,
                                            mapMarker.longitude);
                                        var _address = await Geocoder.local
                                            .findAddressesFromCoordinates(
                                                coordinates);

                                        address = _address.first.addressLine;
                                      } catch (e) {}

                                      if (user[1] == 'autoshop' ||
                                          user[1] == 'autoshopOwner') {
                                        if (name.text == "") {
                                          name.text =
                                              (snapshot.data[0]['shopName']);
                                        }
                                        if (contact.text == "") {
                                          contact.text =
                                              (snapshot.data[0]['shopContact']);
                                        }
                                        if (startDay == 'Select') {
                                          startDay = (snapshot.data[0]
                                              ['shopStartDay']);
                                        }
                                        if (endDay == "Select") {
                                          endDay =
                                              (snapshot.data[0]['shopEndDay']);
                                        }
                                        if (_startTime == '00:00') {
                                          _startTime = (snapshot.data[0]
                                              ['shopStartTime']);
                                        }
                                        if (_endTime == '00:00') {
                                          _endTime =
                                              (snapshot.data[0]['shopEndTime']);
                                        }
                                        if (_image == null) {
                                          _image = File(
                                              snapshot.data[0]['shopImage']);
                                        }
                                        if (mapMarker == null) {
                                          mapMarker = LatLng(
                                              snapshot.data[0]['shopLatitude'],
                                              snapshot.data[0]
                                                  ['shopLongitude']);

                                          //-----------------------TO BE DELETE-------------------------
                                          final coordinates = new Coordinates(
                                              snapshot.data[0]['shopLatitude'],
                                              snapshot.data[0]
                                                  ['shopLongitude']);
                                          var _address1 = await Geocoder.local
                                              .findAddressesFromCoordinates(
                                                  coordinates);
                                          address = _address1.first.addressLine;
                                        }

                                        String strImage =
                                            _image.path.toString();

                                        updateId = await DatabaseHelper.instance
                                            .updateAutoshop({
                                          DatabaseHelper.shopId:
                                              snapshot.data[0]['shopId'],
                                          DatabaseHelper.shopName: name.text,
                                          DatabaseHelper.shopContact:
                                              contact.text,
                                          DatabaseHelper.shopStartDay: startDay,
                                          DatabaseHelper.shopEndDay: endDay,
                                          DatabaseHelper.shopStartTime:
                                              _startTime,
                                          DatabaseHelper.shopEndTime: _endTime,
                                          DatabaseHelper.shopImage: strImage,
                                          DatabaseHelper.shopLatitude:
                                              mapMarker.latitude,
                                          DatabaseHelper.shopLongitude:
                                              mapMarker.longitude,
                                          DatabaseHelper.shopAddress: address,
                                        });
                                        await DatabaseHelper.instance
                                            .deleteShopService(
                                                snapshot.data[0]['shopId']);

                                        for (var i = 0; i < countService; i++) {
                                          await DatabaseHelper.instance
                                              .shopInsertService({
                                            DatabaseHelper.shopServiceId:
                                                DateTime.now().toString(),
                                            DatabaseHelper.shopServiceName:
                                                '${myControllersService[i].text}',
                                            DatabaseHelper.shopServicePrice:
                                                '${myControllersPrice[i].text}',
                                            DatabaseHelper.shopId:
                                                '${snapshot.data[0]['shopId']}',
                                          });
                                        }
                                      } else if (user[1] == 'gasoline' ||
                                          user[1] == 'gasOwner') {
                                        if (name.text == "") {
                                          name.text =
                                              (snapshot.data[0]['gasName']);
                                        }
                                        if (contact.text == "") {
                                          contact.text =
                                              (snapshot.data[0]['gasContact']);
                                        }
                                        if (startDay == 'Select') {
                                          startDay =
                                              (snapshot.data[0]['gasStartDay']);
                                        }
                                        if (endDay == "Select") {
                                          endDay =
                                              (snapshot.data[0]['gasEndDay']);
                                        }
                                        if (_startTime == '00:00') {
                                          _startTime = (snapshot.data[0]
                                              ['gasStartTime']);
                                        }
                                        if (_endTime == '00:00') {
                                          _endTime =
                                              (snapshot.data[0]['gasEndTime']);
                                        }
                                        if (_image == null) {
                                          _image = File(
                                              snapshot.data[0]['gasImage']);
                                        }
                                        if (mapMarker == null) {
                                          mapMarker = LatLng(
                                              snapshot.data[0]['gasLatitude'],
                                              snapshot.data[0]['gasLongitude']);

                                          //-----------------------TO BE DELETE-------------------------
                                          final coordinates = new Coordinates(
                                              snapshot.data[0]['gasLatitude'],
                                              snapshot.data[0]['gasLongitude']);
                                          var _address1 = await Geocoder.local
                                              .findAddressesFromCoordinates(
                                                  coordinates);
                                          address = _address1.first.addressLine;
                                        }

                                        String strImage =
                                            _image.path.toString();

                                        updateId = await DatabaseHelper.instance
                                            .updateGasoline({
                                          DatabaseHelper.gasId: snapshot.data[0]
                                              ['gasId'],
                                          DatabaseHelper.gasName: name.text,
                                          DatabaseHelper.gasContact:
                                              contact.text,
                                          DatabaseHelper.gasStartDay: startDay,
                                          DatabaseHelper.gasEndDay: endDay,
                                          DatabaseHelper.gasStartTime:
                                              _startTime,
                                          DatabaseHelper.gasEndTime: _endTime,
                                          DatabaseHelper.gasImage: strImage,
                                          DatabaseHelper.gasLatitude:
                                              mapMarker.latitude,
                                          DatabaseHelper.gasLongitude:
                                              mapMarker.longitude,
                                          DatabaseHelper.gasAddress: address,
                                        });

                                        await DatabaseHelper.instance
                                            .deleteGasService(
                                                snapshot.data[0]['gasId']);

                                        for (var i = 0; i < countService; i++) {
                                          await DatabaseHelper.instance
                                              .gasInsertService({
                                            DatabaseHelper.gasFuelId:
                                                DateTime.now().toString(),
                                            DatabaseHelper.gasFuelName:
                                                '${myControllersService[i].text}',
                                            DatabaseHelper.gasFuelPrice:
                                                '${myControllersPrice[i].text}',
                                            DatabaseHelper.gasId:
                                                '${snapshot.data[0]['gasId']}',
                                          });
                                        }
                                      } else if (user[1] == 'mechanic' ||
                                          user[1] == 'mechanicOwner') {
                                        if (name.text == "") {
                                          name.text = (snapshot.data[0]
                                              ['mechanicName']);
                                        }
                                        if (contact.text == "") {
                                          contact.text = (snapshot.data[0]
                                              ['mechanicContact']);
                                        }
                                        if (startDay == 'Select') {
                                          startDay = (snapshot.data[0]
                                              ['mechanicStartDay']);
                                        }
                                        if (endDay == "Select") {
                                          endDay = (snapshot.data[0]
                                              ['mechanicEndDay']);
                                        }
                                        if (_startTime == '00:00') {
                                          _startTime = (snapshot.data[0]
                                              ['mechanicStartTime']);
                                        }
                                        if (_endTime == '00:00') {
                                          _endTime = (snapshot.data[0]
                                              ['mechanicEndTime']);
                                        }
                                        if (_image == null) {
                                          _image = File(snapshot.data[0]
                                              ['mechanicImage']);
                                        }
                                        if (mapMarker == null) {
                                          mapMarker = LatLng(
                                              snapshot.data[0]
                                                  ['mechanicLatitude'],
                                              snapshot.data[0]
                                                  ['mechanicLongitude']);

                                          //-----------------------TO BE DELETE-------------------------
                                          final coordinates = new Coordinates(
                                              snapshot.data[0]
                                                  ['mechanicLatitude'],
                                              snapshot.data[0]
                                                  ['mechanicLongitude']);
                                          var _address1 = await Geocoder.local
                                              .findAddressesFromCoordinates(
                                                  coordinates);
                                          address = _address1.first.addressLine;
                                        }

                                        String strImage =
                                            _image.path.toString();

                                        updateId = await DatabaseHelper.instance
                                            .updateMechanic({
                                          DatabaseHelper.mechanicId:
                                              snapshot.data[0]['mechanicId'],
                                          DatabaseHelper.mechanicName:
                                              name.text,
                                          DatabaseHelper.mechanicContact:
                                              contact.text,
                                          DatabaseHelper.mechanicStartDay:
                                              startDay,
                                          DatabaseHelper.mechanicEndDay: endDay,
                                          DatabaseHelper.mechanicStartTime:
                                              _startTime,
                                          DatabaseHelper.mechanicEndTime:
                                              _endTime,
                                          DatabaseHelper.mechanicImage:
                                              strImage,
                                          DatabaseHelper.mechanicLatitude:
                                              mapMarker.latitude,
                                          DatabaseHelper.mechanicLongitude:
                                              mapMarker.longitude,
                                          DatabaseHelper.mechanicAddress:
                                              address,
                                        });
                                        await DatabaseHelper.instance
                                            .deleteMechanicService(
                                                snapshot.data[0]['mechanicId']);

                                        for (var i = 0; i < countService; i++) {
                                          await DatabaseHelper.instance
                                              .mechanicInsertService({
                                            DatabaseHelper.mechanicServiceId:
                                                DateTime.now().toString(),
                                            DatabaseHelper.mechanicServiceName:
                                                '${myControllersService[i].text}',
                                            DatabaseHelper.mechanicServicePrice:
                                                '${myControllersPrice[i].text}',
                                            DatabaseHelper.mechanicId:
                                                '${snapshot.data[0]['mechanicId']}',
                                          });
                                        }
                                      }

                                      if (updateId == 1) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title:
                                                  Text("Successfully updated!"),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }

                                      print(updateId);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 50),
                            /*padding:
                                EdgeInsets.only(left: 0.0, right: 0.0, top: 50),*/
                            child: Card(
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: name,
                                        decoration: InputDecoration(
                                            hintText: user[1] == 'autoshop' ||
                                                    user[1] == 'autoshopOwner'
                                                ? snapshot.data[0]['shopName']
                                                : user[1] == 'gasoline' ||
                                                        user[1] == 'gasOwner'
                                                    ? snapshot.data[0]
                                                        ['gasName']
                                                    : user[1] == 'mechanic' ||
                                                            user[1] ==
                                                                'mechanicOwner'
                                                        ? snapshot.data[0]
                                                            ['mechanicName']
                                                        : '',
                                            icon: Icon(Icons.home)),
                                      ),
                                      TextField(
                                        controller: contact,
                                        decoration: InputDecoration(
                                            hintText: user[1] == 'autoshop' ||
                                                    user[1] == 'autoshopOwner'
                                                ? snapshot.data[0]
                                                    ['shopContact']
                                                : user[1] == 'gasoline' ||
                                                        user[1] == 'gasOwner'
                                                    ? snapshot.data[0]
                                                        ['gasContact']
                                                    : user[1] == 'mechanic' ||
                                                            user[1] ==
                                                                'mechanicOwner'
                                                        ? snapshot.data[0]
                                                            ['mechanicContact']
                                                        : '',
                                            icon: Icon(Icons.phone)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Available Day: ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          DropdownButton<String>(
                                            onChanged: (String newVal) {
                                              setState(() {
                                                startDay = newVal;
                                              });
                                            },
                                            value: user[1] == 'autoshop' ||
                                                    user[1] == 'autoshopOwner'
                                                ? startDay == "Select"
                                                    ? snapshot.data[0]
                                                        ['shopStartDay']
                                                    : startDay
                                                : user[1] == 'gasoline' ||
                                                        user[1] == 'gasOwner'
                                                    ? startDay == "Select"
                                                        ? snapshot.data[0]
                                                            ['gasStartDay']
                                                        : startDay
                                                    : user[1] == 'mechanic' ||
                                                            user[1] ==
                                                                'mechanicOwner'
                                                        ? startDay == "Select"
                                                            ? snapshot.data[0][
                                                                'mechanicStartDay']
                                                            : startDay
                                                        : '',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15),
                                            items: items
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                          Text(
                                            "To: ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          DropdownButton<String>(
                                            onChanged: (String newVal) {
                                              setState(() {
                                                endDay = newVal;
                                              });
                                            },
                                            value: user[1] == 'autoshop' ||
                                                    user[1] == 'autoshopOwner'
                                                ? endDay == "Select"
                                                    ? snapshot.data[0]
                                                        ['shopEndDay']
                                                    : endDay
                                                : user[1] == 'gasoline' ||
                                                        user[1] == 'gasOwner'
                                                    ? endDay == "Select"
                                                        ? snapshot.data[0]
                                                            ['gasEndDay']
                                                        : endDay
                                                    : user[1] == 'mechanic' ||
                                                            user[1] ==
                                                                'mechanicOwner'
                                                        ? endDay == "Select"
                                                            ? snapshot.data[0][
                                                                'mechanicEndDay']
                                                            : endDay
                                                        : '',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15),
                                            items: items
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          Text(
                                            'Work Hours:  Start:',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          RawMaterialButton(
                                            child: Text(
                                              user[1] == 'autoshop' ||
                                                      user[1] == 'autoshopOwner'
                                                  ? _startTime == '00:00'
                                                      ? snapshot.data[0]
                                                          ['shopStartTime']
                                                      : _startTime
                                                  : user[1] == 'gasoline' ||
                                                          user[1] == 'gasOwner'
                                                      ? _startTime == '00:00'
                                                          ? snapshot.data[0]
                                                              ['gasStartTime']
                                                          : _startTime
                                                      : user[1] == 'mechanic' ||
                                                              user[1] ==
                                                                  'mechanicOwner'
                                                          ? _startTime ==
                                                                  '00:00'
                                                              ? snapshot.data[0]
                                                                  [
                                                                  'mechanicStartTime']
                                                              : _startTime
                                                          : '',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () {
                                              startTime(context);
                                            },
                                          ),
                                          Text(
                                            'End:',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          RawMaterialButton(
                                            child: Text(
                                              user[1] == 'autoshop' ||
                                                      user[1] == 'autoshopOwner'
                                                  ? _endTime == '00:00'
                                                      ? snapshot.data[0]
                                                          ['shopEndTime']
                                                      : _endTime
                                                  : user[1] == 'gasoline' ||
                                                          user[1] == 'gasOwner'
                                                      ? _endTime == '00:00'
                                                          ? snapshot.data[0]
                                                              ['gasEndTime']
                                                          : _endTime
                                                      : user[1] == 'mechanic' ||
                                                              user[1] ==
                                                                  'mechanicOwner'
                                                          ? _endTime == '00:00'
                                                              ? snapshot.data[0]
                                                                  [
                                                                  'mechanicEndTime']
                                                              : _endTime
                                                          : '',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () {
                                              endTime(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .17,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .50,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Center(
                                                child: _image == null
                                                    ? Image.file(
                                                        user[1] == 'autoshop' ||
                                                                user[1] ==
                                                                    'autoshopOwner'
                                                            ? File(snapshot
                                                                    .data[0]
                                                                ['shopImage'])
                                                            : user[1] ==
                                                                        'gasoline' ||
                                                                    user[1] ==
                                                                        'gasOwner'
                                                                ? File(snapshot
                                                                        .data[0]
                                                                    [
                                                                    'gasImage'])
                                                                : user[1] ==
                                                                            'mechanic' ||
                                                                        user[1] ==
                                                                            'mechanicOwner'
                                                                    ? File(snapshot
                                                                            .data[0]
                                                                        [
                                                                        'mechanicImage'])
                                                                    : '',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        _image,
                                                        fit: BoxFit.cover,
                                                      )),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 30),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.image,
                                                  color: Colors.blue,
                                                ),
                                                RawMaterialButton(
                                                  child: Text(
                                                    'Browse',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 15),
                                                  ),
                                                  onPressed: getImage,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 10)),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .23,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Center(
                                          child: mapMarker == null
                                              ? GoogleMap(
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: user[1] ==
                                                                'autoshop' ||
                                                            user[1] ==
                                                                'autoshopOwner'
                                                        ? LatLng(
                                                            snapshot.data[0][
                                                                'shopLatitude'],
                                                            snapshot.data[0][
                                                                'shopLongitude'])
                                                        : user[1] == 'gasoline' ||
                                                                user[1] ==
                                                                    'gasOwner'
                                                            ? LatLng(
                                                                snapshot.data[0][
                                                                    'gasLatitude'],
                                                                snapshot.data[0][
                                                                    'gasLongitude'])
                                                            : user[1] == 'mechanic' ||
                                                                    user[1] ==
                                                                        'mechanicOwner'
                                                                ? LatLng(
                                                                    snapshot.data[0][
                                                                        'mechanicLatitude'],
                                                                    snapshot.data[0]
                                                                        ['mechanicLongitude'])
                                                                : '',
                                                    zoom: 18.5,
                                                  ),
                                                  mapType: MapType.normal,
                                                  markers: {sampleMarker},
                                                  scrollGesturesEnabled: false,
                                                  zoomControlsEnabled: false,
                                                  onMapCreated: _onMapCreated,
                                                )
                                              : GoogleMap(
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: mapMarker,
                                                    zoom: 18.5,
                                                  ),
                                                  mapType: MapType.normal,
                                                  markers: {sampleMarker},
                                                  scrollGesturesEnabled: false,
                                                  zoomControlsEnabled: false,
                                                  onMapCreated: _onMapCreated,
                                                ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 10)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.map,
                                            color: Colors.blue,
                                          ),
                                          RawMaterialButton(
                                            child: Text(
                                              'Select on map',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () => markerPicker(),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                user[1] == 'autoshop' ||
                                                        user[1] ==
                                                            'autoshopOwner'
                                                    ? 'Add service'
                                                    : user[1] == 'gasoline' ||
                                                            user[1] ==
                                                                'gasOwner'
                                                        ? 'Add fuel'
                                                        : user[1] ==
                                                                    'mechanic' ||
                                                                user[1] ==
                                                                    'mechanicOwner'
                                                            ? 'Add service'
                                                            : '',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16)),
                                            Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        onTap: _addDynamic,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listDynamic.length,
                                        itemBuilder: (_, index) =>
                                            listDynamic[index],
                                      ),
                                      FutureBuilder(
                                          future: user[1] == 'autoshop'
                                              ? getAutoshopService(user[0])
                                              : user[1] == 'autoshopOwner'
                                                  ? getAutoshopService(snapshot
                                                      .data[0]['shopId'])
                                                  : user[1] == 'gasoline'
                                                      ? getGasolineService(
                                                          user[0])
                                                      : user[1] == 'gasOwner'
                                                          ? getGasolineService(
                                                              snapshot.data[0]
                                                                  ['shopId'])
                                                          : user[1] ==
                                                                  'mechanic'
                                                              ? getMechanicService(
                                                                  user[0])
                                                              : user[1] ==
                                                                      'mechanicOwner'
                                                                  ? getMechanicService(
                                                                      snapshot.data[
                                                                              0]
                                                                          [
                                                                          'shopId'])
                                                                  : '',
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            countService = snapshot.data.length;

                                            return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (_, index) {
                                                  if (user[1] == 'autoshop' ||
                                                      user[1] ==
                                                          'autoshopOwner') {
                                                    myControllersService.add(
                                                        TextEditingController(
                                                            text: snapshot
                                                                    .data[index]
                                                                [
                                                                'shopServiceName']));
                                                    myControllersPrice.add(
                                                        TextEditingController(
                                                            text: snapshot
                                                                    .data[index]
                                                                [
                                                                'shopServicePrice']));
                                                  } else if (user[1] ==
                                                          'gasoline' ||
                                                      user[1] == 'gasOwner') {
                                                    myControllersService.add(
                                                        TextEditingController(
                                                            text: snapshot
                                                                    .data[index]
                                                                [
                                                                'gasFuelName']));
                                                    myControllersPrice.add(
                                                        TextEditingController(
                                                            text: snapshot
                                                                    .data[index]
                                                                [
                                                                'gasFuelPrice']));
                                                  } else if (user[1] ==
                                                          'mechanic' ||
                                                      user[1] ==
                                                          'mechanicOwner') {
                                                    myControllersService.add(
                                                        TextEditingController(
                                                            text: snapshot
                                                                    .data[index]
                                                                [
                                                                'mechanicServiceName']));
                                                    myControllersPrice.add(
                                                        TextEditingController(
                                                            text: snapshot
                                                                    .data[index]
                                                                [
                                                                'mechanicServicePrice']));
                                                  }

                                                  return Row(
                                                    children: [
                                                      Flexible(
                                                        child: TextField(
                                                          controller:
                                                              myControllersService[
                                                                  index],
                                                          decoration:
                                                              new InputDecoration(
                                                            hintText: user[1] ==
                                                                        'autoshop' ||
                                                                    user[1] ==
                                                                        'autoshopOwner'
                                                                ? snapshot.data[
                                                                        index][
                                                                    'shopServiceName']
                                                                : user[1] == 'gasoline' ||
                                                                        user[1] ==
                                                                            'gasOwner'
                                                                    ? snapshot.data[
                                                                            index]
                                                                        [
                                                                        'gasFuelName']
                                                                    : user[1] ==
                                                                                'mechanic' ||
                                                                            user[1] ==
                                                                                'mechanicOwner'
                                                                        ? snapshot.data[index]
                                                                            ['mechanicServiceName']
                                                                        : '',
                                                            hintStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 40),
                                                          child: TextField(
                                                            controller:
                                                                myControllersPrice[
                                                                    index],
                                                            decoration: InputDecoration(
                                                                hintText: user[1] == 'autoshop' || user[1] == 'autoshopOwner'
                                                                    ? snapshot.data[index]['shopServicePrice']
                                                                    : user[1] == 'gasoline' || user[1] == 'gasOwner'
                                                                        ? snapshot.data[index]['gasFuelPrice']
                                                                        : user[1] == 'mechanic' || user[1] == 'mechanicOwner'
                                                                            ? snapshot.data[index]['mechanicServicePrice']
                                                                            : '',
                                                                hintStyle: TextStyle(fontSize: 16),
                                                                prefixText: '₱ ',
                                                                prefixStyle: TextStyle(color: Colors.blue, fontSize: 16)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 10)),
                                      Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: listDynamic.length,
                                            itemBuilder: (_, index) =>
                                                listDynamic[index],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class AddDynamic extends StatelessWidget {
  final service = new TextEditingController();
  final price = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: service,
            decoration: new InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 40),
            child: TextField(
              controller: price,
              decoration: new InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(fontSize: 16),
                  prefixText: '₱ ',
                  prefixStyle: TextStyle(color: Colors.blue, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
