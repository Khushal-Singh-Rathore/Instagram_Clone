import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/widgets/color.dart';
import 'package:instagram/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: background,
          title: Image.asset(
            'assets/Instagram_logo.svg.png',
            color: primaryColor,
            height: 35,
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: (() {}),
                icon: Icon(
                  Icons.messenger_rounded,
                  color: primaryColor,
                )),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Post')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: snapshot.data!.docs[index].data()));
          },
        ));
  }
}
