import 'dart:io';
 import 'package:firebase_storage/firebase_storage.dart';

 class CloudStorageService{
   static CloudStorageService instance = CloudStorageService();
   late FirebaseStorage _storage;
   late dynamic _baseRef;

   String _profileImages  = "profile_images";

   CloudStorageService(){
     _storage = FirebaseStorage.instance;
     _baseRef = _storage.ref();
   }
    Future<dynamic> uploadUserImage(String uid,File _image) async {
     try{
       await _baseRef.child(_profileImages).child(uid).putFile(_image);
       return _baseRef.child(_profileImages).child(uid);
     }
     catch(e){
       print(e);
     }
    }
}