import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int total = 206;

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

  getTotalItem() async {
    List<Map<String, dynamic>> queryRows1 =
        await DatabaseHelper.instance.queryAllAutoshop();
    List<Map<String, dynamic>> queryRows2 =
        await DatabaseHelper.instance.queryAllGasoline();
    List<Map<String, dynamic>> queryRows3 =
        await DatabaseHelper.instance.queryAllMechanic();
    return queryRows1.length + queryRows2.length + queryRows3.length;
  }

  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/admin1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage("assets/image/admin.jpg"),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Byahero',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            Text('byahero@gmail.com',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        SizedBox(width: 65),
                        //SizedBox(width: 45),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  Text('Logout',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ],
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/dashboard'),
                            ),
                            Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      primary: false,
                      children: [
                        FutureBuilder(
                            future: getAllAutoshop(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('');
                              }

                              return GestureDetector(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${snapshot.data.length}',
                                        style: TextStyle(
                                            fontSize: 80,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.car_repair_outlined,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            'Autoshop',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, '/adminList',
                                    arguments: 'autoshop'),
                              );
                            }),
                        FutureBuilder(
                            future: getAllGasoline(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('');
                              }

                              return GestureDetector(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${snapshot.data.length}',
                                        style: TextStyle(
                                            fontSize: 80,
                                            color: Colors.lightBlueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_gas_station_outlined,
                                            color: Colors.lightBlueAccent,
                                          ),
                                          Text(
                                            'Gasoline',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.lightBlueAccent),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, '/adminList',
                                    arguments: 'gasoline'),
                              );
                            }),
                        Center(
                          child: FutureBuilder(
                              future: getAllMechanic(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('');
                                }

                                return GestureDetector(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 4,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '${snapshot.data.length}',
                                          style: TextStyle(
                                              fontSize: 80,
                                              color: Colors.blue[300],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_outline,
                                              color: Colors.blue[300],
                                            ),
                                            Text(
                                              'Mechanic',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue[300]),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                      context, '/adminList',
                                      arguments: 'mechanic'),
                                );
                              }),
                        ),
                        FutureBuilder(
                            future: getTotalItem(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('');
                              }
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: TweenAnimationBuilder(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: Duration(seconds: 2),
                                    builder: (context, value, child) {
                                      itemCount =
                                          (value * snapshot.data).ceil();

                                      return Center(
                                        child: Container(
                                          width: 100,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: Column(
                                            children: <Widget>[
                                              Stack(
                                                children: [
                                                  ShaderMask(
                                                    shaderCallback: (rect) {
                                                      return SweepGradient(
                                                          startAngle: 0.0,
                                                          endAngle: 3.14 * 2,
                                                          stops: [value, value],
                                                          center:
                                                              Alignment.center,
                                                          colors: [
                                                            Colors.white,
                                                            Colors.transparent
                                                          ]).createShader(rect);
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 125,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      width: 80,
                                                      height: 125,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '$itemCount',
                                                          style: TextStyle(
                                                              fontSize: 35,
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .data_saver_off_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.blue),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
