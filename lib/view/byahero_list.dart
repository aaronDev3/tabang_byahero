import 'dart:io';

import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ByaheroList extends StatefulWidget {
  @override
  _ByaheroListState createState() => _ByaheroListState();
}

class _ByaheroListState extends State<ByaheroList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Service'),
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
          bottom: TabBar(
              indicatorWeight: 4.0,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: 'Autoshop'),
                Tab(text: 'Gasoline'),
                Tab(text: 'Mechanic'),
              ]),
        ),
        body: TabBarView(children: <Widget>[
          Autosop(),
          Gasoline(),
          Mechanic(),
        ]),
      ),
    );
  }
}

class Autosop extends StatefulWidget {
  @override
  _AutosopState createState() => _AutosopState();
}

class _AutosopState extends State<Autosop> {
  getAllAutoshop() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllAutoshop();

    for (var i = 0; i < queryRows.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          queryRows[i]['shopLatitude'],
          queryRows[i]['shopLongitude']);

      int num = distanceInMeters.toInt();

      await DatabaseHelper.instance.updateAutoshop({
        DatabaseHelper.shopId: queryRows[i]['shopId'],
        DatabaseHelper.shopDistance: num,
      });
    }

    List<Map<String, dynamic>> sortData =
        await DatabaseHelper.instance.sortAutoshop();

    return sortData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllAutoshop(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: Image.file(
                File(snapshot.data[index]['shopImage']),
                fit: BoxFit.cover,
              ).image,
            ),
            title: Text('${snapshot.data[index]['shopName']}'),
            subtitle:
                Text('${snapshot.data[index]['shopDistance']} meters away'),
            onTap: () {
              final List listUserView = [
                '${snapshot.data[index]['shopId']}',
                'shopList',
                '${snapshot.data[index]['shopDistance']}'
              ];
              Navigator.pushNamed(context, '/byaheroDetails',
                  arguments: listUserView);
            },
          ),
        );
      },
    );
  }
}

class Gasoline extends StatefulWidget {
  @override
  _GasolineState createState() => _GasolineState();
}

class _GasolineState extends State<Gasoline> {
  getAllGasoline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllGasoline();

    for (var i = 0; i < queryRows.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          queryRows[i]['gasLatitude'],
          queryRows[i]['gasLongitude']);

      int num = distanceInMeters.toInt();

      await DatabaseHelper.instance.updateGasoline({
        DatabaseHelper.gasId: queryRows[i]['gasId'],
        DatabaseHelper.gasDistance: num,
      });
    }

    List<Map<String, dynamic>> sortData =
        await DatabaseHelper.instance.sortGasoline();

    return sortData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllGasoline(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundImage: Image.file(
                  File(snapshot.data[index]['gasImage']),
                  fit: BoxFit.cover,
                ).image,
              ),
              title: Text('${snapshot.data[index]['gasName']}'),
              subtitle:
                  Text(' ${snapshot.data[index]['gasDistance']} meters away'),
              onTap: () {
                final List listUserView = [
                  '${snapshot.data[index]['gasId']}',
                  'gasList',
                  '${snapshot.data[index]['gasDistance']}'
                ];
                Navigator.pushNamed(context, '/byaheroDetails',
                    arguments: listUserView);
              }),
        );
      },
    );
  }
}

class Mechanic extends StatefulWidget {
  @override
  _MechanicState createState() => _MechanicState();
}

class _MechanicState extends State<Mechanic> {
  getAllMechanic() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllMechanic();

    for (var i = 0; i < queryRows.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          queryRows[i]['mechanicLatitude'],
          queryRows[i]['mechanicLongitude']);

      int num = distanceInMeters.toInt();

      await DatabaseHelper.instance.updateMechanic({
        DatabaseHelper.mechanicId: queryRows[i]['mechanicId'],
        DatabaseHelper.mechanicDistance: num,
      });
    }

    List<Map<String, dynamic>> sortData =
        await DatabaseHelper.instance.sortMechanic();

    return sortData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllMechanic(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: Image.file(
                File(snapshot.data[index]['mechanicImage']),
                fit: BoxFit.cover,
              ).image,
            ),
            title: Text('${snapshot.data[index]['mechanicName']}'),
            subtitle: Text(
                ' ${snapshot.data[index]['mechanicDistance']} meters away'),
            onTap: () {
              final List listUserView = [
                '${snapshot.data[index]['mechanicId']}',
                'mechanicList',
                '${snapshot.data[index]['mechanicDistance']}'
              ];
              Navigator.pushNamed(context, '/byaheroDetails',
                  arguments: listUserView);
            },
          ),
        );
      },
    );
  }
}
