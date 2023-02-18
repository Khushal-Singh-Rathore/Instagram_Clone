import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/backend/auth_methods.dart';
import 'package:instagram/backend/firestore_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/widgets/color.dart';
import 'package:instagram/widgets/follow_button.dart';
import 'package:instagram/widgets/image_picker.dart';

class ownProfileScreen extends StatefulWidget {
  final String uid;
  const ownProfileScreen({required this.uid, super.key});

  @override
  State<ownProfileScreen> createState() => ownProfileScreenState();
}

class ownProfileScreenState extends State<ownProfileScreen> {
  var userData = {};
  var postLen;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      var Usersnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var Postsnap = await FirebaseFirestore.instance
          .collection('Post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = Postsnap.docs.length;
      followers = Usersnap.data()!['followers'].length;
      following = Usersnap.data()!['following'].length;
      userData = Usersnap.data()!;
      isFollowing = Usersnap.data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
              backgroundColor: background,
              actions: const [Icon(Icons.more_horiz)],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            userData['photourl'],
                          ),
                          radius: 40,
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        columnPFF(postLen, 'Posts'),
                        const SizedBox(
                          width: 20,
                        ),
                        columnPFF(followers, 'Followers'),
                        const SizedBox(
                          width: 20,
                        ),
                        columnPFF(following, 'Following'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['fullname'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(userData['bio']),
                  const SizedBox(
                    height: 5,
                  ),
                  // Edit Profile
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? FollowButton(
                          text: 'Sign Out',
                          backgroundColor: Color.fromARGB(255, 41, 41, 41),
                          borderColor: secondaryColor,
                          textColor: Colors.white,
                          function: (() async {
                            await AuthMethods().signOut();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const LoginScreen())));
                          }),
                        )
                      : isFollowing
                          ? FollowButton(
                              text: 'Unfollow',
                              backgroundColor:
                                  const Color.fromARGB(255, 134, 132, 132),
                              borderColor:
                                  const Color.fromARGB(255, 74, 73, 73),
                              textColor: Colors.white,
                              function: (() async {
                                FirestoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userData['uid']);
                                setState(() {
                                  followers--;
                                  isFollowing = false;
                                });
                              }),
                            )
                          : FollowButton(
                              text: 'Follow',
                              backgroundColor: Colors.blue,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              function: (() {
                                FirestoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userData['uid']);
                                setState(() {
                                  followers++;
                                  isFollowing = true;
                                });
                              }),
                            ),
                  Divider(
                    color: secondaryColor,
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Post')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 2),
                            itemBuilder: ((context, index) {
                              var snap = snapshot.data!.docs[index];
                              return Container(
                                child: Image(
                                  image: NetworkImage(
                                    snap['posturl'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }));
                      })
                ],
              ),
            ),
          );
  }

  Column columnPFF(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(label),
      ],
    );
  }
}
