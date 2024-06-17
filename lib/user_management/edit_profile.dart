// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:loop/components/colors.dart';
// import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
// import 'package:loop/auth/auth_repo.dart';
// import 'package:loop/user_management/view_profile.dart';


// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {  

//    Uint8List? _profileImageBytes;
//    late TextEditingController _emailController;
//    final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
  
//   String _profilePhotoUrl ='';

//   final AuthRepository _authRepository = AuthRepository();

//   String? _username;
//   String? _firstName;
//   String? _lastName;
//   String? _profileImageUrl;
//   String? _email;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();

//    // _loadUserData();
//   }
//   Future<void> _fetchUserData() async {
//     try {
//       final userData = await _authRepository.fetchUserData();
//       setState(() {
//         _username = userData?['user']['username'];
//         _profileImageUrl = userData?['user']['profile_imgUrl'];
//         _email = userData?['user']['email'];
//         print("$_email from edit profile");
//         _firstName = userData?['user']['first_name'];
//         _lastName = userData?['user']['last_name'];
//         _firstNameController.text = _firstName!;
//         _lastNameController.text = _lastName!;
//         _usernameController.text = _username ?? '';
//       });
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }

//   void _saveData(){
//     String? new_username = _username;
//     print(new_username);
//   }

//   /* void _loadUserData() async {
//   // Replace Firebase data retrieval with your own data source (e.g., local storage)
//   String? firstName = await _firstNameController.text; // Implement logic to fetch from storage
//   String? lastName = await _lastNameController.text; // Implement logic to fetch from storage
//   String? username = await _username; // Implement logic to fetch from storage
//   String? profilePhotoUrl = await _profileImageUrl; // Implement logic to fetch from storage

//   if (firstName != null) {
//     _firstNameController.text = firstName;
//   }
//   if (lastName != null) {
//     _lastNameController.text = lastName;
//   }
//   if (username != null) {
//     _usernameController.text = username;
//   }
//   setState(() {
//     _profilePhotoUrl = profilePhotoUrl ?? ''; // Set profile photo URL
//   });
//   } */

//   // Implement methods to fetch data from your chosen storage solution

//   /* Future<String?> _fetchFirstNameFromStorage() async {
//   // Replace with your logic to retrieve first name from storage (e.g., SharedPreferences)
//   return null; // Example: return SharedPreferences.getInstance().getString('firstName');
//   } */

//   // Implement similar methods for other data fields (lastName, username, profilePhotoUrl)

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         // Displays the back button if canPop returns true, indicating there's a previous route.
//         leading: ModalRoute.of(context)?.canPop == true
//             ? IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.pop(context),
//               )
//             : null,
//       ),
//       backgroundColor: AppColors.backgroundColor,
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             children: [
//               // Profile Picture
//               Container(
//                 width: 200,
//                 height: 200,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.primaryColor,
//                 ),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   clipBehavior: Clip.none,
//                   children: [
//                     // Profile image code commented out for brevity
//                     ClipOval(
//             // backgroundColor: AppColors.primaryColor,
//             child: _profileImageBytes != null
//                 ? Image.memory(
//                     _profileImageBytes!,
//                     width: 200,
//                 height: 200,
//                     fit: BoxFit.cover,
//                   )
//                 : (_profilePhotoUrl.isNotEmpty
//                     ? Image.network(
//                         _profilePhotoUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           print("Error loading image: $error");
//                           return Image.asset(
//                             'image/logo.png',
//                             width: double.infinity,
//                             height: double.infinity,
//                           );
//                         },
//                       )
//                     : Image.asset(
//                         'image/logo.png',
//                         width: 200,
//                 height: 200,
//                       )),
//           ),
//                     Positioned(
//                       right: 12,
//                       bottom: 3,
//                       child: SizedBox(
//                         height: 40,
//                         width: 40,
//                         child: ElevatedButton(
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               side: const BorderSide(color: AppColors.textColor),
//                             ),
//                             backgroundColor: AppColors.backgroundColor,
//                           ),
//                           onPressed: ()  async {
//                             final ImagePicker imagePicker = ImagePicker();
//                             final pickedFile =
//                               await imagePicker.pickImage(source: ImageSource.gallery);
//                             if (pickedFile != null) {
//                               final bytes = await pickedFile.readAsBytes(); // Read the selected image as bytes
//                               setState(() {
//                               _profileImageBytes = bytes; // Set the profile image bytes to display the preview
//                            });
//                               //await _uploadProfilePhoto(bytes); // Upload the image
//               }
//             }, /* _selectAndUploadProfilePhoto */
//                           child: const Icon(
//                             Icons.photo_camera,
//                             color: AppColors.textColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
              
//               // First/Last Name
//               Row(
//                 children: [
//                   Flexible(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'First Name',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: AppColors.textColor,
//                             ),
//                           ),
//                           TextField(
//                             controller: _firstNameController,
//                             decoration: InputDecoration(
//                               filled: false,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 borderSide: BorderSide(
//                                   color: AppColors.textColor,
//                                   width: 2.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Flexible(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Last Name',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: AppColors.textColor,
//                             ),
//                           ),
//                           TextField(
//                             controller: _lastNameController,
//                             decoration: InputDecoration(
//                               filled: false,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 borderSide: BorderSide(
//                                   color: AppColors.textColor,
//                                   width: 2.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // Username
//               TextFieldWithTitle(
//                 title: 'Username',
//                 controller: _usernameController,
//                 //value: _username,
//               ),
//               // Email
//               TextFieldWithTitle(
//                 title: 'Email',
//                 controller: TextEditingController(text: _email),
//                 enabled: false,
//               ),
//               //const Spacer(),
//               const SizedBox(height: 88),
//               // Save Button
//               Align(
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: SizedBox(
//                     width: 160,
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () {
//                         _saveData();
//                        // _updateUserProfile();
//                       } /* _updateUserProfile */,
//                       child: const Text(
//                         'Update',
//                         style: TextStyle(
//                           color: AppColors.backgroundColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               //const Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _updateUserProfile() async {
//   String firstName = _firstNameController.text.trim();
//   String lastName = _lastNameController.text.trim();
//   String username = _usernameController.text.trim();

//   //User? currentUser = FirebaseAuth.instance.currentUser;

//   if (username != null) {
//     try {
//       _authRepository.editProfile(      
//         firstName: _firstNameController.text,
//         lastName: _lastNameController.text,
//         username: _usernameController.text,
//         email: _emailController.text,
//   );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully!')),
//       );
//       //  Navigator.pop(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ProfileView()),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update profile: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

//   Future<void> _uploadProfilePhoto(Uint8List profileImaeBytes) async {

//     /* final AuthRepository _authRepository = AuthRepository();

//     Future<List<dynamic>> fetchUserData() async {
//     final userList = await _authRepository.fetchUserData();
//     return userList.map((user) => PostWidget(
//       username: user['user_name'],
//       userImage: (user['user_img'] != null) ? user['user_img'] : 'image/logo.png',
//       postImageOne: 'http://localhost:3000/media?media_id=${user['original_photo']}', // Replace with actual data if available
//       postImageTwo: 'http://localhost:3000/media?media_id=${user['reference_photo']}',
//       status: user['artist_post'] == true ? 'Looking for artist' : 'Upcycled by Me',
//       productName: user['name'],
//       productPrice: user['price'],
//       description: user['description'],
//     )).toList();
//   } */
//     final AuthRepository _authRepository = AuthRepository();

//     String? _username;
//     String? _profileImageUrl;

// /*     @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   } */

//   //get all post future method and return post data

//   }
// }

// class TextFieldWithTitle extends StatefulWidget {
//   final String title;
//   final TextEditingController? controller;
//   final bool enabled;

//   const TextFieldWithTitle({
//     required this.title,
//     this.controller,
//     this.enabled = true,
//     super.key,
//   });

//   @override
//   _TextFieldWithTitleState createState() => _TextFieldWithTitleState();
// }

// class _TextFieldWithTitleState extends State<TextFieldWithTitle> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.title,
//             style: const TextStyle(
//               fontSize: 16,
//               color: AppColors.textColor,
//             ),
//           ),
//           TextField(
//             controller: widget.controller,
//             enabled: widget.enabled && widget.controller != null,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: AppColors.backgroundColor,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(
//                   color: AppColors.textColor,
//                   width: 3.0, // Bolder border width
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(
//                   color: AppColors.primaryColor,
//                   width: 3.0, // Bolder border width
//                 ),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(
//                   color: AppColors.textColor,
//                   width: 3.0, // Bolder border width
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/components/colors.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/user_management/view_profile.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _authRepository.fetchUserData();
      setState(() {
        _usernameController.text = userData?['user']['username'] ?? '';
        _profilePhotoUrl = userData?['user']['profile_imgUrl'] ?? '';
        _emailController.text = userData?['user']['email'] ?? '';
        _firstNameController.text = userData?['user']['firstName'] ?? '';
        _lastNameController.text = userData?['user']['lastName'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _updateUserProfile() async {
    try {
      await _authRepository.editProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileView()),
      );
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
      // Implement upload logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
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
                                  _profilePhotoUrl,
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
                              side: const BorderSide(color: AppColors.textColor),
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
              TextFieldWithTitle(
                title: 'Username',
                controller: _usernameController,
              ),
              // Email
              TextFieldWithTitle(
                title: 'Email',
                controller: _emailController,
                enabled: false,
              ),
              const SizedBox(height: 88),
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
