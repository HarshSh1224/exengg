import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exengg/screens/add_item_screen.dart';
import 'package:exengg/screens/messages_screen.dart';
import 'package:exengg/screens/my_products_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../providers/auth.dart';
import '../providers/products.dart';

class ProductItem extends StatefulWidget {
  final Product productItem;
  bool comingFromMyProducts;
  final Function() _toggleTheme;
  ProductItem(this.productItem, this._toggleTheme,
      [this.comingFromMyProducts = false]);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String? imageUrl = null, name = null;
  int? daysBack;

  @override
  void initState() {
    daysBack = DateTime.now().difference(widget.productItem.createDate).inDays;
    super.initState();
    _userProfileImageUrlGetter();
  }

  Future<void> _removeItem(
    String id,
  ) async {
    try {
      print('TRYING DELETE');
      await FirebaseFirestore.instance
          .collection('/products/Mf68xktMsq1nObDvCb2F/products')
          .doc(id)
          .delete();
      final ref =
          await FirebaseStorage.instance.ref().child('productImages').child(id);
      await ref.delete();
      print('DELETE SUCCESS!');
      Navigator.of(context).pushReplacementNamed(MyProductsScreen.routeName);
    } catch (error) {
      print('DELETE FAILED!');
      throw error;
    }
  }

  void _userProfileImageUrlGetter() async {
    final img = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.productItem.creatorId)
        .get();
    setState(() {
      imageUrl = img.data()!['imageUrl'];
      name = img.data()!['name'];
      print(imageUrl! + name!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('REBUILDING PRODUCT ITEM');
    // _userProfileImageUrlGetter();
    return Container(
      // height: 430,
      constraints: BoxConstraints(minHeight: 500),
      width: double.infinity,
      child: Card(
        elevation: 6,
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                leading: CircleAvatar(
                  backgroundImage:
                      imageUrl == null ? null : Image.network(imageUrl!).image,
                  child: imageUrl == null ? Text('...') : Text(''),
                  backgroundColor: imageUrl == null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                title: Text(name == null ? 'Loading' : name!),
                subtitle: daysBack! > 16
                    ? Text(DateFormat('dd MMM')
                        .format(widget.productItem.createDate))
                    : Text(daysBack == 0
                        ? 'Today'
                        : daysBack == 1
                            ? 'Yesterday'
                            : '$daysBack Days ago'),
                // subtitle: Text(DateFormat('dd MMM')
                //     .format(widget.productItem.createDate)),
                trailing: widget.comingFromMyProducts
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AddItemScreen.routeName, arguments: {
                            'toggle': widget._toggleTheme,
                            'update': widget.productItem,
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                        ),
                      )
                    : Consumer<Product>(
                        builder: ((context, prod, child) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                print('TOGGLE FAV');
                                prod.toggleFavourite();
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    prod.isFavourite
                                        ? 'Added to favourites'
                                        : 'Removed from favourites',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )));
                              });
                            },
                            icon: prod.isFavourite
                                ? Icon(
                                    Icons.favorite,
                                    color: Theme.of(context).colorScheme.error,
                                  )
                                : Icon(
                                    Icons.favorite_outline,
                                  ),
                          );
                        }),
                      ),
                // subtitle: Text(),
              ),
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (ctx) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: InteractiveViewer(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 200),
                              width: double.infinity,
                              child:
                                  Image.network(widget.productItem.imageUrl)),
                        ),
                      );
                    }),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    widget.productItem.imageUrl,
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return frame == null
                          ? Shimmer(
                              color: Theme.of(context).colorScheme.background,
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                              ),
                            )
                          : child;
                    },
                  ),
                  // child: FadeInImage.assetNetwork(
                  //   placeholder: 'assets/images/circular_progress.gif',
                  //   image: widget.productItem.imageUrl,
                  //   fit: BoxFit.cover,
                  // ),
                  // color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 10),
                      minVerticalPadding: 0,
                      title: Text(
                        // 'Tweoxniowecioncuiubcionceiorbklr ekc ec rejkcbeckereio',
                        widget.productItem.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      trailing: widget.productItem.price == -1
                          ? Chip(
                              elevation: 2,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              shadowColor: Theme.of(context).colorScheme.shadow,
                              label: Text('Exchange'),
                              avatar: Icon(Icons.handshake),
                            )
                          : Text(
                              '₹ ${widget.productItem.price.toString()}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                            ),
                    ),
                    Text(
                      // 'clwkncklwencweilncwelcnwioenc wec wec w ecwe cwe dwec wce wec weeknwelkn cweklcnwec klwncwec klncwec ,,w cenklwcklwnc kljdcslnskldn klsnd klsdnklj klsn klsdj klsdj klsdd klsdn sdkln klsn kls nskln ns bs sahjsjabsxjkasbxkjabsxbkncklb weklnwcelkbnwe wcelkncwklc wklncwec qklncqklc ',
                      widget.productItem.description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              )
            ]),
            Positioned(
              bottom: 20.0,
              right: 15.0,
              child: widget.comingFromMyProducts
                  ? OutlinedButton(
                      onPressed: () {
                        print('SHOWING DIALOG');
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                    'Do you want to remove this item. This action cannot be reversed.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        print('YOU TAPPED NO');
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No')),
                                  TextButton(
                                      onPressed: () {
                                        print('YOU TAPPED YES');
                                        try {
                                          _removeItem(widget.productItem.id);
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text('An Error Occurred'),
                                          )));
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes')),
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Remove Item',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 20),
                        child: Text(
                          'Chat',
                          style: TextStyle(fontFamily: 'MoonBold'),
                        ),
                      ),
                      onPressed: Provider.of<Auth>(context, listen: false)
                              .isAuth
                          ? widget.productItem.creatorId ==
                                  Provider.of<Auth>(context, listen: false)
                                      .getUserId
                              ? null
                              : () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => MessagesScreen(
                                          widget.productItem.creatorId,
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .getUserId)));
                                }
                          : () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        title: Text(
                                          'Error',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        content: Text(
                                          'You must be logged in to continue to chat',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('Okay'))
                                        ],
                                      ));
                              return;
                            }
                      // onPressed: () {
                      //   final auth =
                      //       Provider.of<Auth>(context, listen: false).isAuth;
                      //   showDialog(
                      //       context: context,
                      //       builder: (_) {
                      //         return auth
                      //             ? AlertDialog(
                      //                 backgroundColor: Theme.of(context)
                      //                     .colorScheme
                      //                     .surfaceVariant,
                      //                 // insetPadding: EdgeInsets.all(10),
                      //                 title: Text(
                      //                   'Contact Number',
                      //                   style: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .onSecondaryContainer,
                      //                     fontFamily: 'Roboto',
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 20,
                      //                   ),
                      //                 ),
                      //                 content: Container(
                      //                   width: 400,
                      //                   // color: Colors.red,
                      //                   child: ListTile(
                      //                     leading: Icon(
                      //                       Icons.phone,
                      //                       color: Theme.of(context)
                      //                           .colorScheme
                      //                           .onPrimaryContainer,
                      //                     ),
                      //                     title: FittedBox(
                      //                         child: Text(
                      //                       widget.productItem.phoneNumber,
                      //                       style: TextStyle(
                      //                           color: Theme.of(context)
                      //                               .colorScheme
                      //                               .onPrimaryContainer),
                      //                     )),
                      //                     trailing: IconButton(
                      //                       icon: Icon(Icons.copy,
                      //                           color: Theme.of(context)
                      //                               .colorScheme
                      //                               .onPrimaryContainer),
                      //                       onPressed: () async {
                      //                         await Clipboard.setData(
                      //                             ClipboardData(
                      //                                 text: widget.productItem
                      //                                     .phoneNumber));
                      //                         Navigator.of(context).pop();
                      //                         ScaffoldMessenger.of(context)
                      //                             .removeCurrentSnackBar();
                      //                         ScaffoldMessenger.of(context)
                      //                             .showSnackBar(SnackBar(
                      //                                 content: Padding(
                      //                           padding:
                      //                               const EdgeInsets.all(8.0),
                      //                           child: Text('Copied!'),
                      //                         )));
                      //                         // copied successfully
                      //                       },
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 actions: [
                      //                   TextButton(
                      //                       onPressed: () =>
                      //                           Navigator.of(context).pop(),
                      //                       child: Text('Okay'))
                      //                 ],
                      //               )
                      //             : AlertDialog(
                      //                 backgroundColor: Theme.of(context)
                      //                     .colorScheme
                      //                     .surfaceVariant,
                      //                 title: Text(
                      //                   'Error',
                      //                   style: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .onSecondaryContainer,
                      //                     fontFamily: 'Roboto',
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 20,
                      //                   ),
                      //                 ),
                      //                 content: Text(
                      //                   'You must be logged in to view this information.',
                      //                   style: TextStyle(
                      //                       color: Theme.of(context)
                      //                           .colorScheme
                      //                           .onPrimaryContainer),
                      //                 ),
                      //                 actions: [
                      //                   TextButton(
                      //                       onPressed: () =>
                      //                           Navigator.of(context).pop(),
                      //                       child: Text('Okay'))
                      //                 ],
                      //               );
                      //       });
                      // },
                      ),
              // child: ListTile(
              //   trailing: ElevatedButton(
              //     onPressed: () {},
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text('Get Contact'),
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
