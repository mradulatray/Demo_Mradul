import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/chat.dart';
import '../models/conversation.dart';
import '../repository/chat_repository.dart';
import '../repository/notification_repository.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class ChatController extends ControllerMVC {
  Conversation? conversation;
  ChatRepository _chatRepository = ChatRepository();
  Stream<QuerySnapshot>? conversations;
  Stream<QuerySnapshot>? chats;
  // GlobalKey<ScaffoldState> scaffoldKey;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // BuildContext get safeContext {
  //   return state?.context ?? scaffoldKey.currentContext!;
  // }
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

//   ChatController() {
//     this.scaffoldKey = new GlobalKey<ScaffoldState>();
//     _chatRepository = new ChatRepository();
// //    _createConversation();
//   }

  signIn() {
    //_chatRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
//    _chatRepository.signInWithToken(currentUser.value.apiToken);
  }

  createConversation(Conversation _conversation) async {
    _conversation.users?.insert(0, currentUser.value);
    _conversation.lastMessageTime =
        DateTime.now().toUtc().millisecondsSinceEpoch;
    _conversation.readByUsers = [currentUser.value.id ?? ''];
    setState(() {
      conversation = _conversation;
    });
    if(conversation!=null){
    _chatRepository.createConversation(conversation!).then((value) {
      listenForChats(conversation!);
    });}
  }

  listenForConversations() async {
    _chatRepository
        .getUserConversations(currentUser.value.id ?? '')
        .then((snapshots) {
      setState(() {
        conversations = snapshots;
      });
    });
  }

  listenForChats(Conversation _conversation) async {
    _conversation.readByUsers?.add(currentUser.value.id ?? '');
    _chatRepository.getChats(_conversation).then((snapshots) {
      setState(() {
        chats = snapshots;
        //chats.
      });
    });
  }

  addMessage(Conversation _conversation, String text) {
    Chat _chat = new Chat(text, DateTime.now().toUtc().millisecondsSinceEpoch,
        currentUser.value.id);
    if (_conversation.id == null) {
      _conversation.id = UniqueKey().toString();
      createConversation(_conversation);
    }
    _conversation.lastMessage = text;
    _conversation.lastMessageTime = _chat.time;
    _conversation.readByUsers = [currentUser.value.id ?? ''];
    _chatRepository.addMessage(_conversation, _chat).then((value) {
      _conversation.users?.forEach((_user) {
        if (_user.id != currentUser.value.id && safeContext != null) {
          sendNotification(
              text,
              S.of(safeContext!).newMessageFrom +
                  " " +
                  (currentUser.value.name ?? ''),
              _user);
        }
      });
    });
  }

  orderSnapshotByTime(AsyncSnapshot snapshot) {
    final docs = snapshot.data.documents;
    docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
      var time1 = a.get('time');
      var time2 = b.get('time');
      return time2.compareTo(time1) as int;
    });
    return docs;
  }
}
