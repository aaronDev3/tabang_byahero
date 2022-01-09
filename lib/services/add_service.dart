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

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  File _image;

  LatLng mapMarker;
  final picker = ImagePicker();
  final name = new TextEditingController();
  final contact = new TextEditingController();

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
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String dayChange;
  String startTimeChange;

  String startDay = 'Monday';
  String endDay = 'Sunday';

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
    final List user = ModalRoute.of(context).settings.arguments;

    submitData() async {
      String strImage = _image.path.toString();
      int i;
      String id = DateTime.now().toString();
      var address = "";

      try {
        final coordinates =
            new Coordinates(mapMarker.latitude, mapMarker.longitude);
        var _address =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);

        address = _address.first.addressLine;
      } catch (e) {}

      if (user[1] == 'autoshop') {
        i = await DatabaseHelper.instance.insertAutoshop(
          {
            DatabaseHelper.shopId: '$id',
            DatabaseHelper.shopName: ' ${name.text}',
            DatabaseHelper.shopContact: '${contact.text}',
            DatabaseHelper.shopStartDay: '$startDay',
            DatabaseHelper.shopEndDay: '$endDay',
            DatabaseHelper.shopStartTime: '$_startTime',
            DatabaseHelper.shopEndTime: '$_endTime',
            DatabaseHelper.shopImage: '$strImage',
            DatabaseHelper.shopLatitude: '${mapMarker.latitude}',
            DatabaseHelper.shopLongitude: '${mapMarker.longitude}',
            DatabaseHelper.shopAddress: '$address',
            DatabaseHelper.userId: '${user[0]}',
          },
        );
      } else if (user[1] == 'gasoline') {
        i = await DatabaseHelper.instance.insertGasoline(
          {
            DatabaseHelper.gasId: '$id',
            DatabaseHelper.gasName: ' ${name.text}',
            DatabaseHelper.gasContact: '${contact.text}',
            DatabaseHelper.gasStartDay: '$startDay',
            DatabaseHelper.gasEndDay: '$endDay',
            DatabaseHelper.gasStartTime: '$_startTime',
            DatabaseHelper.gasEndTime: '$_endTime',
            DatabaseHelper.gasImage: '$strImage',
            DatabaseHelper.gasLatitude: '${mapMarker.latitude}',
            DatabaseHelper.gasLongitude: '${mapMarker.longitude}',
            DatabaseHelper.gasAddress: '$address',
            DatabaseHelper.userId: '${user[0]}',
          },
        );
      } else if (user[1] == 'mechanic') {
        i = await DatabaseHelper.instance.insertMechanic(
          {
            DatabaseHelper.mechanicId: '$id',
            DatabaseHelper.mechanicName: ' ${name.text}',
            DatabaseHelper.mechanicContact: '${contact.text}',
            DatabaseHelper.mechanicStartDay: '$startDay',
            DatabaseHelper.mechanicEndDay: '$endDay',
            DatabaseHelper.mechanicStartTime: '$_startTime',
            DatabaseHelper.mechanicEndTime: '$_endTime',
            DatabaseHelper.mechanicImage: '$strImage',
            DatabaseHelper.mechanicLatitude: '${mapMarker.latitude}',
            DatabaseHelper.mechanicLongitude: '${mapMarker.longitude}',
            DatabaseHelper.mechanicAddress: '$address',
            DatabaseHelper.userId: '${user[0]}',
          },
        );
      }

      listDynamic.forEach((widget) async {
        if (widget.service.text == '' || widget.service.text == '') {
          return;
        }
        if (user[1] == 'autoshop') {
          i = await DatabaseHelper.instance.shopInsertService(
            {
              DatabaseHelper.shopServiceId: DateTime.now().toString(),
              DatabaseHelper.shopServiceName: ' ${widget.service.text}',
              DatabaseHelper.shopServicePrice: '${widget.price.text}',
              DatabaseHelper.shopId: '$id',
            },
          );
        } else if (user[1] == 'gasoline') {
          i = await DatabaseHelper.instance.gasInsertService(
            {
              DatabaseHelper.gasFuelId: DateTime.now().toString(),
              DatabaseHelper.gasFuelName: ' ${widget.service.text}',
              DatabaseHelper.gasFuelPrice: '${widget.price.text}',
              DatabaseHelper.gasId: '$id',
            },
          );
        } else if (user[1] == 'mechanic') {
          i = await DatabaseHelper.instance.mechanicInsertService(
            {
              DatabaseHelper.mechanicServiceId: DateTime.now().toString(),
              DatabaseHelper.mechanicServiceName: ' ${widget.service.text}',
              DatabaseHelper.mechanicServicePrice: '${widget.price.text}',
              DatabaseHelper.mechanicId: '$id',
            },
          );
        }
      });

      if (i != 0) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Successfuly added!"),
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
    }

    Marker sampleMarker = Marker(
      markerId: MarkerId('Marker1'),
      position: mapMarker,
    );

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
                                if (user[0] == 'admin' &&
                                    user[1] == 'autoshop') {
                                  Navigator.pushNamed(context, '/adminList',
                                      arguments: 'autoshop');
                                } else if (user[0] == 'admin' &&
                                    user[1] == 'gasoline') {
                                  Navigator.pushNamed(context, '/adminList',
                                      arguments: 'gasoline');
                                } else if (user[0] == 'admin' &&
                                    user[1] == 'mechanic') {
                                  Navigator.pushNamed(context, '/adminList',
                                      arguments: 'mechanic');
                                } else if (user[1] == 'autoshop' ||
                                    user[1] == 'gasoline' ||
                                    user[1] == 'mechanic') {
                                  Navigator.pushNamed(
                                      context, '/byaheroDetails',
                                      arguments: user);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(top: 25, left: 335),
                    //margin: EdgeInsets.only(top: 25, left: 287),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            user[1] == 'autoshop' ||
                                    user[1] == 'gasoline' ||
                                    user[1] == 'mechanic'
                                ? GestureDetector(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Save',
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
                                    onTap: () => submitData(),
                                  )
                                : '',
                            Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                      //padding: EdgeInsets.only(top: 50),
                      child: Card(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: name,
                                  decoration: InputDecoration(
                                      hintText: user[1] == 'autoshop'
                                          ? 'Autoshop name'
                                          : user[1] == 'gasoline'
                                              ? 'Gasoline station'
                                              : user[1] == 'mechanic'
                                                  ? 'Mechanic name'
                                                  : '',
                                      icon: Icon(Icons.home)),
                                ),
                                TextField(
                                  controller: contact,
                                  decoration: InputDecoration(
                                      hintText: 'Contact number',
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
                                      onChanged: (dayChange) {
                                        setState(() {
                                          startDay = dayChange;

                                          print(startDay);
                                        });
                                      },
                                      value: startDay,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                      items:
                                          items.map<DropdownMenuItem<String>>(
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
                                      onChanged: (String newValue) {
                                        setState(() {
                                          endDay = newValue;
                                        });
                                      },
                                      value: endDay,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                      items:
                                          items.map<DropdownMenuItem<String>>(
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
                                        _startTime,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 17),
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
                                        _endTime,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 17),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .17,
                                      width: MediaQuery.of(context).size.width *
                                          .50,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Center(
                                          child: _image == null
                                              ? Text("No Image taken")
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
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .23,
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: Center(
                                    child: mapMarker == null
                                        ? Text("No place selected")
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
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.map,
                                      color: Colors.blue,
                                    ),
                                    RawMaterialButton(
                                      child: Text(
                                        'Select on map',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ),
                                      onPressed: () => markerPicker(),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          user[1] == 'autoshop'
                                              ? 'Add service'
                                              : user[1] == 'gasoline'
                                                  ? 'Add fuel'
                                                  : user[1] == 'mechanic'
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
                                Padding(padding: EdgeInsets.only(bottom: 10)),
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
