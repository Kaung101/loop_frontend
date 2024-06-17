import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/other_profile/other_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthRepository authRepository = AuthRepository();
  late Future<List<dynamic>> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = getAllPost();
    refreshPosts();
  }

  Future<List<dynamic>> getAllPost() async {
    final postList = await authRepository.fetchAllPost();
    return postList.map((post) => PostWidget(
      username: post['user_name'],
      userId: post['user'],
      userImage: (post['user_img'] != null )? post['user_img'] : 'image/logo.png', // Replace with actual data if available
      postImageOne: 'http://localhost:3000/media?media_id=${post['original_photo']}', // Replace with actual data if available
      postImageTwo: 'http://localhost:3000/media?media_id=${post['reference_photo']}', // Replace with actual data if available
      status: post['artist_post'] == false ? "Upcycled by me" : "Looking for artisit"  , // Replace with actual data if available
      productName: post['name'],
      productPrice: post['price'],
      description: post['description'],
    )).toList();
  }

  void refreshPosts() {
    setState(() {
      _postFuture = getAllPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: Container(
          margin: const EdgeInsets.only(top: 1.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundColor),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  onPressed: () {},
                  child: const Icon(CupertinoIcons.search, color: AppColors.textColor),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.textColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.textColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.textColor),
              ),
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
            ),
            style: const TextStyle(color: AppColors.textColor),
            cursorColor: AppColors.textColor,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index];
              },
            );
          }
        },
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: AppColors.textColor, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(userId: userId)));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userImage),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.transparent;
                            }
                            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                              return Colors.transparent;
                            }
                            return null;
                          },
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(userId: userId)));
                      },
                      child: Text(
                        username,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: AppColors.textColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              child: Image.network(
                                postImageOne,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Original Product',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              child: Image.network(
                                postImageTwo,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Reference',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                        Text('• $status'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                        Text('• $productName'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                        Text('• $productPrice ฿'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                        Text('• $description'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}