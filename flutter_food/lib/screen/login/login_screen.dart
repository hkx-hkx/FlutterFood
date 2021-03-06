import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter_food/constant.dart';
import 'package:flutter_food/screen/home/home_screen.dart';
import 'package:flutter_food/screen/login/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  createState() => _LoginScrennState();
}

class _LoginScrennState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  late String userName;
  late String password;
  bool isShowPassword = false;

  void showPassword() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color.fromARGB(255, 53, 53, 53), fontSize: 50.0),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 240, 240, 240),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "??????????????????",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 93, 93, 93),
                        ),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        userName = value!;
                      },
                      controller: nameController,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 240, 240, 240),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "???????????????",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 93, 93, 93),
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isShowPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 126, 126, 126),
                            ),
                            onPressed: showPassword,
                          )),
                      obscureText: !isShowPassword,
                      onSaved: (value) {
                        password = value!;
                      },
                      controller: passwordController,
                    ),
                  ),
                  Container(
                    height: 45.0,
                    margin: EdgeInsets.only(top: 40.0),
                    child: SizedBox.expand(
                      child: RaisedButton(
                        child: Text(
                          "??????",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.0)),
                        color: Color.fromARGB(255, 61, 203, 128),
                        onPressed: () {
                          // ?????????????????????
                          login(nameController.text, passwordController.text);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            child: Text(
                              '????????????',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color.fromARGB(255, 53, 53, 53)),
                            ),
                            onTap: () {
                              // ?????????????????????
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          "???????????????",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Color.fromARGB(255, 53, 53, 53),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login(String userName, String password) async {
    CloudBaseCore core = CloudBaseCore.init({
      'env': 'hello-cloudbase-9gmoljho0dd9d4c1',
      'appAccess': {'key': '19e089b73f596c14dc6aed441867cb83', 'version': '1'}
    });

    // ????????????
    CloudBaseAuth auth = CloudBaseAuth(core);
    CloudBaseAuthState authState = await auth.getAuthState();

    if (authState == null) {
      await auth.signInAnonymously();
    }

    CloudBaseFunction cloudbase = CloudBaseFunction(core);

    // ????????????
    Map<String, dynamic> data = {'userName': userName, 'passWord': password};
    CloudBaseResponse res = await cloudbase.callFunction('login', data);
    if (res.data['err_code'] == 0) {
      // ????????????
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("????????????"),
          ),
      );
      Global.isLogin = true;
      Global.userName = userName;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomeScreen()), (Route<dynamic> route) => false);
    } else if (res.data['err_code'] == -1) {
      // ???????????????
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("?????????????????????"),
              ));
    } else {
      // ????????????
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("????????????"),
              ));
    }
  }
}
