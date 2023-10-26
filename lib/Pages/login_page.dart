import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify/services/navigation_service.dart';
import '../providers/auth_provider.dart';
import '../services/snackbar_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  late double deviceHeight;
  late double deviceWidth;
  GlobalKey<FormState>? formKey;
  AuthProvider? _auth;
  String? email;
  String? password;

  LoginPageState() {
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Align(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: loginPageUI(),
        ),
      ),
    );
  }

  Widget loginPageUI() {
    return Builder(
      builder: (BuildContext context) {
        SnackBarService.instance.buildContext = context;
        _auth = Provider.of<AuthProvider>(context);
        return Container(
          height: deviceHeight * 0.60,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              headingwidget(),
              inputForm(),
              loginButton(),
              registerButton(),
            ],
          ),
        );
      },
    );
  }

  Widget headingwidget() {
    return Container(
      height: deviceHeight * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Welcome back!",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please login to your account.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  Widget inputForm() {
    return Container(
      height: deviceHeight * 0.16,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey?.currentState?.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(color: Colors.white),
      validator: (input) {
        return (input?.length != 0 && input!.contains("@"))
            ? null
            : "Please Enter a valid email";
      },
      onSaved: (input) {
        setState(() {
          email = input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
          hintText: "Email Address",
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      validator: (input) {
        return (input?.length != 0) ? null : "Please Enter a passward";
      },
      onSaved: (input) {
        setState(() {
          password = input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
          hintText: "Password",
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }

  Widget loginButton() {
    return _auth?.status == AuthStatus.authenticating
        ? const Align(alignment: Alignment.center, child: CircularProgressIndicator(),)
        : SizedBox(
            height: deviceHeight * 0.06,
            width: deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (formKey!.currentState!.validate()) {
                  _auth?.loginUserWithEmailAndPassword(email!, password!);
                  //Login user
                }
              },
              color: Colors.blue,
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
  }

  Widget registerButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigateTo("register");
      },
      child: SizedBox(
        height: deviceHeight * 0.06,
        width: deviceWidth,
        child: Text(
          "REGISTER",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
