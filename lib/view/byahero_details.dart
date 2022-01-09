import 'dart:io';

import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ByaheroDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List userType = ModalRoute.of(context).settings.arguments;
    int distanceMeters;
    searchData() async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (userType[1] == 'shopList') {
        List<Map> search =
            await DatabaseHelper.instance.shopFromList('${userType[0]}');
        double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            search[0]['shopLatitude'],
            search[0]['shopLongitude']);

        distanceMeters = distanceInMeters.toInt();

        return search;
      } else if (userType[1] == 'gasList') {
        List<Map> search =
            await DatabaseHelper.instance.gasFromList('${userType[0]}');
        double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            search[0]['gasLatitude'],
            search[0]['gasLongitude']);

        distanceMeters = distanceInMeters.toInt();
        return search;
      } else if (userType[1] == 'mechanicList') {
        List<Map> search =
            await DatabaseHelper.instance.mechanicFromList('${userType[0]}');
        double distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            search[0]['mechanicLatitude'],
            search[0]['mechanicLongitude']);

        distanceMeters = distanceInMeters.toInt();
        return search;
      } else if (userType[1] == 'autoshop') {
        try {
          List<Map> search =
              await DatabaseHelper.instance.searchAutoshop('${userType[0]}');

          if (search.length == 0) {
            return search.length;
          } else {
            double distanceInMeters = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                search[0]['shopLatitude'],
                search[0]['shopLongitude']);

            distanceMeters = distanceInMeters.toInt();
            return search;
          }
        } catch (e) {}
      } else if (userType[1] == 'gasoline') {
        List<Map> search =
            await DatabaseHelper.instance.searchGasoline('${userType[0]}');

        if (search.length == 0) {
          return search.length;
        } else {
          double distanceInMeters = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              search[0]['gasLatitude'],
              search[0]['gasLongitude']);

          distanceMeters = distanceInMeters.toInt();
          return search;
        }
      } else if (userType[1] == 'mechanic') {
        List<Map> search =
            await DatabaseHelper.instance.searchMechanic('${userType[0]}');

        if (search.length == 0) {
          return search.length;
        } else {
          double distanceInMeters = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              search[0]['mechanicLatitude'],
              search[0]['mechanicLongitude']);

          distanceMeters = distanceInMeters.toInt();
          return search;
        }
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

    return FutureBuilder(
      future: searchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        print(snapshot.data);

        return Scaffold(
          body: snapshot.data == 0
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/image/admin1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                              userType[1] == 'shopList' ||
                                      userType[1] == 'gasList' ||
                                      userType[1] == 'mechanicList'
                                  ? GestureDetector(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      onTap: () => Navigator.pop(context),
                                    )
                                  : GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          ),
                                          Text('Logout',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                      onTap: () => Navigator.pushNamed(
                                          context, '/dashboard'),
                                    ),
                              Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                    userType[1] == 'shopList' ||
                            userType[1] == 'gasList' ||
                            userType[1] == 'mechanicList'
                        ? Text('')
                        : Container(
                            height: 64,
                            //margin: EdgeInsets.only(top: 25, left: 265),
                            margin: EdgeInsets.only(top: 25, left: 240),
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
                                            userType[1] == 'autoshop'
                                                ? 'Add autoshop'
                                                : userType[1] == 'gasoline'
                                                    ? 'Add gasoline'
                                                    : userType[1] == 'mechanic'
                                                        ? 'Add mechanic'
                                                        : '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      onTap: () => Navigator.pushNamed(
                                          context, '/addService',
                                          arguments: userType),
                                    ),
                                    Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                )
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/image/admin1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                              userType[1] == 'shopList' ||
                                      userType[1] == 'gasList' ||
                                      userType[1] == 'mechanicList'
                                  ? GestureDetector(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      onTap: () => Navigator.pop(context),
                                    )
                                  : GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          ),
                                          Text('Logout',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                      onTap: () => Navigator.pushNamed(
                                          context, '/dashboard'),
                                    ),
                              Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                    userType[1] == 'shopList' ||
                            userType[1] == 'gasList' ||
                            userType[1] == 'mechanicList'
                        ? Text('')
                        : Container(
                            height: 64,
                            margin: EdgeInsets.only(top: 25, left: 315),
                            //margin: EdgeInsets.only(top: 25, left: 268),
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
                                              userType[1] == 'autoshop'
                                                  ? 'Update'
                                                  : userType[1] == 'gasoline'
                                                      ? 'update'
                                                      : userType[1] ==
                                                              'mechanic'
                                                          ? 'update'
                                                          : '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          if (userType[1] == 'autoshop') {
                                            final List listUserView1 = [
                                              '${snapshot.data[0]['userid']}',
                                              'autoshopOwner',
                                            ];
                                            Navigator.pushNamed(
                                                context, '/adminUpdate',
                                                arguments: listUserView1);
                                          }
                                          if (userType[1] == 'gasoline') {
                                            final List listUserView2 = [
                                              '${snapshot.data[0]['userid']}',
                                              'gasOwner',
                                            ];
                                            Navigator.pushNamed(
                                                context, '/adminUpdate',
                                                arguments: listUserView2);
                                          }
                                          if (userType[1] == 'mechanic') {
                                            final List listUserView3 = [
                                              '${snapshot.data[0]['userid']}',
                                              'mechanicOwner',
                                            ];
                                            Navigator.pushNamed(
                                                context, '/adminUpdate',
                                                arguments: listUserView3);
                                          }
                                        }),
                                    Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 16.0, top: 50),
                        child: DefaultTabController(
                          length: 1,
                          child: Container(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Image(
                                        image: Image.file(
                                          userType[1] == 'shopList' ||
                                                  userType[1] == 'autoshop'
                                              ? File(
                                                  snapshot.data[0]['shopImage'])
                                              : userType[1] == 'gasList' ||
                                                      userType[1] == 'gasoline'
                                                  ? File(snapshot.data[0]
                                                      ['gasImage'])
                                                  : userType[1] ==
                                                              'mechanicList' ||
                                                          userType[1] ==
                                                              'mechanic'
                                                      ? File(snapshot.data[0]
                                                          ['mechanicImage'])
                                                      : '',
                                          fit: BoxFit.cover,
                                        ).image,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.9,
                                        fit: BoxFit.fill),
                                    Container(
                                      padding: EdgeInsets.only(left: 5, top: 5),
                                      width: 170,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(21)),
                                        child: GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.call,
                                                  color: Colors.blue),
                                              Text(
                                                userType[1] == 'shopList' ||
                                                        userType[1] ==
                                                            'autoshop'
                                                    ? snapshot.data[0]
                                                        ['shopContact']
                                                    : userType[1] ==
                                                                'gasList' ||
                                                            userType[1] ==
                                                                'gasoline'
                                                        ? snapshot.data[0]
                                                            ['gasContact']
                                                        : userType[1] ==
                                                                    'mechanicList' ||
                                                                userType[1] ==
                                                                    'mechanic'
                                                            ? snapshot.data[0][
                                                                'mechanicContact']
                                                            : '',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            String phoneno;
                                            if (userType[1] == 'shopList' ||
                                                userType[1] == 'autoshop') {
                                              phoneno =
                                                  "tel:${snapshot.data[0]['shopContact']}";
                                            } else if (userType[1] ==
                                                    'gasList' ||
                                                userType[1] == 'gasoline') {
                                              phoneno =
                                                  "tel:${snapshot.data[0]['gasContact']}";
                                            } else if (userType[1] ==
                                                    'mechanicList' ||
                                                userType[1] == 'mechanic') {
                                              phoneno =
                                                  "tel:${snapshot.data[0]['mechanicContact']}";
                                            }
                                            launch(phoneno);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  userType[1] == 'shopList' ||
                                          userType[1] == 'autoshop'
                                      ? snapshot.data[0]['shopName']
                                      : userType[1] == 'gasList' ||
                                              userType[1] == 'gasoline'
                                          ? snapshot.data[0]['gasName']
                                          : userType[1] == 'mechanicList' ||
                                                  userType[1] == 'mechanic'
                                              ? snapshot.data[0]['mechanicName']
                                              : '',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 11),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: Colors.blue),
                                    Expanded(
                                      child: Text(
                                        userType[1] == 'shopList' ||
                                                userType[1] == 'autoshop'
                                            ? snapshot.data[0]['shopAddress']
                                            : userType[1] == 'gasList' ||
                                                    userType[1] == 'gasoline'
                                                ? snapshot.data[0]['gasAddress']
                                                : userType[1] ==
                                                            'mechanicList' ||
                                                        userType[1] ==
                                                            'mechanic'
                                                    ? snapshot.data[0]
                                                        ['mechanicAddress']
                                                    : '',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 11),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_outlined,
                                        color: Colors.blue),
                                    Text(
                                        userType[1] == 'shopList' ||
                                                userType[1] == 'autoshop'
                                            ? 'Open: ${snapshot.data[0]['shopStartDay']} - ${snapshot.data[0]['shopEndDay']} (${snapshot.data[0]['shopStartTime']} - ${snapshot.data[0]['shopEndTime']})'
                                            : userType[1] == 'gasList' ||
                                                    userType[1] == 'gasoline'
                                                ? 'Open: ${snapshot.data[0]['gasStartDay']} - ${snapshot.data[0]['gasEndDay']} (${snapshot.data[0]['gasStartTime']} - ${snapshot.data[0]['gasEndTime']})'
                                                : userType[1] ==
                                                            'mechanicList' ||
                                                        userType[1] ==
                                                            'mechanic'
                                                    ? 'Open: ${snapshot.data[0]['mechanicStartDay']} - ${snapshot.data[0]['mechanicEndDay']} (${snapshot.data[0]['mechanicStartTime']} - ${snapshot.data[0]['mechanicEndTime']})'
                                                    : '',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 11),
                                Row(
                                  children: [
                                    Icon(Icons.directions_outlined,
                                        color: Colors.blue),
                                    Text(
                                        userType[1] == 'shopList'
                                            ? '${snapshot.data[0]['shopDistance']} meters away'
                                            : userType[1] == 'gasList'
                                                ? '${snapshot.data[0]['gasDistance']} meters away'
                                                : userType[1] == 'mechanicList'
                                                    ? '${snapshot.data[0]['mechanicDistance']} meters away'
                                                    : '$distanceMeters meters away',
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                                SizedBox(height: 11),
                                FutureBuilder(
                                    future: userType[1] == 'shopList' ||
                                            userType[1] == 'autoshop'
                                        ? getAutoshopService(
                                            snapshot.data[0]['shopId'])
                                        : userType[1] == 'gasList' ||
                                                userType[1] == 'gasoline'
                                            ? getGasService(
                                                snapshot.data[0]['gasId'])
                                            : userType[1] == 'mechanicList' ||
                                                    userType[1] == 'mechanic'
                                                ? getMechanicService(snapshot
                                                    .data[0]['mechanicId'])
                                                : '',
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return Expanded(
                                        child: TabBarView(children: <Widget>[
                                          Container(
                                            child: ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) =>
                                                  Card(
                                                child: userType[1] ==
                                                            'shopList' ||
                                                        userType[1] ==
                                                            'autoshop'
                                                    ? ListTile(
                                                        title: Text(snapshot
                                                                .data[index][
                                                            'shopServiceName']),
                                                        trailing: Text(
                                                            '₱${snapshot.data[index]['shopServicePrice']}'),
                                                      )
                                                    : userType[1] ==
                                                                'gasList' ||
                                                            userType[1] ==
                                                                'gasoline'
                                                        ? ListTile(
                                                            title: Text(snapshot
                                                                    .data[index]
                                                                [
                                                                'gasFuelName']),
                                                            trailing: Text(
                                                                '₱${snapshot.data[index]['gasFuelPrice']}'),
                                                          )
                                                        : userType[1] ==
                                                                    'mechanicList' ||
                                                                userType[1] ==
                                                                    'mechanic'
                                                            ? ListTile(
                                                                title: Text(snapshot
                                                                            .data[
                                                                        index][
                                                                    'mechanicServiceName']),
                                                                trailing: Text(
                                                                    '₱${snapshot.data[index]['mechanicServicePrice']}'),
                                                              )
                                                            : '',
                                              ),
                                            ),
                                          )
                                        ]),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
