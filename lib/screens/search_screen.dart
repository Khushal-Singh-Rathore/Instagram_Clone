import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/widgets/color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearchon = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: SafeArea(
          child: TextFormField(
            controller: searchController,
            onFieldSubmitted: ((v) {
              setState(() {
                isSearchon = true;
              });
            }),
            decoration: const InputDecoration(
              labelText: 'Search for User',
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('user')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          return isSearchon
              ? ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ProfileScreen(
                                    uid: snapshot.data?.docs[index]['uid']))));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data?.docs[index]['photourl']),
                        ),
                        title: Text(snapshot.data?.docs[index]['username']),
                      ),
                    );
                  })
              : FutureBuilder(
                  future: FirebaseFirestore.instance.collection('Post').get(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: ((context, index) =>
                          Image.network(snapshot.data?.docs[index]['posturl'])),
                      staggeredTileBuilder: ((index) => StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1)),
                      // mainAxisSpacing: 6,
                      // crossAxisSpacing: 6,
                    );
                  }));
        },
      ),
    );
  }
}
