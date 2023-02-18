import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/backend/firestore_methods.dart';
import 'package:instagram/widgets/color.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({required this.snap, super.key});

  @override
  State<CommentScreen> createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TextStyle(fontSize: 22, color: primaryColor),
        ),
        centerTitle: false,
        backgroundColor: background,
        actions: [IconButton(onPressed: (() {}), icon: Icon(Icons.send))],
      ),
      backgroundColor: background,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .doc(widget.snap['postid'])
            .collection('Comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) =>
                  CommentCard(snap: snapshot.data?.docs[index].data())));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          color: Colors.grey[900],
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 6,
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(user.photourl)),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment',
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().AddComment(
                      user.uid,
                      user.photourl,
                      user.username,
                      commentController.text,
                      widget.snap['postid']);

                  setState(() {
                    commentController.clear();
                  });
                },
                child: const Text('Post', style: TextStyle(color: Colors.blue)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
