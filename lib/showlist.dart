import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/components/editProfileNav.dart';
import 'package:loop/searchBar/searchScreen.dart';
import 'package:loop/other_profile/other_profile.dart';
import 'package:loop/user_management/edit_profile.dart';
import 'package:loop/user_management/view_profile.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}
class _HomeScreenState extends State<HomeScreen> {
  final AuthRepository authRepository = AuthRepository();
  late Future<List<dynamic>> _postFuture;
  String? ownUserId;

  @override
  void initState() {
    super.initState();
    _postFuture = getAllPost();
    refreshPosts();
    authRepository.fetchUserData().then((userData) {
      setState(() {
        ownUserId = userData?['user']['_id'];
      });
    });
  }

  Future<List<dynamic>> getAllPost() async {
    final postList = await authRepository.fetchAllPost();
    return postList.map((post) => PostWidget(
      username: post['user_name'] ?? '',
      userId: post['user'] ?? '',
      userImage: post['profileImage'] ?? '',
      postImageOne: 'http://10.0.2.2:3000/media?media_id=${post['original_photo'] ?? ''}',
      postImageTwo: 'http://10.0.2.2:3000/media?media_id=${post['reference_photo'] ?? ''}',
      status: post['artist_post'] ? "Upcycled by me" : "Looking for artist",
      productName: post['name'] ?? '',
      productPrice: post['price'] ?? '',
      description: post['description'] ?? '',
      ownUserId: ownUserId,
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
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const searchScreen(),
                  //settings: const RouteSettings(name: '/changePw'),
                ),
              );
            },
            child: AbsorbPointer(
              absorbing: true,
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
                      onPressed: () {

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const searchScreen(),
                                      settings: const RouteSettings(name: '/changePw'),
                                    ),
                                  );
                      },
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
  final String? ownUserId;

  PostWidget({
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
    this.ownUserId,
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
                  //if ownerUsrId and UserId equal I want to got to ProfielView page and make bottom nav selected as profielView

                  Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => ownUserId == userId ? const ProfileNav() : OtherProfile(userId: userId),
                      settings: ownUserId == userId ? RouteSettings(name: '/viewProfile') : RouteSettings(name: ''),
                  ));
                 // print("User ID from post widget: $userId");
                  //print("Own User ID from post widget: $ownUserId");
                },
                child: Row(
                  children: [
                    ClipOval(
                      child: userImage != 'null' && userImage.isNotEmpty
                        ? Image.network(
                           'http://localhost:3000/media?media_id=$userImage',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Image.asset('image/logo.png', width: 60, height: 60),
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
                        Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => ownUserId == userId ? ProfileNav() : OtherProfile(userId: userId),
                  ));
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
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
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
              const SizedBox(height: 16),
              
            ],
          ),
        ),
      ),
    );
  }
}
