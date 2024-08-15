import 'package:chatapp/Services/navigation_service.dart';
import 'package:chatapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';



void main() async{
  await setup();
  runApp(MyApp());
}

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerservices();
}
class MyApp extends StatelessWidget {

  final GetIt _getIt=GetIt.instance;
  late NavigationService _navigationService;


  MyApp({super.key}) {
    _navigationService= _getIt.get<NavigationService>();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorkey,
      title: 'ChatterBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade600,
          centerTitle: true
        )
      ),
      initialRoute:"/SplashScreen",
      routes: _navigationService.routes,
    );
  }
}