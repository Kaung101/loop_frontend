import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/auth/signup/signup_bloc.dart';
import 'package:loop/auth/signup/signup_event.dart';
import 'package:loop/auth/signup/signup_state.dart';
import 'package:loop/auth/loginform_status.dart';
import '../../components/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: Scaffold(
        body: BlocProvider(
          create: (context) =>
              SignUpBloc(authRepo: context.read<AuthRepository>()),
          child: _signUpForm(),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
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
            if (state.isValidUsername) {
              return null;
            } else if (state.errorMessage.isNotEmpty) {
              return state.errorMessage;
            }
            return "Invalid Username";
          },
          onChanged: (value) => context
              .read<SignUpBloc>()
              .add(SignUpUsernameChanged(username: value)),
        );
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
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
            if (state.isValidEmail) {
              return null;
            } else if (state.errorMessage.isNotEmpty) {
              return state.errorMessage;
            }
            return "Invalid Email";
          },
          onChanged: (value) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(email: value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            fillColor: AppColors.backgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(
               _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ),
              color: AppColors.primaryColor,
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
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) =>
              state.isValidPassword ? null : 'Invalid Password',
          onChanged: (value) => context
              .read<SignUpBloc>()
              .add(SignUpPasswordChanged(password: value)),
        );
      },
    );
  }

  Widget _confirmPasswordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            fillColor: AppColors.backgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ),
              color: AppColors.primaryColor,
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
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) =>
              state.isPasswordMatch ? null : 'Passwords do not match',
          onChanged: (value) => context
              .read<SignUpBloc>()
              .add(SignUpConfirmPasswordChanged(confirmPassword: value)),
        );
      },
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.formStatus is SubmissionFailed) {
          print(state.errorMessage);
        }
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<SignUpBloc>().add(SignUpSubmitted());
                Fluttertoast.showToast(
                    msg: "Account Signin Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    webPosition: "center",
                    webBgColor: '#B8BF7B',
                    timeInSecForIosWeb: 1,
                    backgroundColor: AppColors.tertiaryColor,
                    textColor: AppColors.backgroundColor,
                    fontSize: 16.0);
                Future.delayed(const Duration(seconds: 1),(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepositoryProvider(
                        create: (context) => AuthRepository(),
                        child: const LoginView(),
                      ),
                    ),
                  );
                
                });
              }
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _alreadyHaveAccount() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
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
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                // Add navigation to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RepositoryProvider(
                      create: (context) => AuthRepository(),
                      child: const LoginView(),
                    ),
                  ),
                );
              },
              child: const Text(
                'Login here',
                style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  child: Container(
                    height: 100,
                    // margin: const EdgeInsets.only(top: 170),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('image/logo.png'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Username',
                        style: TextStyle(
                            color: AppColors.textColor, fontSize: 13)),
                  ],
                ),
              ),
              _usernameField(),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Email',
                        style: TextStyle(
                            color: AppColors.textColor, fontSize: 13)),
                  ],
                ),
              ),
              _emailField(),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Password',
                        style: TextStyle(
                            color: AppColors.textColor, fontSize: 13)),
                  ],
                ),
              ),
              _passwordField(),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Confirm Password',
                        style: TextStyle(
                            color: AppColors.textColor, fontSize: 13)),
                  ],
                ),
              ),
              _confirmPasswordField(),
              const SizedBox(height: 20),
              _signUpButton(),
              _alreadyHaveAccount(),
            ],
          ),
        ),
      ),
    );
  }
}
