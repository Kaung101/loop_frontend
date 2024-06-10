import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/post_management/post_repo.dart';
import 'package:loop/splash.dart';
import 'package:loop/user_management/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/post_management/create_post_bloc.dart';

void main() {
  final authRepository = AuthRepository();
  final postRepository = PostRepository();

  //runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(authRepository)),
        BlocProvider<CreatePostBloc>(create: (_) => CreatePostBloc(postRepo: postRepository))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loop',
      theme: ThemeData(
      ),
      home: const SplashScreen(),
      
      
    );
  }
}




