import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPassword = true;
  String username, password;
  final formKey = GlobalKey<FormState>();

  void signIn(String inputUser, String inputPassword) async {
    List<Map> search =
        await DatabaseHelper.instance.search('$inputUser', '$inputPassword');
    search.forEach((row) {
      List idAndUserType = ['${row['userid']}', '${row['userType']}'];
      Navigator.pushNamed(context, '/byaheroDetails', arguments: idAndUserType);
    });

    if (inputUser == 'admin' && inputPassword == 'admin') {
      Navigator.pushNamed(context, '/adminDashboard');
    } else if (search.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("User not found!"),
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
          body: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  padding:
                      EdgeInsets.only(top: 23, bottom: 10, left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: TextFormField(
                      onChanged: (textValue) {
                        setState(() {
                          username = textValue;
                        });
                      },
                      validator: (userValue) {
                        if (userValue.isEmpty) {
                          return null;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person_outline),
                        hintText: "Username",
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: TextFormField(
                      onChanged: (textValue) {
                        setState(() {
                          password = textValue;
                        });
                      },
                      validator: (passwordValue) {
                        if (passwordValue.isEmpty) {
                          return null;
                        }
                        return null;
                      },
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: "Password",
                        suffixIcon: IconButton(
                            icon: showPassword
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () => {
                                  setState(() {
                                    showPassword = !showPassword;
                                  })
                                }),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: Colors.blue,
                    ),
                    child: RawMaterialButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          signIn(username, password);
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ? ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      GestureDetector(
                          child: Text(
                            "Sign-up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () =>
                              Navigator.pushNamed(context, '/register')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
