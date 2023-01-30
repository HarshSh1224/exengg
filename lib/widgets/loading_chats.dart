import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoadingChats extends StatelessWidget {
  final count;
  const LoadingChats(this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Your Chats',
              style: TextStyle(
                  fontFamily: 'MoonBold',
                  fontSize: 12,
                  letterSpacing: 1.1,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  leading: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Shimmer(
                        color: Theme.of(context).colorScheme.background,
                        child: Container(),
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    // backgroundImage: Image.network(snapshot
                    //         .data![index]
                    //         .data()!['imageUrl'])
                    //     .image
                  ),
                  title: Container(
                    child: Shimmer(
                      color: Theme.of(context).colorScheme.background,
                      child: Container(),
                    ),
                    margin: EdgeInsets.only(bottom: 4, right: 80),
                    height: 17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    // width: 50,
                  ),
                  subtitle: Container(
                    child: Shimmer(
                      color: Theme.of(context).colorScheme.background,
                      child: Container(),
                    ),
                    margin: EdgeInsets.only(bottom: 4, right: 150),
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
