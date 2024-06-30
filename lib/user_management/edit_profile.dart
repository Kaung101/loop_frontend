import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/components/colors.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:loop/auth/auth_repo.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _profileImageBytes;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String _profilePhotoUrl = '';
  final AuthRepository _authRepository = AuthRepository();
  String userId = '';
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  //intially fetch user data
  Future<void> _fetchUserData() async {
    try {
      print('fetching user data');
      final userData = await _authRepository.fetchUserData();
      print(userData);
      setState(() {
        print(userData?['user']['id']);
        userId = userData?['user']['id'];
        _fetchUpdateData(userId);
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  //fetch user data after update
  Future<void> _fetchUpdateData(String userId) async {
    try {
      final userData =
      await _authRepository.fetchOtherProfileData(userId: userId);
      setState(() {
        _usernameController.text = userData?['username'] ?? '';
       _profilePhotoUrl = userData?['profileImage'] ?? '';
        _firstNameController.text= userData?['firstName'] ?? '';
       _lastNameController.text= userData?['lastName'] ?? '';
        _emailController.text= userData?['email'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _updateUserProfile() async {
    try {
      final res = await _authRepository.editProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!',
              style: TextStyle(color: AppColors.backgroundColor)),
          backgroundColor: AppColors.tertiaryColor,
        ),
      );
      _fetchUserData();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectAndUploadProfilePhoto() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageBytes = bytes;
      });
      print('from outside');
      // Implement upload image logic
      var res = await _authRepository.editProfileImage(
          image: pickedFile, userId: userId!);
      if (res) {
        setState(() {
          _fetchUserData();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Image updated successfully!',
                style: TextStyle(color: AppColors.backgroundColor)),
            backgroundColor: AppColors.tertiaryColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                icon: const Icon(CupertinoIcons.left_chevron, color: AppColors.textColor),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Profile Picture
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: _profileImageBytes != null
                          ? Image.memory(
                              _profileImageBytes!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : (_profilePhotoUrl.isNotEmpty
                              ? Image.network(
                                  'http://54.254.8.87/media?media_id=$_profilePhotoUrl',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Error loading image: $error");
                                    return Image.asset(
                                      'image/logo.png',
                                      
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    );
                                  },
                                )
                              : Image.asset(
                                 'image/logo.png',
                                  
                                  width: 200,
                                  height: 200,
                                )),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 3,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side:
                                  const BorderSide(color: AppColors.textColor),
                            ),
                            backgroundColor: AppColors.backgroundColor,
                          ),
                          onPressed: _selectAndUploadProfilePhoto,
                          child: const Icon(
                            Icons.photo_camera,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Text(_profilePhotoUrl),
              // First/Last Name
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'First Name',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColor,
                            ),
                          ),
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              filled: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: AppColors.textColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last Name',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColor,
                            ),
                          ),
                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              filled: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: AppColors.textColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Username
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColor,
                            ),
                          ),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              filled: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: AppColors.textColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Email
              TextFieldWithTitle(
                title: 'Email',
                controller: _emailController,
                enabled: false,
              ),
              const SizedBox(height: 55),
              // Save Button
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 160,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _updateUserProfile,
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final bool enabled;

  const TextFieldWithTitle({
    required this.title,
    this.controller,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textColor,
            ),
          ),
          TextField(
            controller: controller,
            enabled: enabled && controller != null,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.textColor,
                  width: 3.0, // Bolder border width
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 3.0, // Bolder border width
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.textColor,
                  width: 3.0, // Bolder border width
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
