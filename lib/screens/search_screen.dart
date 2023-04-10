import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var disPlayList;
  String name = '';
  bool hasRunned = false;
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void getListOfUsers(String value) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchController.text)
        .get();
    // ignore: iterable_contains_unrelated_type
    disPlayList = snapshot.docChanges.length;
    print(disPlayList);
  }

  @override
  Widget build(BuildContext context) {
    print('Build Called');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBacgroundColor,
        title: TextFormField(
          controller: searchController,
          // onChanged: (value) {
          //   // getListOfUsers(value);
          //   setState(() {
          //     isShowUser = true;
          //   });
          // },
          decoration: const InputDecoration(labelText: 'Search for a user....'),
          onFieldSubmitted: (value) => setState(() {
            isShowUser = true;
          }),
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  uid: snapshot.data!.docs[index]['uid']),
                            ),
                          ),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl']),
                              ),
                              title: Text(
                                snapshot.data!.docs[index]['username'],
                              )),
                        ));
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                        index % 7 == 0 ? 2 : 1, index % 7 == 0 ? 2 : 1),
                    crossAxisCount: 3,
                    itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['photoUrl']),
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }),
    );
  }
}
