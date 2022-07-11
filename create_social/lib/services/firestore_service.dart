import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:create_social/models/conversation.dart';
import 'package:create_social/models/message.dart';
import 'package:create_social/models/post.dart';
import 'package:create_social/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class FirestoreService {
  final fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  static Map<String, User> userMap = {};
  static Map<String, Post> postMap = {};

  final Map<String, Conversation> _conversations = {};

  final usersCollection = FirebaseFirestore.instance.collection("users");
  final postsCollection = FirebaseFirestore.instance.collection("posts");
  final conversationCollection =
      FirebaseFirestore.instance.collection("conversations");
  final userConversationCollection =
      FirebaseFirestore.instance.collection("user_conversations");
  final messagesCollection = FirebaseFirestore.instance.collection("messages");

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();
  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();
  final StreamController<List<Conversation>> _conversationsController =
      StreamController<List<Conversation>>();
  final StreamController<List<Conversation>> _userConversationsController =
      StreamController<List<Conversation>>();
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>();

  Stream<Map<String, User>> get users => _usersController.stream;
  Stream<List<Post>> get posts => _postsController.stream;
  Stream<List<Conversation>> get userConvos =>
      _userConversationsController.stream;
  Stream<List<Message>> get messages => _messagesController.stream;

  FirestoreService() {
    usersCollection.snapshots().listen(_usersUpdated);
    postsCollection.snapshots().listen(_postsUpdated);
    messagesCollection.snapshots().listen(_messagesUpdated);
    conversationCollection.snapshots().listen(_conversationUpdated);
  }

  void setUserConvoserations(String userId) {
    userConversationCollection
        .doc(userId)
        .snapshots()
        .listen(_userConvosUpdated);
  }

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    Map<String, User> users = _getUserFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = _getPostsFromSnapshot(snapshot);
    _postsController.add(posts);
  }

  void _messagesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = []; // _getMessagesFromSnapshot(snapshot)
    _messagesController.add(messages);
  }

  void _conversationUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    _getConversationsFromSnapshot(snapshot);
  }

  void _userConvosUpdated(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> userConvo = _getUserConvosFromSnapshot(snapshot);
    _userConversationsController.add(userConvo);
  }

  Map<String, User> _getUserFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var doc in snapshot.docs) {
      User user = User.fromJson(doc.id, doc.data());
      userMap[user.id] = user;
    }

    return userMap;
  }

  List<Post> _getPostsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = [];
    for (var doc in snapshot.docs) {
      Post post = Post.fromJson(doc.id, doc.data());
      posts.add(post);
      postMap[post.id] = post;
    }
    return posts;
  }

  void _getConversationsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var doc in snapshot.docs) {
      Conversation convo = Conversation.fromJson(doc.id, doc.data());
      _conversations[convo.id] = convo;
    }
  }

  List<Conversation> _getUserConvosFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = [];

    return conversations;
  }

  Future<bool> addUser(String userId, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(userId).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPost(Map<String, dynamic> data) async {
    data["createdAt"] = Timestamp.now();
    try {
      await postsCollection.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addConversation(List<String> users) async {
    users.add(_auth.currentUser!.uid);
    var data = {"users": users, "create_at": Timestamp.now()};
    try {
      var result = await conversationCollection.add(data);
      for (var user in users) {
        userConversationCollection
            .doc(user)
            .set({result.id: 1}, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
