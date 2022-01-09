import 'package:flutter/material.dart';

class ServiceDashboard extends StatelessWidget {
  final String img = "assets/autoshop_pic/autoshop2.jpg";
  final String contactNo = '09363947384';

  //final String user = 'gasoline';
  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context).settings.arguments;
    int itemCount = 1;
    return itemCount == 1
        ? Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(Icons.logout),
                onTap: () => Navigator.pushNamed(context, '/dashboard'),
              ),
              title: GestureDetector(
                  child: Text('logout'),
                  onTap: () => Navigator.pushNamed(context, '/dashboard')),
              actions: <Widget>[
                TextButton(
                  child: Row(
                    children: [
                      Text(
                        user == 'autoshop'
                            ? 'Add autoshop'
                            : user == 'gasoline'
                                ? 'Add gasoline'
                                : user == 'mechanic'
                                    ? 'Add mechanic'
                                    : '',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                      )
                    ],
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/addService',
                      arguments: user),
                ),
              ],
            ),
            body: DefaultTabController(
              length: 1,
              child: Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image(
                            image: AssetImage(img),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.9,
                            fit: BoxFit.fill),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 5),
                          width: 152,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(21)),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call, color: Colors.blue),
                                  Text(
                                    contactNo,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.pop(context),
                            ),
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
                    SizedBox(height: 20),
                    Text(
                      'Autoshop name',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 11),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.blue),
                        Text('Address', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(height: 11),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.blue),
                        Text('Open: Monday - Sunday (10:00AM - 8:00PM)',
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(height: 11),
                    Row(
                      children: [
                        Icon(Icons.directions_outlined, color: Colors.blue),
                        Text('100 meters', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(height: 11),
                    Expanded(
                      child: TabBarView(children: <Widget>[
                        Container(
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) => Card(
                              child: ListTile(
                                leading: Icon(Icons.home_outlined),
                                title: Text('Name'),
                                trailing: Text('Price'),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )
        : DefaultTabController(
            length: 1,
            child: Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  TextButton(
                    child: Row(
                      children: [
                        Text(
                          user == 'autoshop'
                              ? 'Add autoshop'
                              : user == 'gasoline'
                                  ? 'Add gasoline'
                                  : user == 'mechanic'
                                      ? 'Add mechanic'
                                      : '',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/addService',
                        arguments: 'autoshop'),
                  ),
                ],
              ),
              body: TabBarView(children: <Widget>[
                ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text('autoshop'),
                    subtitle: Text('Distance'),
                    onTap: () => null,
                  ),
                ),
              ]),
            ),
          );
  }
}
