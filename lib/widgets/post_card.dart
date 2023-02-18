import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/backend/firestore_methods.dart';
import 'package:instagram/screens/comments_screen.dart';
import 'package:instagram/widgets/image_picker.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'color.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentlen();
  }

  void getCommentlen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Post')
          .doc(widget.snap['postid'])
          .collection('Comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // this is main container of a post card feed
    setState(() {
      isLoading = true;
    });
    // final User user = Provider.of<UserProvider>(context).getUser;
    var Useruid = FirebaseAuth.instance.currentUser?.uid;
    setState(() {
      isLoading = false;
    });
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child:
                // scroll view for making post scrollable
                Column(
              children: [
                // here is only divider
                Divider(
                  color: secondaryColor,
                  // thickness: 3,
                ),
                // This is first row it consists Profile photo , username , at last more icon
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.snap['profilePhoto'],
                      ),
                      radius: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.snap['username'],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                      titlePadding: EdgeInsets.all(8),
                                      elevation: 5,
                                      title: InkWell(
                                          onTap: () async {
                                            await FirestoreMethods().deletePost(
                                                widget.snap['postid']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete Post')),
                                    ));
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    )
                  ],
                ),
                // Now we have our post here
                GestureDetector(
                  onDoubleTap: () async {
                    FirestoreMethods().LikePost(
                        widget.snap['postid'], Useruid!, widget.snap['likes']);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    Image.network(
                      widget.snap['posturl'],
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .58,
                      fit: BoxFit.cover,
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 400),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 120,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    )
                  ]),
                ),

                // This is our 2 row in this we have icon of Like, Comment , Share and at last Bookmark
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(Useruid!),
                      smallLike: true,
                      child: IconButton(
                          onPressed: (() async {
                            await FirestoreMethods().LikePost(
                                widget.snap['postid'],
                                Useruid,
                                widget.snap['likes']);
                          }),
                          icon: widget.snap['likes'].contains(Useruid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border)),
                    ),
                    IconButton(
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      CommentScreen(snap: widget.snap))));
                        }),
                        icon: const FaIcon(FontAwesomeIcons.comment)),
                    IconButton(
                        onPressed: (() {}), icon: const Icon(Icons.send)),
                    // const SizedBox(
                    //   width: 140,
                    // ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            onPressed: (() {}),
                            icon: const FaIcon(FontAwesomeIcons.bookmark)),
                      ),
                    )
                  ],
                ),

                // This is 3 row consist of Likes
                Row(
                  children: [
                    Text(
                      "${widget.snap['likes'].length} Likes",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),

                // This is 4 row consist of Username and Description[caption]
                Row(
                  children: [
                    Text(
                      widget.snap['username'],
                      // 'username',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.snap['description'],
                      // 'des',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),

                // Here is inkwell of How many comments
                InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'View all $commentLen comments',
                      style: TextStyle(color: secondaryColor, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                // This is 5 and last row of a single post showing the date posted.
                Row(
                  children: [
                    Text(DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()))
                  ],
                ),
                // Here our first post items end.
              ],
            ));
  }
}
