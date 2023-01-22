import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exengg/widgets/report_dialog.dart';
import 'package:exengg/widgets/send_message_field.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final personId, curr;
  MessagesScreen(this.personId, this.curr);

  final _controller = TextEditingController();
  var person;

  Future<void> fetchPersonData() async {
    person = await FirebaseFirestore.instance
        .collection('users')
        .doc(personId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPersonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onSelected: (value) {
                      if (value == 'Report') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ReportDialog(personId, curr);
                          },
                        );
                      }
                    },
                    itemBuilder: (_) {
                      return [
                        PopupMenuItem(
                            value: 'Report',
                            child: Row(
                              children: [
                                Icon(Icons.flag),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Report   '),
                              ],
                            ))
                      ];
                    })
              ],
              centerTitle: true,
              title: Transform.translate(
                offset: Offset(-10, 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundImage: Image.network(person['imageUrl']).image,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      person['name'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users/$curr/chats/${person.id}/messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: snapshot.data!.docs[index]
                                          ['creatorId'] ==
                                      curr
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Card(
                                    color: snapshot.data!.docs[index]
                                                ['creatorId'] !=
                                            curr
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                        : null,
                                    elevation: 2,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 3),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (2 / 3))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 12),
                                      child: Text(
                                          snapshot.data!.docs[index]['text']),
                                    )),
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SendMessageField(person.id, curr),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
