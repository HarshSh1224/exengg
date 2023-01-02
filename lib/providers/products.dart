import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String phoneNumber;
  final String imageUrl;
  final double price;
  final String creatorId;
  final String creatorIP;
  final DateTime createDate;
  bool isFavourite;
  final String categoryId;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.imageUrl,
    required this.createDate,
    required this.creatorId,
    required this.creatorIP,
    required this.price,
    required this.categoryId,
    this.isFavourite = false,
  });

  void toggleFavourite() async {
    isFavourite = !isFavourite;
    Map<String, bool> favData = {};
    Map<String, bool> existingFavData = {};
    final getStorage = await GetStorage();

    getStorage.writeIfNull('favData', 'value');
    if (getStorage.read('favData') != 'value') {
      existingFavData =
          Map<String, bool>.from(json.decode(getStorage.read('favData')));
      print('FOUND INSTANCE');
      print(existingFavData);
      getStorage.remove('favData');
    } else {
      print('NOT FOUND INSTANCE');
    }

    existingFavData.forEach((key, value) {
      favData[key] = value;
    });

    favData[id] = isFavourite;

    favData.removeWhere((key, value) => value == false);

    final favDataJson = json.encode(favData);
    getStorage.write('favData', favDataJson);
    print('Written Instance');
    print(favData);
    // notifyListeners();
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     categoryId: 'd1',
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //     phoneNumber: '9717829012',
    //     createDate: DateTime.now(),
    //     creatorId: 'creatorId'),
    // Product(
    //     categoryId: 'd1',
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     phoneNumber: '9717829012',
    //     createDate: DateTime.now(),
    //     creatorId: 'creatorId'),
    // Product(
    //     categoryId: 'd1',
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     phoneNumber: '9717829012',
    //     createDate: DateTime.now(),
    //     creatorId: 'creatorId'),
    // Product(
    //     categoryId: 'd1',
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     phoneNumber: '9717829012',
    //     createDate: DateTime.now(),
    //     creatorId: 'creatorId'),
    // Product(
    //     categoryId: 'd2',
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //     phoneNumber: '9717829012',
    //     createDate: DateTime.now(),
    //     creatorId: 'creatorId'),
    // Product(
    //     categoryId: 'd2',
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //     phoneNumber: '9717829012',
    //     createDate: DateTime.now(),
    //     creatorId: 'creatorId'),
  ];

  List<Product> get items {
    return [..._items];
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> readFeeds(
  //     String creatorId) async {
  //   print('YOUR CREATOR ID IS $creatorId');
  //   QuerySnapshot<Map<String, dynamic>> serverData = await FirebaseFirestore
  //       .instance
  //       .collection('/products/Mf68xktMsq1nObDvCb2F/products')
  //       .where("author", isEqualTo: creatorId)
  //       .get();
  //   return serverData;
  // }

  // Future<void> fetchAndSetDataWhereCreatorId(String creatorId) async {
  //   final serverData = await FirebaseFirestore.instance
  //       .collection('/products/Mf68xktMsq1nObDvCb2F/products')
  //       // .where("author", isEqualTo: creatorId)
  //       .get();
  //   print(serverData.docs.length);
  //   // final serverData = await readFeeds(creatorId);
  //   print('SRVER' + serverData.docs.length.toString());

  //   print(_items);
  //   List<Product> loadedProduct = [];
  //   serverData.docs.forEach((prod) {
  //     loadedProduct.add(
  //       Product(
  //         categoryId: prod.data()['categoryId'],
  //         id: prod.id,
  //         title: prod.data()['title'],
  //         description: prod.data()['description'],
  //         price: prod.data()['price'],
  //         imageUrl: prod.data()['imageUrl'],
  //         phoneNumber: prod.data()['phone'],
  //         createDate: DateTime.parse(prod.data()['createDate']),
  //         creatorIP: prod.data()['creatorIP'],
  //         creatorId: prod.data()['creatorId'],
  //       ),
  //     );
  //   });

  //   print(loadedProduct);

  //   _items = loadedProduct;

  //   print(_items);
  //   notifyListeners();
  // }

  Future<void> fetchAndSetData() async {
    final serverData = await FirebaseFirestore.instance
        .collection('/products/Mf68xktMsq1nObDvCb2F/products/')
        .get();
    // print(serverData.docs.length);
    print(serverData.docs[0].id);

    // print(_items);
    Map<String, bool> existingFavData;
    final getStorage = await GetStorage();
    getStorage.writeIfNull('favData', 'value');
    if (getStorage.read('favData') != 'value') {
      existingFavData =
          Map<String, bool>.from(json.decode(getStorage.read('favData')));
      print('FOUND FAV INSTANCE');
      print(existingFavData);
    } else {
      existingFavData = {};
      print('NOT FOUND FAV INSTANCE');
    }

    List<Product> loadedProduct = [];
    serverData.docs.forEach((prod) {
      bool tempFavStatus = false;
      if (!existingFavData.isEmpty && existingFavData.containsKey(prod.id)) {
        tempFavStatus = existingFavData[prod.id]!;
      }
      loadedProduct.add(
        Product(
          categoryId: prod.data()['categoryId'],
          id: prod.id,
          title: prod.data()['title'],
          description: prod.data()['description'],
          price: prod.data()['price'],
          imageUrl: prod.data()['imageUrl'],
          phoneNumber: prod.data()['phone'],
          createDate: DateTime.parse(prod.data()['createDate']),
          creatorIP: prod.data()['creatorIP'],
          creatorId: prod.data()['creatorId'],
          isFavourite: tempFavStatus,
        ),
      );
    });

    print(loadedProduct);

    _items = loadedProduct;

    // serverData.docs.map((prod) {
    //   _items.add(
    //     Product(
    //       categoryId: prod.data()['categoryId'],
    //       id: prod.id,
    //       title: prod.data()['title'],
    //       description: prod.data()['description'],
    //       price: prod.data()['price'],
    //       imageUrl: prod.data()['imageUrl'],
    //       phoneNumber: prod.data()['phone'],
    //       createDate: DateTime.parse(prod.data()['createDate']),
    //       creatorId: prod.data()['creatorId'],
    //     ),
    //   );
    // });
    print(_items);
    notifyListeners();
  }
}
