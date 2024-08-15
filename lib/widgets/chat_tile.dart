import 'package:chatapp/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function Ontap;
  final Function Onprofilepictap;
  const ChatTile({super.key,required this.userProfile,
  required this.Ontap,required this.Onprofilepictap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Ontap();
      },
      dense:false,
      leading: GestureDetector(
        onTap: (){
          Onprofilepictap();
        },
          child: CircleAvatar(backgroundImage: NetworkImage(userProfile.pfpURL!),)),
      title: Text(userProfile.name!),
    );
  }

}