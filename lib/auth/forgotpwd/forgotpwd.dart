import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loop/auth/auth_repo.dart';
import '../../components/colors.dart';
import 'package:http/http.dart' as http;
class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final AuthRepository authRepository = AuthRepository();
  bool checkExistEmail = false;
  String otp = '';
  final _formKey = GlobalKey<FormState>();
  bool showEmailField = true; // Flag to control email field visibility
  bool showResetFields = false; // Flag to control password reset fields
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpcontroller = TextEditingController();
  String errorMessage = '';
  String emailErrorMsg = '';
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
  
  String generateOTP() {
  // Generate a random 6-digit number
  Random random = Random();
  int otp = random.nextInt(900000) + 100000;

  return otp.toString();
}
bool isOTPExpired(DateTime sentTime) {
  // Get the current time
  DateTime currentTime = DateTime.now();

  // Calculate the difference in minutes between the current time and the sent time
  int differenceInMinutes = currentTime.difference(sentTime).inMinutes;

  // If the difference is greater than or equal to 60 minutes, the OTP is expired
  return differenceInMinutes >= 60;
}
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _otpcontroller.dispose();
    super.dispose();
  }
  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async{
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'service_id': 'service_1v0vpqo',
            'template_id': 'template_xco0c47',
            
            'user_id': 'oVUzEnxqA_LAq-wlN',
            'template_params': {
              'name': name,
              'email': email,
              'to_email': _emailController.text,
              'subject': subject,
              'otp_code': message,
            },
          }));

  }
  Future<void> checkOtp(String otp) async{
    if(otp == _otpcontroller.text){
      setState(() {
      showResetFields = true;
    });
      print("OTP is correct");
    }else{
      print("OTP is incorrect");
    }
    
  }
  Future<void> checkEmail(String email) async {

    try {
       otp = generateOTP();
      final response = await authRepository.checkExistEmail(email: email);
      if (_formKey.currentState!.validate()) {
        if (response) {
          setState(() {
            showEmailField = false;
          });
          // Simulate OTP being sent and stored with current time
          DateTime sentTime = DateTime.now();
          // Check if OTP is expired
  if (isOTPExpired(sentTime)) {
    print('OTP is expired');
  } else {
    print('OTP is still valid');
    sendEmail(name: "", email: _emailController.text, subject: "Loop Reset Passowrd Code", message:  otp);
    //print(otp);
    //check same otp
    
  }
          
        } else {
          setState(() {
            emailErrorMsg = 'Email does not exist';
          });
          Fluttertoast.showToast(
                    msg: "Email does not exist",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    webPosition: "center",
                    webBgColor: '#FF0000',
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: AppColors.backgroundColor,
                    fontSize: 16.0);
        }
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  void _handleSendEmail() {
    checkEmail(_emailController.text);
  }

  void _handleVerifyOtp() {
    // Simulate OTP verification (replace with actual logic)
    //checkOtp( generateOTP());
        checkOtp(otp);

    
    setState(() {
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
