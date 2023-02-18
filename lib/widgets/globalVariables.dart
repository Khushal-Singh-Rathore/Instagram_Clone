import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/ownProfile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

import '../screens/profile_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const addPostScreen(),
  const Text('Activity'),
  ownProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
