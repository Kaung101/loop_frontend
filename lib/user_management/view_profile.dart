import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/components/editProfileNav.dart';
import 'package:loop/user_management/edit_profile.dart';
import 'package:loop/user_management/change_password.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthRepository _authRepository = AuthRepository();

  String? _username;
  String? _profileImageUrl;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _authRepository.fetchUserData();
      setState(() {
        _username = userData?['user']['username'];
        _profileImageUrl = userData?['user']['profileImage'];
        userId = userData?['user']['_id'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _signOut() async {
    var token = await _authRepository.getAuthToken();
    try {
      await _authRepository.logoutUser(token!);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
        );
      }
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(_username ?? 'Profile'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _followerSection(),
            const SizedBox(height: 20),
            _editProfileSection(),
            const SizedBox(height: 20),
             ShowOwnerPost(),
             //dropDown()
            //),
          ],
        ),
      ),
    );
  }

  Widget _followerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
              ? NetworkImage(
                'http://localhost:3000/media?media_id=$_profileImageUrl'
              )
              : const AssetImage('image/logo.png') as ImageProvider,
        ),
        const SizedBox(width: 40),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '123',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'followers',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        const VerticalDivider(
          color: Colors.black,
          thickness: 1,
          width: 20,
        ),
        const SizedBox(width: 60),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '321',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'following',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: AppColors.backgroundColor,
          content: const Text(
            "Are you sure you want to delete your account?",
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: AppColors.backgroundColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // Handle account deletion
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: AppColors.tertiaryColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _editProfileSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.textColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  /* Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ), */
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EditProfile(),
                                  settings: const RouteSettings(name: '/editProfile'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Divider(color: AppColors.primaryColor),
              Row(
                children: [
                  const Text(
                    'Change Password',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ChangePw(),
                                  settings: const RouteSettings(name: '/changePw'),
                                ),
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.primaryColor),
              Row(
                children: [
                  const Text(
                    'Delete My Account',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _showDeleteAccountDialog,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.primaryColor),
              Row(
                children: [
                  const Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _signOut,
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

class ShowOwnerPost extends StatefulWidget {
  @override
  _ShowOwnerPostState createState() => _ShowOwnerPostState();
}

class _ShowOwnerPostState extends State<ShowOwnerPost> {
  final AuthRepository _authRepository = AuthRepository();
  late Future<List<dynamic>> _postFuture;
  late String userId;

  @override
  void initState() {
    super.initState();
    _postFuture = getAllPost();
    _authRepository.fetchUserData().then((userData) {
      setState(() {
        userId = userData?['user']['_id'];
      });
    });
    refreshPosts();
  }

  Future<List<dynamic>> getAllPost() async {
    final postList = await _authRepository.ownProfilePost(userId: userId);
    return postList.map((post) => PostWidget(
      username: post['user_name'] ?? '',
      userImage: post['profileImage'] ?? '',
      postImageOne: 'http://localhost:3000/media?media_id=${post['original_photo']}', // Replace with actual data if available
      postImageTwo: 'http://localhost:3000/media?media_id=${post['reference_photo']}',
      status: post['artist_post'] == false ? 'Looking for artist' : 'Upcycled by Me',
      productName: post['name'] ?? '',
      productPrice: post['price'] ?? '',
      description: post['description'] ?? '',
    )).toList();
  }
  void refreshPosts() {
    //setState(() {
      _postFuture = getAllPost();
    //});
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
          return const Center(child: Text('No posts available'));
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
  //final String postId;
  //final String userId;
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
    //required this.postId,
   // required this.userId,
    required this.username,
    required this.userImage,
    required this.postImageOne,
    required this.postImageTwo,
    required this.status,
    required this.productName,
    required this.productPrice,
    required this.description,
  });

  /* final String _drowdownValue = 'Show Post';
  var _items = [
    'Show Post',
    'Hide From Feed',
    'Delete Post',
  ];
 */
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.textColor, width: 1.0), // Set border color and width
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  ClipOval(
                      child: userImage != 'null' && userImage.isNotEmpty
                        ? Image.network(
                           'http://localhost:3000/media?media_id=$userImage',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        :  Image.asset('image/logo.png', width: 60, height: 60),
                    ),
                  const SizedBox(width: 4),
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
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                    onPressed: (){

                    },
                     child: Text(
                    username,
                    style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor
                    ),
                  ),
                    ),
                    const Spacer(),
                    DropDown(),
                    IconButton(
                          icon: const Icon(CupertinoIcons.delete),
                          onPressed: (){},
                        ),            
                ],
              ),
              SizedBox(height: 8),
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
                             Text(
                              (status) == 'Looking for artist'
                                  ? 'Original Product'
                                  : 'Before',
                              style: const TextStyle(
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
                             Text(
                              (status) == 'Looking for artist'
                                  ? 'Reference'
                                  : 'After',
                              style: const TextStyle(
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
                        Text('• $status'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
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
                        Text('• $productName'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
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
                        Text('• $productPrice ฿'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
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

class DropDown extends StatefulWidget {
  @override
  DropDownState createState() => DropDownState();
}

class DropDownState extends State<DropDown> {
  String dropdownValue = 'Show Post';
  final List<String> _items = [
    'Show Post',
    'Hide from Feed',
    //'Delete Post',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 24,
      decoration: BoxDecoration(
        //filled: false,
        //color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.textColor, width: 1.0),      
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textColor,
          ),
          /* underline: Container(
            height: 2,
            color: AppColors.primaryColor,
          ), */
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: _items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
