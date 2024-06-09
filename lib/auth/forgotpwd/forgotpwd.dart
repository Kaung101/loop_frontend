import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loop/auth/auth_repo.dart';

import '../../components/colors.dart';
class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final AuthRepository authRepository = AuthRepository();
  bool checkExistEmail = false;
  final _formKey = GlobalKey<FormState>();
  EmailOTP emailOTP = EmailOTP();
  bool showEmailField = true; // Flag to control email field visibility
  bool showResetFields = false; // Flag to control password reset fields
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpcontroller = TextEditingController();
  String errorMessage = '';
  final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$");
  bool passwordVisibleOne = false; //for eye icon
  bool passwordVisibleTwo = false; //for eye icon
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    super.initState();
    passwordVisibleOne = true;
    passwordVisibleTwo = true;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _otpcontroller.dispose();
    super.dispose();
  }

  Future<void> checkEmail(String email) async{
    final response = await authRepository.checkExistEmail(email: email);
    if(response && _formKey.currentState!.validate()){
      setState(() {
        showEmailField = false;
      });
      print("Email exists");
    }
    else{
      print("Email does not exist");
    }
  }


  void _handleSendEmail() {
    print('handle send email click');
      checkEmail(_emailController.text);

  }

  void _handleVerifyOtp() {
    // Simulate OTP verification (replace with actual logic)
    setState(() {
      print("object");
      showResetFields = true;
    });
  }

  void _handleResetPassword() {
    // Simulate password reset logic (replace with actual logic)
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context); // Close the modal after successful reset
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel, color: Colors.grey),
                ),
              ),
              Text(
                showEmailField
                    ? 'Forgot Password'
                    : (showResetFields ? 'Reset Password' : 'Forgot Password'),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: showEmailField,
                child: Column(
                  children: [
                    const Text(
                      'We will send a 6-digit code to your email for the verification process.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          } else if (errorMessage.isNotEmpty) {
                            return errorMessage;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            errorMessage = '';
                          });
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.5)),
                          fillColor: AppColors.backgroundColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                                color: Colors.red), // Custom border color for validation error
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleSendEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !showEmailField && !showResetFields,
                child: Column(
                  children: [
                    const Text(
                      'Enter the 6-digit code that you received on your email',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'OTP Code',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                      child: TextFormField(
                        controller: _otpcontroller,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.5)),
                          fillColor: AppColors.backgroundColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: _handleVerifyOtp,
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showResetFields,
                child: Column(
                  children: [
                    const Text(
                      '     Set the new password     ',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                      child: TextFormField(
                        obscureText: passwordVisibleOne,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (!passwordRegex.hasMatch(value)) {
                            return 'Password must contain at least 6 characters, including:\n'
                                '• Uppercase\n'
                                '• Lowercase\n'
                                '• Numbers and special characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.5)),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 35.0, right: 15.0),
                            child: Icon(Icons.lock_outline,
                                color: AppColors.primaryColor.withOpacity(0.5)),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: IconButton(
                                icon: Icon(
                                  passwordVisibleOne
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibleOne = !passwordVisibleOne;
                                  });
                                }),
                          ),
                          fillColor: AppColors.backgroundColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                      child: TextFormField(
                        obscureText: passwordVisibleTwo,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value != _passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.5)),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 35.0, right: 15.0),
                            child: Icon(Icons.lock_outline,
                                color: AppColors.primaryColor.withOpacity(0.5)),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: IconButton(
                                icon: Icon(
                                  passwordVisibleTwo
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibleTwo = !passwordVisibleTwo;
                                  });
                                }),
                          ),
                          fillColor: AppColors.backgroundColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Colors.red), // Custom border color for validation error
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Confirm Password',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleResetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
