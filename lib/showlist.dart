import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loop/components/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: Container(
          margin:const EdgeInsets.only(top: 5.0),
          child:TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundColor),
                    elevation: MaterialStateProperty.all<double>(0.0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: (){},
                  child: const Icon(CupertinoIcons.search, color: AppColors.textColor,),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const  BorderSide(color: AppColors.textColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:const  BorderSide(color: AppColors.textColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:const  BorderSide(color: AppColors.textColor),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
              ),
              style:const TextStyle(color: AppColors.textColor),
              cursorColor: AppColors.textColor,
            ),
          //),
        ),
       
      ),
      body:const SingleChildScrollView(
        child:  SizedBox(
          height: 500,
          child:  PostWidget(
            postId: '1',
            userId: '1',
            username: 'Username',
            userImage: 'https://example.com/profile_image.jpg',
            postImageOne: 'https://example.com/original_product.jpg',
            postImageTwo: 'https://example.com/reference_product.jpg',
            status: 'Looking for artist',
            productName: 'ProductA',
            productPrice: '800-1000 ฿',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String postId;
  final String userId;
  final String username;
  final String userImage;
  final String postImageOne;
  final String postImageTwo;
  final String status;
  final String productName;
  final String productPrice;
  final String description;

  const PostWidget({
    super.key, 
    required this.postId,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.postImageOne,
    required this.postImageTwo,
    required this.status,
    required this.productName,
    required this.productPrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://example.com/profile_image.jpg'), // replace with your image URL
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(
                                'https://example.com/original_product.jpg', // replace with your image URL
                                height: 100,
                              ),
                              Text('Original Product'),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(
                                'https://example.com/reference_product.jpg', // replace with your image URL
                                height: 100,
                              ),
                              Text('Reference'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• Looking for artist'),
                            ],
                          ),
                        ),
                      ],
                    
                    ),
                    SizedBox(height: 8),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Name: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ProductA'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• 800-1000 ฿'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

    
  

