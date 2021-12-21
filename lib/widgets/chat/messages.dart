import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chat").orderBy("sentAt", descending: true).snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          final userId = FirebaseAuth.instance.currentUser!.uid;
          return ListView.builder(
            itemBuilder: (ctx, ind) => MessageBubble(
              message: chatDocs[ind]['text'],
              userImageurl: chatDocs[ind]['userImage'],
              isMe: chatDocs[ind]['userId']==userId,
              key: ValueKey(chatDocs[ind].id),
              username: chatDocs[ind]['username'],
            ),
            reverse: true,
            itemCount: chatSnapshot.data!.docs.length,
          );
        });
  }
}
