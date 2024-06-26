import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/forgotpwd/forgotpwd.dart';
import 'package:loop/auth/login/login_bloc.dart';
import 'package:loop/auth/login/login_event.dart';
import 'package:loop/auth/login/login_state.dart';
import 'package:loop/auth/signup/signup_view.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/chat/chat_bloc.dart';
import 'package:loop/chat/chat_event.dart';
import '../../Notification/notification_bloc.dart';
import '../../Notification/notification_event.dart';
import '../../components/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final AuthRepository authRepo = AuthRepository();
  String errormsg = '';

  // Check login status
  @override
  void initState() {
    super.initState();
   // _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await authRepo.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider(
          create: (context) =>
              LoginBloc(authRepo: context.read<AuthRepository>()),
          child: _loginForm(),
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            fillColor: AppColors.backgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email address';
            } else if (!state.isValidEmail) {
              return 'Invalid Email';
            } else if (errormsg.isNotEmpty) {
              return 'Incorrect Email or Password';
            }
            return null;
          },

          //validator: (value) => state.isValidEmail ? null : "Invalid Email",
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginemailChanged(email: value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            fillColor: AppColors.backgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                color: AppColors.primaryColor,
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password is required';
            } else if (errormsg.isNotEmpty) {
              return 'Incorrect Password or Email';
            } else if (state.errorMessage.isNotEmpty) {
              print(state.errorMessage);
              return state.errorMessage;
            }
            return null;
          },
          onChanged: (value) => context
              .read<LoginBloc>()
              .add(LoginPasswordChanged(password: value)),
        );
      },
    );
  }

  Widget _forgotPassword() {
    return TextButton(
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
            return null;
          },
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColors.backgroundColor,
              content: const SizedBox(
                width: 800,
                height: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ForgotPasswordModal()],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: AppColors.textColor, fontSize: 13),
      ),
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: 160.0,
          height: 40.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              errormsg = await authRepo.login(
                  email: state.email, password: state.password);
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(LoginSubmitted());
                Fluttertoast.showToast(
                  msg: "Account Login Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  webPosition: "center",
                  webBgColor: '#B8BF7B',
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColors.tertiaryColor,
                  textColor: AppColors.backgroundColor,
                  fontSize: 16.0,
                );
                context.read<ChatBloc>().add(ChatUserLoggedIn());
                context.read<NotificationBloc>().add(NotificationUserLoggedIn());
                context.read<ChatBloc>().add(ReadyToFetchContacts());
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepositoryProvider(
                        create: (context) => AuthRepository(),
                        child: const BottomNav(),
                      ),
                    ),
                  );
                });
              }
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _donothaveAccount() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(color: AppColors.textColor, fontSize: 13),
              ),
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
                      return null;
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepositoryProvider(
                        create: (context) => AuthRepository(),
                        child: SignUpView(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 150.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'image/loop_logo.svg',
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  _emailField(),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  _passwordField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _forgotPassword(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _loginButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
        _donothaveAccount(),
      ],
    );
  }
}

