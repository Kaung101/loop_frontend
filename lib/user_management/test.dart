import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpcycledItemsList extends StatefulWidget {
  @override
  _UpcycledItemsListState createState() => _UpcycledItemsListState();
}

class _UpcycledItemsListState extends State<UpcycledItemsList> {
  late Future<List<UpcycledItem>> _upcycledItems;

  @override
  void initState() {
    super.initState();
    _upcycledItems = fetchUpcycledItems();
  }

  Future<List<UpcycledItem>> fetchUpcycledItems() async {
    final response = await http.get(Uri.parse('https://example.com/api/upcycled-items'));

    if (response.statusCode == 200) {
      List<UpcycledItem> upcycledItems = (jsonDecode(response.body) as List)
         .map((item) => UpcycledItem.fromJson(item))
         .toList();
      return upcycledItems;
    } else {
      throw Exception('Failed to load upcycled items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UpcycledItem>>(
      future: _upcycledItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return snapshot.data![index];
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class UpcycledItem extends StatelessWidget {
  final String username;
  final String status;
  final String productName;
  final String estimatePrice;
  final String description;
  final String beforeImageUrl;
  final String afterImageUrl;

  UpcycledItem({
    required this.username,
    required this.status,
    required this.productName,
    required this.estimatePrice,
    required this.description,
    required this.beforeImageUrl,
    required this.afterImageUrl,
  });

  factory UpcycledItem.fromJson(Map<String, dynamic> json) {
    return UpcycledItem(
      username: json['username'],
      status: json['status'],
      productName: json['productName'],
      estimatePrice: json['estimatePrice'],
      description: json['description'],
      beforeImageUrl: json['beforeImageUrl'],
      afterImageUrl: json['afterImageUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.chat_bubble_outline),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Image.network(
                  beforeImageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Image.network(
                  afterImageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Product Name: $productName',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Estimate Price: $estimatePrice',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Description: $description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}