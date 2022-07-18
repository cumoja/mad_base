import 'package:create_social/models/conversation.dart';
import 'package:create_social/models/message.dart';
import 'package:create_social/services/firestore_service.dart';
import 'package:create_social/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.conversation, required this.name})
      : super(key: key);
  final String name;
  final Conversation conversation;
  final FirestoreService _fs = FirestoreService();
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: RatingBar.builder(
          itemCount: 5,
          allowHalfRating: true,
          initialRating: 4.5,
          onRatingUpdate: (value) {},
          itemBuilder: (BuildContext context, int index) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Text(name),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "CLOSE",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [_messagingArea(context), _inputArea(context)],
      )),
    );
  }

  Widget _messagingArea(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.blueGrey,
      width: screenWidth(context),
      child: StreamBuilder<List<Message>>(
        stream: _fs.messages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messages = [];
            for (var message in snapshot.data!) {
              if (message.convoId == conversation.id) {
                messages.add(message);
              }
            }
            return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool me = messages[index].fromId == _fs.getUserId();
                  return Container(
                      color: me ? Colors.deepOrange : Colors.tealAccent,
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            messages[index].content,
                            textAlign: me ? TextAlign.right : TextAlign.left,
                          )));
                });
          } else {
            return const Center(
              child: Text("No messages have loaded"),
            );
          }
        },
      ),
    ));
  }

  Widget _inputArea(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      width: screenWidth(context),
      child: Row(children: [
        const SizedBox(width: 20),
        Expanded(
            child: TextField(controller: _message, minLines: 1, maxLines: 3)),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ]),
    );
  }

  void sendMessage() {
    if (_message.text.isNotEmpty) {
      _fs.addMessage(_message.text, conversation);
      _message.clear();
    }
  }
}
