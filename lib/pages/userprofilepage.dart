
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../Services/database_service.dart';
import '../Services/meadia_service.dart';
import '../Services/strorage_service.dart';
import '../models/user_profile.dart';

class Userprofilepage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UserprofilepageState();
  }

}

class UserprofilepageState extends State<Userprofilepage> {
  String userEmail = "";
  File? selectedImage;
  final GetIt _getIt = GetIt.instance;
  late DatabaseService _databaseService;
  late Mediaservice _mediaservice;
  late Storageservice _storageservice;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _databaseService = _getIt.get<DatabaseService>();
    _storageservice = _getIt.get<Storageservice>();
    _mediaservice = _getIt.get<Mediaservice>();
    Stream<QuerySnapshot<UserProfile>> querySnapshotStream = _databaseService.getCurrentUserProfiles();
    querySnapshotStream.map((querySnapshot) => querySnapshot.docs.first.data()).listen((userProfileData) {
      setState(() {
        userProfile = userProfileData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 25),),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () async {
                  if (userProfile != null) {
                    File? file = await _mediaservice.getImagefromGallery();
                    if (file != null) {
                      setState(() {
                        selectedImage = file;
                        if (selectedImage != null) {
                          _storageservice.deleteUserPfpFile(userProfile!.uid!,selectedImage!);
                          _storageservice.uploadUserpfp(file: selectedImage!, uid: userProfile!.uid!).then((imageUrl) {
                            setState(() {
                              userProfile!.pfpURL = imageUrl;
                            });
                          });
                        }
                      });
                    }
                  }
                },
                child: userProfile != null
                    ? CircleAvatar(
                  radius: MediaQuery.sizeOf(context).width*0.25,
                  backgroundImage: NetworkImage(userProfile?.pfpURL ?? 'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg'),
                )
                    : Center(child: CircularProgressIndicator()), // display a loading indicator if userProfile is null
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.sizeOf(context).width*0.85,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade400,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(Icons.person_outline,size: 40,),
                      SizedBox(width: 25,),
                      userProfile != null
                          ? Column(
                            children: [
                              Text("Name:",style: TextStyle(fontSize: 20),),
                              SizedBox(height: 8,),
                              Text(userProfile!.name!, style: TextStyle(fontSize: 20),),
                            ],
                          )
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: MediaQuery.sizeOf(context).width*0.85,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade400,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined,size: 40,),
                      SizedBox(width: 25,),
                      userProfile != null
                          ? Column(
                        children: [
                          Text("Email:",style: TextStyle(fontSize: 20),),
                          SizedBox(height: 8,),
                          Text(userEmail, style: TextStyle(fontSize: 20),),
                        ],
                      )
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              )// display an empty container if userProfile is null
            ],
          ),
        ),
      ),
    );
  }

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email ?? "No user signed in";
    });
  }
}