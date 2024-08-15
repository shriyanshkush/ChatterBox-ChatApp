import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/navigation_service.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _loginpagestate();
  }
}

class _loginpagestate extends State<Loginpage> {
  final GlobalKey<FormState> _loginformkey = GlobalKey<FormState>();
  String? email,password;
  final GetIt _getIt=GetIt.instance;
  late Authservice _authservice;
  late NavigationService _navigationService;
  late AlertServices _alertServices;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authservice=_getIt.get<Authservice>();
    _navigationService=_getIt.get<NavigationService>();
    _alertServices=_getIt.get<AlertServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BuildUI(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget BuildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            _headertext(),
            _loginform(),
          ],
        ),
      ),
    );
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
            "Hi, Welcome Back!",style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.w800),
          ),
          Text(
            "Hello again, you have been missed!",style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w500,color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _loginform() {
    return Container(
      height: MediaQuery.sizeOf(context).height*0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05
      ),
      child: Form(
        key: _loginformkey,
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Customfields(Height: MediaQuery.sizeOf(context).height*0.1,
              HintText: "Email",
            onSaved: (value) {
            setState(() {
              email=value;
            });
            },
            validationRegEx: EMAIL_VALIDATION_REGEX,
          ),
          Customfields(Height: MediaQuery.sizeOf(context).height*0.1,
              HintText: "Password",
          obsecuretext: true,
            onSaved: (value) {
              setState(() {
                password=value;
              });
            },
          validationRegEx: PASSWORD_VALIDATION_REGEX,),
          _loginButton(),
          _createloginlink()
        ],
      ),),
    );
  }


  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(onPressed: () async{
        if (_loginformkey.currentState != null && _loginformkey.currentState!.validate()) {
        }
        _loginformkey.currentState?.save();
        bool result= await _authservice.login(email!, password!);
        print(result);
        if(result) {
          _navigationService.pushReplacementnamed("/home");
        } else{
          _alertServices.showToast(text: "Failed to login, Please try again!",
          icon: Icons.error);
        }
      },
        color:Theme.of(context).colorScheme.primary,
      child: Text("Login",style: TextStyle(
        color: Colors.white
      ),),),
    );
  }

  Widget _createloginlink() {
    return  Expanded(child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [ const Text("Don't have an account?"),
      GestureDetector(
        onTap: () {
          _navigationService.pushnamed("/register");
        },
          child: const Text("Sign up",style: TextStyle(fontWeight: FontWeight.w800),))],

    ));
  }
}