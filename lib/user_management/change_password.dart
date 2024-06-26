import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loop/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loop/auth/auth_repo.dart'; // Adjust the import based on your project structure

class ChangePw extends StatefulWidget {
  const ChangePw({super.key});

  @override
  State<ChangePw> createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePw> {
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool newPasswordError = false;
  String _emailController = '';
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool passwordVisibleOne = false;
  bool passwordVisibleTwo = false;
  bool passwordVisibleThree = false;
  final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$");
  final authRepo = AuthRepository();

  @override
  void initState() {
    super.initState();
    passwordVisibleOne = true;
    passwordVisibleTwo = true;
    passwordVisibleThree = true;
    _fetchUserData();
  }

  @override
  void dispose() {
    //_emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await authRepo.fetchUserData();
      setState(() {
        _emailController = userData?['user']['email'];
      });
      //print(_emailController);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  Future<void> _updatePassword(String email, String newPassword) async {
    setState(() {
      errorMessage = '';
    });

    try {
/*       final authRepo = AuthRepository();
 */      final success = await authRepo.changePassword(email, _currentPasswordController.text, newPassword);
        print("$success success");
         /* final msg = jsonDecode(success);
         final msgReal = msg['message'];
      print(msgReal);
      print('success'); */
      if (success == 'true') {
        Fluttertoast.showToast(
          msg: ' updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          webPosition: "center",
          webBgColor: '#D1D1D6',
          textColor: AppColors.primaryColor,
          fontSize: 16.0,
        );
        //Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = 'Current password is incorrect';
        });
        _formKey.currentState!.validate();
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Type Correct Password';
      });
      _formKey.currentState!.validate();
    }
  }
  @override
  Widget build(BuildContext context) {
    const appTitle = "Change Password";
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  icon: const Icon(CupertinoIcons.back, color: AppColors.textColor),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppColors.textColor,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ), */
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Password',
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: TextFormField(
                          obscureText: passwordVisibleOne,
                          controller: _currentPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your password';
                            } else if (errorMessage.isNotEmpty) {
                              return errorMessage;
                            }
                            errorMessage = '';
                            return null;
                          },
                          onChanged: (value) => setState(() {
                            errorMessage = '';
                          }),
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: IconButton(
                                icon: Icon(
                                  passwordVisibleOne ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibleOne = !passwordVisibleOne;
                                  });
                                },
                              ),
                            ),
                            //fillColor: Colors.white,
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppColors.textColor,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                          child: Text(
                            'New Password',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: TextFormField(
                          obscureText: passwordVisibleTwo,
                          controller: _newPasswordController,
                          validator: (value) {
                            setState(() {
                              newPasswordError = false;
                            });
                            if (value == null || value.isEmpty) {
                              setState(() {
                                newPasswordError = true;
                              });
                              return 'Please Enter a password';
                            } else if (!passwordRegex.hasMatch(value)) {
                              setState(() {
                                newPasswordError = true;
                              });
                              return 'Password must contain at least 6 characters, including:\n'
                                  '• Uppercase\n'
                                  '• Lowercase\n'
                                  '• Numbers and special characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: IconButton(
                                icon: Icon(
                                  passwordVisibleTwo ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibleTwo = !passwordVisibleTwo;
                                  });
                                },
                              ),
                            ),
                            helperText: newPasswordError
                                ? null
                                : 'Password must contain at least 6 characters, including:\n'
                                  '• Uppercase\n'
                                  '• Lowercase\n'
                                  '• Numbers and special characters',
                            helperStyle: const TextStyle(
                              color: AppColors.textColor,
                              fontSize: 12,
                            ),
                            fillColor: Colors.white,
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppColors.textColor,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
                          child: Text(
                            'Confirm New Password',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: TextFormField(
                          obscureText: passwordVisibleThree,
                          controller: _confirmNewPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Password Again';
                            } else if (value != _newPasswordController.text) {
                              return 'Password does not Match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: IconButton(
                                icon: Icon(
                                  passwordVisibleThree ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibleThree = !passwordVisibleThree;
                                  });
                                },
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppColors.textColor,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updatePassword(_emailController, _newPasswordController.text);                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: AppColors.backgroundColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
