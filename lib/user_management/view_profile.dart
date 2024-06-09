import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/components/bottomNavigatioon.dart';
import 'package:loop/components/colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthRepository _authRepository = AuthRepository();

  String? _username;
  String? _profileImageUrl;

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
        _profileImageUrl = userData?['user']['profile_imgUrl'];
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
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textColor),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const BottomNav(),
              ),
            );
          },
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(_username ?? 'Profile'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _followerSection(),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            _editProfileSection(),
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
              ? NetworkImage(_profileImageUrl!)
              : const AssetImage('image/logo.png') as ImageProvider,
        ),
        const SizedBox(width: 40),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
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
          children:  [
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
                    const Text(
                      'Edit Profile',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {},
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
                            onPressed: () {},
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
      ),
    );
  }

}
