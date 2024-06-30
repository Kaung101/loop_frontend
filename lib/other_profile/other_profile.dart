import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/components/colors.dart';
import 'package:tuple/tuple.dart';

import '../chat/direct_message_view.dart';

class OtherProfile extends StatefulWidget {
  final String userId;

  OtherProfile({super.key, required this.userId});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  final AuthRepository _authRepository = AuthRepository();

  String? _username;
  String? _profileImageUrl;
  String? _firstName;
  String? _lastName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData =
          await _authRepository.fetchOtherProfileData(userId: widget.userId);
      //final userData = await _authRepository.fetchUserData();

      setState(() {
        _username = userData?['username'];
        _profileImageUrl = userData?['profileImage'];
        _firstName = userData?['firstName'];
        _lastName = userData?['lastName'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(_username ?? 'Username'),
        ),
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                icon: const Icon(CupertinoIcons.left_chevron),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        //chat here!
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.chat_bubble_fill,
                  color: AppColors.primaryColor, size: 30),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DirectMessageView(
                            userId:
                                Tuple2<String, String>(userId, _username!))));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _followerSection(),
            const SizedBox(height: 20),
            _nameSection(),
            // const SizedBox(height: 20),
            ShowOtherPost(userId: userId, image: _profileImageUrl ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _followerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: CircleAvatar(
                radius: 75,
                backgroundImage: _profileImageUrl != null &&
                        _profileImageUrl!.isNotEmpty
                    ? NetworkImage(
                        'http://54.254.8.87/media?media_id=$_profileImageUrl')
                    : const AssetImage('image/logo.png') as ImageProvider,
              ),
            ),
          ],
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  //show firstname and last name
  Widget _nameSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _firstName ?? 'First Name',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          _lastName ?? 'Last Name',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buttonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 182.0,
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
            child: const Text(
              'Message',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 182.0,
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
            child: const Text(
              'Follow',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShowOtherPost extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();
  final String userId;
  final String image;

  ShowOtherPost({super.key, required this.userId, required this.image});

  Future<List<dynamic>> getAllPost() async {
    final postList = await _authRepository.otherProfilePost(userId: userId);
    return postList
        .map((post) => PostWidget(
              username: post['user_name'] ?? '',
              userId: post['user'] ?? '',
              userImage: post['profileImage'] ?? '',
              // Replace with actual data if available
              postImageOne:
                  'http://54.254.8.87/media?media_id=${post['original_photo']}',
              // Replace with actual data if available
              postImageTwo:
                  'http://54.254.8.87/media?media_id=${post['reference_photo']}',
              // Replace with actual data if available
              status: post['artist_post'] == false
                  ? "Looking for artisit"
                  : "Upcycled by me",
              // Replace with actual data if available
              productName: post['name'] ?? '',
              productPrice: post['price'] ?? '',
              description: post['description'] ?? '',
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getAllPost(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Upcycled by  yet!'));
        } else {
          final posts = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return posts[index];
            },
          );
        }
      },
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
          side: const BorderSide(
              color: AppColors.textColor,
              width: 1.0), // Set border color and width
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherProfile(userId: userId),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipOval(
                      child: userImage != 'null' && userImage.isNotEmpty
                          ? Image.network(
                              'http://54.254.8.87/media?media_id=$userImage',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('image/logo.png',
                              width: 60, height: 60),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.transparent;
                            }
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed)) {
                              return Colors.transparent;
                            }
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OtherProfile(userId: userId)),
                        );
                      },
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      // Only bottom padding
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryColor,
                          // Set the background color
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
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
                              'Before',
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
                      // Only bottom padding
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryColor,
                          // Set the background color
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
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
                              'After',
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
              SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
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
                        Text('• $status'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
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
                        Text('• $productName'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
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
                        Text('• $productPrice ฿'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
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
                          '• $description',
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
    );
  }
}
