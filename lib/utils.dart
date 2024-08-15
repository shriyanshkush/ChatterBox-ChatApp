import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/meadia_service.dart';
import 'package:chatapp/Services/navigation_service.dart';
import 'package:chatapp/Services/strorage_service.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';



Future<void> setupFirebase() async{
  await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform );
}

Future<void> registerservices() async{
  final GetIt getIt=GetIt.instance;
  getIt.registerSingleton <Authservice>(Authservice());
  getIt.registerSingleton <NavigationService>(NavigationService());
  getIt.registerSingleton <AlertServices>(AlertServices());
  getIt.registerSingleton <Mediaservice>(Mediaservice());
  getIt.registerSingleton <Storageservice>(Storageservice());
  getIt.registerSingleton <DatabaseService>(DatabaseService());
}

String GenerateChatID ({required String uid1, required String uid2}) {
  List<String> uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("", (id, uid) => "$id$uid");
  return chatID;
}