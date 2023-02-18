import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/backend/firestore_methods.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/widgets/color.dart';
import 'package:instagram/widgets/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class addPostScreen extends StatefulWidget {
  const addPostScreen({super.key});

  @override
  State<addPostScreen> createState() => addPostScreenState();
}

class addPostScreenState extends State<addPostScreen> {
  Uint8List? _file;
  TextEditingController userDescription = TextEditingController();

  bool isLoading = false;
  void postImage(String uid, String username, String profilePhoto) async {
    String res = 'some error occurd';
    try {
      setState(() {
        isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          userDescription.text, _file!, true, profilePhoto, uid, username);
      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      res = e.toString();
      showSnackBar(res, context);
    }
  }

  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            title: Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);

                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.pop(context);

                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  @override
  void dispose() {
    super.dispose();
    userDescription.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? IconButton(
            onPressed: (() {
              selectImage(context);
            }),
            icon: Icon(
              Icons.upload,
              color: Colors.blue,
              size: 70,
            ))
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => clearImage(),
                  icon: const Icon(Icons.arrow_back)),
              centerTitle: false,
              title: const Text('New Post'),
              actions: [
                IconButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photourl),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.blue,
                    ))
              ],
              backgroundColor: background,
            ),
            body: Column(
              children: [
                // const SizedBox(
                //   height: 8,
                // ),
                isLoading
                    ? const LinearProgressIndicator(
                        color: Colors.blue,
                      )
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photourl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            controller: userDescription,
                            decoration: InputDecoration(
                                hintText: 'Write a caption...',
                                border: InputBorder.none),
                            maxLines: 8,
                          )),
                      const SizedBox(
                        width: 60,
                      ),
                      Image(
                        image: MemoryImage(
                          _file!,
                        ),
                        width: 60,
                        height: 60,
                        alignment: Alignment.bottomLeft,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
