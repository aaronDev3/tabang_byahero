import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.135,
                  width: MediaQuery.of(context).size.width * 0.810,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/byahero_logo.png"),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        fillColor: Colors.lightBlueAccent,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'View List',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/byaheroList'),
                      ),
                      RawMaterialButton(
                        fillColor: Colors.blue,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'View Map',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/byaheroMap'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
