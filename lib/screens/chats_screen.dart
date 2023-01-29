import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exengg/screens/auth_screen.dart';
import 'package:exengg/screens/messages_screen.dart';
import 'package:exengg/widgets/side_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  var curr = FirebaseAuth.instance.currentUser?.uid;
  static const routeName = '/chats-screen';
  final scaffoldKey;
  ChatsScreen([this.scaffoldKey]);
  List<String> _recentMessages = [];

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> fetchData() async {
    List<DocumentSnapshot<Map<String, dynamic>>> peopleData = [];
    final response =
        await FirebaseFirestore.instance.collection('users/$curr/chats').get();
    print('users/$curr/chats');
    _recentMessages =
        List<String>.generate(response.docs.length, (i) => i.toString());
    ;
    int i = 0;
    for (var element in response.docs) {
      final personData = await FirebaseFirestore.instance
          .collection('users')
          .doc(element.id)
          .get();
      peopleData.add(personData);
      final _mostRecentMessage = await FirebaseFirestore.instance
          .collection('users/$curr/chats/${element.id}/messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      // print('MOST RECENT MESSAGE');
      print(_mostRecentMessage.docs[0]['text'] + i.toString());
      _recentMessages[i] = (_mostRecentMessage.docs.length != 0
          ? _mostRecentMessage.docs[0]['text']
          : '');
      i++;
    }
    print(_recentMessages);
    ;
    return peopleData;
  }

  var _scaffoldKey2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          curr = FirebaseAuth.instance.currentUser?.uid;
          print('BUILDING CHATS SCREEN');
          return !snapshot.hasData
              ? Scaffold(body: AuthScreen())
              : Scaffold(
                  // drawer: scaffoldKey == null ? null  Drawer(
                  //   child: SideDrawer(),
                  //   backgroundColor: Colors.transparent,
                  // ),
                  key: _scaffoldKey2,
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text('Chats'),
                    leading: scaffoldKey == null
                        ? null
                        : IconButton(
                            icon: Icon(Icons.menu,
                                size: 35), // change this size and style
                            onPressed: () {
                              if (scaffoldKey != null)
                                scaffoldKey!.currentState?.openDrawer();
                            },
                            // onPressed: () {},
                          ),
                  ),
                  body: FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        print(_recentMessages);
                        return !snapshot.hasData
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (snapshot.data!.length != 0)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'Your Chats',
                                          style: TextStyle(
                                              fontFamily: 'MoonBold',
                                              fontSize: 12,
                                              letterSpacing: 1.1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: snapshot.data!.length == 0
                                          ? Center(
                                              child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.sailing_outlined,
                                                  size: 50,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'No Chats Found!',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                                ),
                                              ],
                                            ))
                                          : ListView.builder(
                                              // itemCount: 2,
                                              itemCount: snapshot.hasData
                                                  ? snapshot.data!.length
                                                  : 0,
                                              itemBuilder: (context, index) {
                                                // return Text(snapshot.data!.length.toString());
                                                return ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  onTap: (() {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                MessagesScreen(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                                    curr)));
                                                  }),
                                                  leading: CircleAvatar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurfaceVariant,
                                                      backgroundImage:
                                                          Image.network(snapshot
                                                                      .data![index]
                                                                      .data()![
                                                                  'imageUrl'])
                                                              .image),
                                                  title: Text(
                                                    snapshot.data![index]
                                                        .data()!['name'],
                                                    // style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    _recentMessages[index],
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                );
                                              }),
                                    ),
                                  ],
                                ),
                              );
                      }),
                );
        });
  }
}
