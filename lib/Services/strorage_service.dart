import 'dart:io';
import 'package:chatapp/models/chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
class Storageservice{
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;

  Storageservice() {

  }

  Future<String?> uploadUserpfp({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage.ref().
    child("user/pfps/$uid${p.extension(file.path)}");
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }

  Future<String?> uploadImages({required File file,required String chatID}) async{

    Reference fileRef =_firebaseStorage.ref("chat/$chatID")
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task =fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });

  }
  Future<void> deleteUserPfpFile(String uid,File file) async {
    try {
      Reference fileRef = _firebaseStorage.ref().child("user/pfps/$uid${p.extension(file.path)}");
      await fileRef.delete();
      print("Profile picture deleted successfully");
    } catch (e) {
      print("Error deleting profile picture: $e");
    }
  }


}