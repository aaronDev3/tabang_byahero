import 'package:byahero_app/db_helper/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showPassword = true;
  bool showConfirmPassword = true;
  String username, password, confirmPassword;
  final formKey = GlobalKey<FormState>();

  String userType = 'Autoshop';
  String user = '';

  List<String> items = <String>[
    'Autoshop',
    'Gasoline Station',
    'Mechanic',
  ];
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

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
                  padding:
                      EdgeInsets.only(top: 23, bottom: 10, left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: TextFormField(
                      controller: usernameController,
                      onChanged: (textValue) {
                        setState(() {
                          username = textValue;
                        });
                      },
                      validator: (usernameValue) {
                        if (usernameValue.isEmpty) {
                          return;
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
                      controller: passwordController,
                      onChanged: (textValue) {
                        setState(() {
                          password = textValue;
                        });
                      },
                      validator: (passwordValue) {
                        if (passwordValue.isEmpty) {
                          return;
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
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: TextFormField(
                      controller: confirmController,
                      onChanged: (textValue) {
                        setState(() {
                          confirmPassword = textValue;
                        });
                      },
                      validator: (confirmPasswordValue) {
                        if (confirmPasswordValue.isEmpty) {
                          return;
                        }
                        return null;
                      },
                      obscureText: showConfirmPassword,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: "Confirm password",
                        suffixIcon: IconButton(
                          icon: showConfirmPassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () => {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            })
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Type of user:    ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    DropdownButton<String>(
                      dropdownColor: Colors.blue,
                      onChanged: (String newValue) {
                        setState(() {
                          userType = newValue;
                        });
                      },
                      value: userType,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      items: items.map<DropdownMenuItem<String>>(
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
                      onPressed: () async {
                        if (password.trim() != confirmPassword.trim()) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("Password not matched!"),
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
                        } else if (password.length <= 5) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                    "Password must be at least 6 characters!"),
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
                        } else if (username == "" ||
                            password == "" ||
                            confirmPassword == "") {
                          return;
                        } else {
                          if (userType == 'Autoshop') {
                            user = 'autoshop';
                          } else if (userType == 'Gasoline Station') {
                            user = 'gasoline';
                          } else if (userType == 'Mechanic') {
                            user = 'mechanic';
                          }
                          await DatabaseHelper.instance.insert(
                            {
                              DatabaseHelper.userId: DateTime.now().toString(),
                              DatabaseHelper.username: '$username',
                              DatabaseHelper.password: '$password',
                              DatabaseHelper.userType: '$user'
                            },
                          );

                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("Successfully added!"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text("OK"),
                                    onPressed: () {
                                      usernameController.clear();
                                      passwordController.clear();
                                      confirmController.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Register",
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
                        "Already have an account ? ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      GestureDetector(
                          child: Text(
                            "Sign-in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () => Navigator.pushNamed(context, '/login')),
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
