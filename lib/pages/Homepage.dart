
import 'dart:io';

import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Services/auth_service.dart';
import '../Services/navigation_service.dart';

class Homepage extends StatefulWidget {

  const Homepage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Homepagestate();
  }

}

class _Homepagestate extends State<Homepage> {
  File? selectedImage;
  String profileImageUrl = "";
  String usernameforprofilepictap="";
  final GetIt _getIt=GetIt.instance;
  late NavigationService _navigationService;
  late Authservice _authservice;
  late AlertServices _alertServices;
  late DatabaseService _databaseService;
  UserProfile? loggedInuserProfile;

  @override
  void initState() {
    super.initState();
    _authservice=_getIt.get<Authservice>();
    _navigationService=_getIt.get<NavigationService>();
    _alertServices=_getIt.get<AlertServices>();
    _databaseService=_getIt.get<DatabaseService>();
    Stream<QuerySnapshot<UserProfile>> querySnapshotStream = _databaseService.getCurrentUserProfiles();
    querySnapshotStream.map((querySnapshot) => querySnapshot.docs.first.data()).listen((userProfileData) {
      setState(() {
        loggedInuserProfile = userProfileData;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Messages"),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(backgroundImage:
            NetworkImage(loggedInuserProfile?.pfpURL ?? 'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg'),),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Option 1',
                child: GestureDetector(
                  onTap: () {
                    _navigationService.pushnamed("/profilepage");
                  },
                  child: Text('View Profile'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Option 2',
                child: GestureDetector(
                  onTap: () async{
                    bool result= await _authservice.logout();
                    if(result) {
                      _alertServices.showToast(text: "Successfully logged out!",
                          icon: Icons.check);
                      _navigationService.pushReplacementnamed("/login");
                    }
                  },
                  child: Text('Log out'),
                ),
              ),
            ],
          ),

        ],
      ),
      body: _buildUI(),
    );
  }


  Widget _buildUI() {
    return SafeArea(child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal:15.0,
        vertical: 20.0,
      ),
      child:_chatlist() ,
    ));
  }

  Widget _chatlist() {
    return StreamBuilder(stream: _databaseService.getUserProfiles(),
        builder: (context,snapshot){
      if(snapshot.hasError) {
        return const Center(
          child: Text("Unable to load data."),
        );
      }
      if(snapshot.hasData && snapshot.data!=null) {
        final users=snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
            itemBuilder: (context,index) {
            UserProfile user=users[index].data();
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0
              ),
              child: ChatTile(userProfile: user,
                  Onprofilepictap: (){
                setState(() {
                  profileImageUrl= user.pfpURL!;
                  usernameforprofilepictap= user.name!;
                });
                    showProfilePic();
                  },
                  Ontap:() async{
                final chatexists =await _databaseService.checkChatExists(
                    _authservice.user!.uid, user.uid!);
               if(!chatexists) {
                 await _databaseService.createNewChat(_authservice.user!.uid, user.uid!);
               }
               _navigationService.push(MaterialPageRoute(builder: (context) {
                 return ChatPage(chatUser: user,);
               },),);

              }),
            );
        });
      }
      return Center(
        child: CircularProgressIndicator(),
      );
        });

  }

  void showProfilePic() {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 400,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: Column(
                children: [
                  Text(usernameforprofilepictap,style: TextStyle(fontSize: 25),),
                  SizedBox(height: 10,),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(profileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
          );
        },
    );
  }
}