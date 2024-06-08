// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/components/colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);


  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isFollowing = false;
  final AuthRepository _authRepository = AuthRepository();
  String? _username;
  String? _profileImageUrl = '';
  String? status;
  String? productName;
  String? estimatePrice;
  String? description;
  String? beforeImageUrl;
  String? afterImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      final userData = await _authRepository.fetchUserData();
      setState(() {
        _username = userData?['user']['username'];
         _profileImageUrl = userData?['user']['profile_imgUrl'];
        print(_profileImageUrl);
      });
    } catch (e) {
      print('Error fetching username: $e');
    }
  }
  //sign out
  Future<void> _signOut() async {
    var token = await _authRepository.getAuthToken();
    try {
      await _authRepository.logoutUser(token!);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ),
      );
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(_username ?? 'Profile')
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _follwerSection(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 _followButton(),
                const SizedBox(width: 20),
                _messageButton(),
              ],
            ),
            
            const SizedBox(height: 20),
            _postCard(),
            //_editProfileSection(),
          ],
        ),
      ),
      
    );
  }

  //follower section with profil pic on left and follwers and following on the right by dividing with a vertical line
  Widget _follwerSection(){
       return  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                             child: _profileImageUrl!.isNotEmpty
                              ? Image.network(_profileImageUrl!,width: 100, height: 100,fit: BoxFit.cover,) // Load profile photo from URL
                              : Image.asset('image/logo.png', width: 100, height: 100,fit: BoxFit.cover,) , // Fallback image if URL is empty
                        ),
                          ),
                const SizedBox(width: 40),
               const  Column(
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
  //delete account dialog
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


  //edit profile section
  Widget _editProfileSection(){
    return SingleChildScrollView(
      child: Padding(
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
                            const Text('Edit Profile',
                            style: TextStyle(color: AppColors.textColor),),
                            Expanded(
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed: (){},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.primaryColor),
                        Row(
                          children: [
                            const Text('Change Password',
                            style: TextStyle(color: AppColors.textColor),),
                            Expanded(
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed: (){},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.primaryColor),
                        Row(
                          children: [
                            const Text('Delete My Account',
                            style: TextStyle(color: AppColors.textColor),),
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
                            const Text('Sign Out',
                            style: TextStyle(color: AppColors.textColor),),
                            Expanded(
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed: (){
                                      _signOut();
                                    },
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
    );
  }

  //follow button
  Widget _followButton(){
    return SingleChildScrollView(
      child: OutlinedButton(
        onPressed: (){},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: AppColors.backgroundColor,
        ),
        child:const Padding(
          padding:  EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          child: Text(
            'Message',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  //follow button
  Widget _messageButton(){
    return SingleChildScrollView(
      child: OutlinedButton(
        onPressed: (){},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: AppColors.backgroundColor,
        ),
        child:const Padding(
          padding:  EdgeInsets.symmetric(vertical: 12, horizontal: 35),
          child: Text(
            'Follow',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  //post area
  Widget _postCard(){
    return SingleChildScrollView(
      child: Padding(
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
                            ClipOval(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                             child: _profileImageUrl!.isNotEmpty
                              ? Image.network(_profileImageUrl!,width: 100, height: 100,fit: BoxFit.cover,) // Load profile photo from URL
                              : Image.asset('image/logo.png', width: 100, height: 100,fit: BoxFit.cover,) , // Fallback image if URL is empty
                        ),
                          ),
                          const SizedBox(width: 10),
                          Text(_username ?? 'Profile'),
                          const SizedBox(width: 180),
                          Expanded(
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(CupertinoIcons.chat_bubble_fill,
                                    color: AppColors.primaryColor,),
                                    onPressed: (){},
                                  ),
                                ],
                              ),
                            ),
                    
                          ],
                        ),
                        const Divider(color: AppColors.primaryColor),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                              
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.primaryColor),
                        
                      ],
                    ),
                  ),
                ),
              ),
    );
  }



}
