import 'package:byahero_app/services/add_marker.dart';
import 'package:byahero_app/services/add_service.dart';
import 'package:byahero_app/view/admin_dashboard.dart';
import 'package:byahero_app/view/admin_list.dart';
import 'package:byahero_app/view/admin_update.dart';
import 'package:byahero_app/view/byahero_details.dart';
import 'package:byahero_app/view/byahero_list.dart';
import 'package:byahero_app/view/byahero_map.dart';
import 'package:byahero_app/view/dashboard.dart';
import 'package:byahero_app/view/login.dart';
import 'package:byahero_app/view/register.dart';
import 'package:byahero_app/view/service_dashboard.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'Tabang byahero'),
    );
  }
}

class Home extends StatefulWidget {
  @override
  Home({Key key, this.title}) : super(key: key);
  final String title;

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/byaheroMap': (context) => ByaheroMap(),
        '/byaheroList': (context) => ByaheroList(),
        '/byaheroDetails': (context) => ByaheroDetails(),
        '/addMarker': (context) => AddMarker(),
        '/addService': (context) => AddService(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/serviceDashboard': (context) => ServiceDashboard(),
        '/adminDashboard': (context) => AdminDashboard(),
        '/adminList': (context) => AdminList(),
        '/adminUpdate': (context) => AdminUpdate(),
      },
      initialRoute: '/dashboard',
    );
  }
}
