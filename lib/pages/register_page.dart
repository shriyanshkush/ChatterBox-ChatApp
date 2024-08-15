
import 'dart:io';

import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/meadia_service.dart';
import 'package:chatapp/Services/navigation_service.dart';
import 'package:chatapp/Services/strorage_service.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }

}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerformkey = GlobalKey<FormState>();
  File? selectedImage;
  final GetIt _getIt=GetIt.instance;
  late Mediaservice _mediaservice;
  late NavigationService _navigationService;
  late Authservice _authservice;
  late Storageservice _storageservice;
  late DatabaseService _databaseService;
  late AlertServices _alertServices;

  String? email,password,name;
  bool Isloading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaservice=_getIt.get<Mediaservice>();
    _navigationService=_getIt.get<NavigationService>();
    _authservice=_getIt.get<Authservice>();
    _storageservice=_getIt.get<Storageservice>();
    _databaseService=_getIt.get<DatabaseService>();
    _alertServices=_getIt.get<AlertServices>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }


  Widget _buildUI() {
    return SafeArea(child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal:15.0,
      ),
      child: Column(
        children: [
          _headertext(),
          if(!Isloading)_registerform(),
          if(!Isloading)_loginAccountlink(),
          if(Isloading) const Expanded(child: Center(
            child:CircularProgressIndicator(),))
        ],
      ),
    ));
  }

  Widget _headertext() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's,get going!",style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w800),
          ),
          Text(
            "Register an account using from below",style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w500,color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _registerform() {
    return Container(
      height: MediaQuery.sizeOf(context).height*0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05
      ),
      child: Form(
        key: _registerformkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpselectionfeild (),
            Customfields(HintText: "Name",
                Height: MediaQuery.sizeOf(context).height*0.1,
                validationRegEx: NAME_VALIDATION_REGEX,
                onSaved:(value) {
              setState(() {
                name=value;
              });
                } ),
            Customfields(HintText: "Email",
                Height: MediaQuery.sizeOf(context).height*0.1,
                validationRegEx: EMAIL_VALIDATION_REGEX,
                onSaved:(value) {
                  setState(() {
                    email=value;
                  });
                } ),
            Customfields(HintText: "Password",
                Height: MediaQuery.sizeOf(context).height*0.1,
                obsecuretext: true,
                validationRegEx: PASSWORD_VALIDATION_REGEX,
                onSaved:(value) {
                  setState(() {
                    password=value;
                  });
                } ),
            _registerbutton (),
          ],
        ),
      ),
    );
  }

  Widget _pfpselectionfeild () {
    return GestureDetector(
      onTap: () async{
        File? file=await _mediaservice.getImagefromGallery();
        if(file!=null) {
          setState(() {
            selectedImage=file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width*0.15,
        backgroundImage: selectedImage!=null?FileImage(selectedImage!):NetworkImage(PLACEHOLDER_PFP)
        as ImageProvider,
      ),
    );
  }
  
  Widget _registerbutton () {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
        child: MaterialButton(onPressed: () async{
          setState(() {
            Isloading=true;
          });
          try {
            if((_registerformkey.currentState?.validate() ?? false) && (selectedImage != null)) {

              _registerformkey.currentState?.save();
              bool result =await _authservice.signup(email!, password!);
              if(result) {
                String? pfpURL = await _storageservice.uploadUserpfp(file: selectedImage!,
                    uid: _authservice.user!.uid);
                if(pfpURL !=null) {
                  await _databaseService.createUserProfile(userProfile:
                  UserProfile(uid: _authservice.user!.uid,
                      name: name,
                      pfpURL: pfpURL));
                  _alertServices.showToast(text: "User registered Succesfully",icon:Icons.check);
                  _navigationService.goback();
                  _navigationService.pushReplacementnamed("/home");
                } else{
                  throw Exception("Unable to upload User Profile picture");
                }

              } else {
                throw Exception("Unable to register User");
              }
            }
          } catch(e) {
            _alertServices.showToast(text: "Failed to register,Please try again!",icon:Icons.error);
            print("Error registering user: $e");
          }
          setState(() {
            Isloading=false;
          });
        },color: Theme.of(context).colorScheme.primary,
          child: const Text("Register",style: TextStyle(color: Colors.white),),));
  }

  Widget _loginAccountlink() {
    return  Expanded(child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [ const Text("Already have an account"),
        GestureDetector(
            onTap: () {
              _navigationService.goback();
            },
            child: const Text("Log in",style: TextStyle(fontWeight: FontWeight.w800),))],

    ));
  }
}