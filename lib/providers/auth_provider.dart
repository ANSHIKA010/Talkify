import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:talkify/services/navigation_service.dart';
import '../services/snackbar_service.dart';
import '../services/navigation_service.dart';
enum AuthStatus{
  notAuthenticated,
  authenticating,
  authenticated,
  userNotFound,
  error,
}

class AuthProvider extends ChangeNotifier{
  User? user;
  AuthStatus? status;
  FirebaseAuth? _auth;
  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }
  void loginUserWithEmailAndPassword(String email, String password) async{
    status = AuthStatus.authenticating;
    notifyListeners();
    try{
     UserCredential? result = await _auth?.signInWithEmailAndPassword(email: email, password: password);
     user = result?.user;
     status = AuthStatus.authenticated;
     print("Logged in Successfully");
     SnackBarService.instance.showSnackBarSuccess("Welcome, ${user!.email}");
     //update lastseen time
      NavigationService.instance.navigateToReplacement("home");
    }catch (e){
      status= AuthStatus.error;
      print("Login Error");
      user = null;
      SnackBarService.instance.showSnackBarError("Error Authenticating ");

    }
    notifyListeners();
  }
 void registerUserWithEmailAndPassword(String email,String password, Future<void> Function(String uid) onSuccess) async{
    status = AuthStatus.authenticating;
    notifyListeners();
    try{
      UserCredential? result = await _auth?.createUserWithEmailAndPassword(email: email, password: password);
      user = result?.user;
      status  = AuthStatus.authenticated;
      await onSuccess((user?.uid)!);
      SnackBarService.instance.showSnackBarSuccess("Welcome, ${user!.email}");
      //update lastseen time
      NavigationService.instance.goBack();
      NavigationService.instance.navigateToReplacement("home");
    }
    catch(e){
      status = AuthStatus.error;
      user =  null;
      SnackBarService.instance.showSnackBarError("Error Registering user");

    }
    notifyListeners();
 }

}

