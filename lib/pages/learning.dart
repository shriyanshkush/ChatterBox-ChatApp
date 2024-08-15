/* Firebase Setup:
open firebase in google, sign in go to console add new project enter name.


flutter run --debug
*/
/*
import 'dart:io';

import 'package:chatapp/Services/strorage_service.dart';
import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get_it/get_it.dart';

import '../Services/auth_service.dart';
import '../Services/database_service.dart';
import '../Services/meadia_service.dart';
import '../utils.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;

  const ChatPage({super.key,required this.chatUser});
  @override
  State<StatefulWidget> createState() {
    return _ChatPagestate();
  }
}

class _ChatPagestate extends State<ChatPage > {
  ChatUser? currentuser,otheruser;
  final GetIt _getIt=GetIt.instance;
  late Authservice _authservice;
  late DatabaseService _databaseService;
  late Mediaservice _mediaservice;
  late Storageservice _storageservice;
  @override
  void initState() {
    super.initState();
    _authservice=_getIt.get<Authservice>();
    _databaseService=_getIt.get<DatabaseService>();
    _storageservice=_getIt.get<Storageservice>();

    currentuser=ChatUser(id: _authservice.user!.uid,
    firstName: _authservice.user!.displayName);

    otheruser=ChatUser(id: widget.chatUser.uid!,
        firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpURL,
    );
    _mediaservice=_getIt.get<Mediaservice>();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(stream: _databaseService.getChatData(
        currentuser!.id, otheruser!.id), builder: (context,snapshot) {
      Chat? chat= snapshot.data?.data();
      List<ChatMessage> messages=[];

      if(chat!=null && chat.messages!=null) {
        messages=_generateMessage(chat.messages!);
      }
      return DashChat(
          messageOptions: const MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true,
          ),
          inputOptions: InputOptions(
            trailing: [_meadiaMessageButton()],
            alwaysShowSend: true,
          ),
          currentUser: currentuser!,
          onSend: _sendMessage,
          messages: messages
      );

    });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      final media = chatMessage.medias!.first;
      MessageType messageType;
      switch (media.type) {
        case MediaType.image:
          messageType = MessageType.Image;
          break;
        case MediaType.video:
          messageType = MessageType.Video;
          break;
        case MediaType.file:
          messageType = MessageType.File;
          break;
        default:
          return;
      }
      Message message = Message(
        senderID: chatMessage.user.id,
        content: media.url,
        messageType: messageType,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      await _databaseService.sentChatMessage(currentuser!.id, otheruser!.id, message);
    } else {
      Message message = Message(
        senderID: currentuser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      await _databaseService.sentChatMessage(currentuser!.id, otheruser!.id, message);
    }
  }


  List<ChatMessage> _generateMessage(List<Message> messages) {
    List<ChatMessage> chatmessages = messages.map((m) {
      ChatUser user = m.senderID == currentuser!.id ? currentuser! : otheruser!;
      ChatMedia? chatMedia;
      switch (m.messageType) {
        case MessageType.Image:
          chatMedia = ChatMedia(url: m.content!, fileName: "", type: MediaType.image);
          break;
        case MessageType.Video:
          chatMedia = ChatMedia(url: m.content!, fileName: "", type: MediaType.video);
          break;
        case MessageType.File:
          chatMedia = ChatMedia(url: m.content!, fileName: "", type: MediaType.file); // Assuming custom type for GIFs
          break;
        default:
          break;
      }
      if (chatMedia != null) {
        return ChatMessage(
          user: user,
          createdAt: m.sentAt!.toDate(),
          medias: [chatMedia],
        );
      } else {
        return ChatMessage(
          user: user,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatmessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return chatmessages;
  }


  Widget _meadiaMessageButton() {
    return IconButton(onPressed: () async{
      File? file=await _mediaservice.getImagefromGallery();
      if(file!=null) {
        String chatID= GenerateChatID(
          uid1: currentuser!.id,
          uid2: otheruser!.id,
        );
        String? downloadURL= await _storageservice.uploadImages(file: file, chatID:chatID );
        if(downloadURL!=null) {
          ChatMessage chatMessage=ChatMessage(user: currentuser!, createdAt: DateTime.now(),
              medias: [ChatMedia(url: downloadURL, fileName: "", type: MediaType.image)]);
          _sendMessage(chatMessage);
        }
      }
    },
        icon: Icon(Icons.image,
          color: Theme.of(context).colorScheme.primary,
        ));

  }

}
* */

/*
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
class Mediaservice {
  final ImagePicker _imagePicker=ImagePicker();

  Mediaservice() {

  }

  Future<File?> getImagefromGallery () async{
    final XFile? _file=await _imagePicker.pickImage(source:ImageSource.gallery);
    if(_file!=null) {
      return File(_file!.path);
    }
    else{
      return null;
    }

  }

  Future<File?> getVideoFromGallery() async {
    final XFile? file = await _imagePicker.pickVideo(
        source: ImageSource.gallery);
    return file != null ? File(file.path) : null;
  }

  Future<File?> getAnyMediaFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  }
* */
/*
enum MessageType { Text, Image,Video ,File }
* */