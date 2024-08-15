import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../utils.dart';


class DatabaseService {
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  CollectionReference? _userCollection;
  CollectionReference? _chatCollection;
  final GetIt _getIt=GetIt.instance;
  late Authservice _authservice;

  DatabaseService() {
    _authservice=_getIt.get<Authservice>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userCollection=_firebaseFirestore.collection('users').withConverter<UserProfile>(
        fromFirestore: (snapshots,_)=>UserProfile.fromJson(snapshots.data()!),
        toFirestore: (userprofile,_)=>userprofile.toJson());
    _chatCollection=_firebaseFirestore.collection('chats').withConverter<Chat>(
        fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
        toFirestore: (chat,_) =>chat.toJson());
  }

  Future <void> createUserProfile({required UserProfile userProfile}) async{
    await _userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _userCollection?.where("uid",isNotEqualTo: _authservice.user!.uid).
    snapshots() as Stream<QuerySnapshot<UserProfile>>;

  }

  Future<bool> checkChatExists(String uid1,String uid2) async{
    String chatID= GenerateChatID(uid1:uid1,uid2:uid2);
    final result =await _chatCollection?.doc(chatID).get();
    if(result!=null) {
      return result.exists;
    }
    return false;

  }

  Future<void> createNewChat(String uid1,String uid2) async {
    String chatID= GenerateChatID(uid1:uid1,uid2:uid2);
    final docRef =_chatCollection!.doc(chatID);
    final chat =Chat(id: chatID, participants:[uid1,uid2],
        messages: []);
    await docRef.set(chat);
  }

  Future<void> sentChatMessage(String uid1,String uid2,Message message) async{
    String chatID= GenerateChatID(uid1:uid1,uid2:uid2);
    final docRef =_chatCollection!.doc(chatID);
    await docRef.update({
        "messages" :FieldValue.arrayUnion([
          message.toJson()
        ]),},);
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1,String uid2) {
    String chatID= GenerateChatID(uid1:uid1,uid2:uid2);
    return _chatCollection?.doc(chatID).snapshots() as Stream<DocumentSnapshot<Chat>>;
  }

  Stream<QuerySnapshot<UserProfile>> getCurrentUserProfiles() {
    return _userCollection?.where("uid",isEqualTo: _authservice.user!.uid).
    snapshots() as Stream<QuerySnapshot<UserProfile>>;

  }
}