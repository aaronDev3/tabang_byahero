import 'dart:io';

import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminList extends StatefulWidget {
  @override
  _AdminListState createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  getAllAutoshop() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllAutoshop();
    return queryRows;
  }

  getAllGasoline() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllGasoline();
    return queryRows;
  }

  getAllMechanic() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAllMechanic();
    return queryRows;
  }

  @override
  Widget build(BuildContext context) {
    final String userType = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
        future: userType == 'autoshop'
            ? getAllAutoshop()
            : userType == 'gasoline'
                ? getAllGasoline()
                : userType == 'mechanic'
                    ? getAllMechanic()
                    : '',
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/admin1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 50.0, left: 20),
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/adminDashboard'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                    userType == 'autoshop'
                        ? 'Autoshop'
                        : userType == 'gasoline'
                            ? 'Gasoline'
                            : userType == 'mechanic'
                                ? 'Mechanic'
                                : '',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(top: 50.0, left: 335.0),
                      //padding: EdgeInsets.only(top: 50.0, left: 285.0),
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          Text(
                            'ADD',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (userType == 'autoshop') {
                        final List listUserView = ['admin', 'autoshop'];
                        Navigator.pushNamed(context, '/addService',
                            arguments: listUserView);
                      } else if (userType == 'gasoline') {
                        final List listUserView = ['admin', 'gasoline'];
                        Navigator.pushNamed(context, '/addService',
                            arguments: listUserView);
                      } else if (userType == 'mechanic') {
                        final List listUserView = ['admin', 'mechanic'];
                        Navigator.pushNamed(context, '/addService',
                            arguments: listUserView);
                      }
                    }),
                SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
                    child: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                          body: userType == 'autoshop'
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text(
                                        '${snapshot.data[index]['shopName']}'),
                                    leading: CircleAvatar(
                                      backgroundImage: Image.file(
                                        File(snapshot.data[index]['shopImage']),
                                        fit: BoxFit.cover,
                                      ).image,
                                    ),
                                    trailing: Wrap(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            final List listUserView = [
                                              '${snapshot.data[index]['shopId']}',
                                              'autoshop',
                                            ];
                                            Navigator.pushNamed(
                                                context, '/adminUpdate',
                                                arguments: listUserView);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text(
                                                        "Are you sure you want to delete ${snapshot.data[index]['shopName']}"),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: Text("Yes"),
                                                        onPressed: () async {
                                                          await DatabaseHelper
                                                              .instance
                                                              .deleteAutoshoop(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'shopId']);
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: Text("No"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.delete,
                                                color: Colors.red))
                                      ],
                                    ),
                                    subtitle: Text(
                                        '${snapshot.data[index]['shopContact']}'),
                                    onTap: null,
                                  ),
                                )
                              : userType == 'gasoline'
                                  ? ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) => ListTile(
                                        title: Text(
                                            '${snapshot.data[index]['gasName']}'),
                                        leading: CircleAvatar(
                                          backgroundImage: Image.file(
                                            File(snapshot.data[index]
                                                ['gasImage']),
                                            fit: BoxFit.cover,
                                          ).image,
                                        ),
                                        trailing: Wrap(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                final List listUserView = [
                                                  '${snapshot.data[index]['gasId']}',
                                                  'gasoline',
                                                ];
                                                Navigator.pushNamed(
                                                    context, '/adminUpdate',
                                                    arguments: listUserView);
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: Text(
                                                            "Are you sure you want to delete ${snapshot.data[index]['gasName']}"),
                                                        actions: <Widget>[
                                                          CupertinoDialogAction(
                                                            child: Text("Yes"),
                                                            onPressed:
                                                                () async {
                                                              await DatabaseHelper
                                                                  .instance
                                                                  .deleteGasoline(
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'gasId']);
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          CupertinoDialogAction(
                                                            child: Text("No"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red))
                                          ],
                                        ),
                                        subtitle: Text(
                                            '${snapshot.data[index]['gasAddress']}'),
                                        onTap: null,
                                      ),
                                    )
                                  : userType == 'mechanic'
                                      ? ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                                '${snapshot.data[index]['mechanicName']}'),
                                            leading: CircleAvatar(
                                              backgroundImage: Image.file(
                                                File(snapshot.data[index]
                                                    ['mechanicImage']),
                                                fit: BoxFit.cover,
                                              ).image,
                                            ),
                                            trailing: Wrap(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    final List listUserView = [
                                                      '${snapshot.data[index]['mechanicId']}',
                                                      'mechanic',
                                                    ];
                                                    Navigator.pushNamed(
                                                        context, '/adminUpdate',
                                                        arguments:
                                                            listUserView);
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text(
                                                                "Are you sure you want to delete ${snapshot.data[index]['mechanicName']}"),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                child:
                                                                    Text("Yes"),
                                                                onPressed:
                                                                    () async {
                                                                  await DatabaseHelper
                                                                      .instance
                                                                      .deleteGasoline(
                                                                          snapshot.data[index]
                                                                              [
                                                                              'mechanicId']);
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child:
                                                                    Text("No"),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red))
                                              ],
                                            ),
                                            subtitle: Text(
                                                '${snapshot.data[index]['mechanicContact']}'),
                                            onTap: null,
                                          ),
                                        )
                                      : ''),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
