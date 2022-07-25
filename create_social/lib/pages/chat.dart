import 'package:create_social/models/conversation.dart';
import 'package:create_social/models/message.dart';
import 'package:create_social/services/firestore_service.dart';
import 'package:create_social/style/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

                  return SizedBox(
                      width: screenWidth(context),
                      child: Container(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: me
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: me ? Colors.green : Colors.blue,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30.0))),
                                clipBehavior: Clip.hardEdge,
                                margin: EdgeInsets.only(
                                    top: 10.0,
                                    right:
                                        me ? 5.0 : screenWidth(context) * 0.3,
                                    left:
                                        me ? screenWidth(context) * 0.3 : 5.0),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: me
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            FirestoreService
                                                .userMap[
                                                    messages[index].fromId]!
                                                .name,
                                            textAlign: me
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            messages[index].content,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            textAlign: me
                                                ? TextAlign.right
                                                : TextAlign.left,
                                          )
                                        ]))),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  DateFormat('M/dd/yyyy h:mm a').format(
                                      messages[index].createdAt.toDate()),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                  textAlign:
                                      me ? TextAlign.right : TextAlign.left,
                                ))
                          ])));
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
