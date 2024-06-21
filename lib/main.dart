import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loop/Notification/notification_bloc.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/chat/chat_bloc.dart';
import 'package:loop/chat/chat_repo.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/post_management/post_repo.dart';
import 'package:loop/splash.dart';
import 'package:loop/user_management/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/post_management/create_post_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Notification/notification_repo.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  BigPictureStyleInformation? bigPictureStyleInformation;
  if (message.data['body']!.startsWith('http://10.0.2.2')) {
    final http.Response response =
        await http.get(Uri.parse(message.data['body']));
    bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(response.bodyBytes)),
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(response.bodyBytes)));
  }

  await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      bigPictureStyleInformation == null ? message.data['body'] : '',
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              icon: 'launch_background',
              channelDescription: channel.description,
              styleInformation: bigPictureStyleInformation)));
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  final authRepository = AuthRepository();
  final postRepository = PostRepository();
  final chatRepository = ChatRepository();
  final notificationRepository = NotificationRepository();

  //runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(authRepository)),
        BlocProvider<CreatePostBloc>(
            create: (_) => CreatePostBloc(postRepo: postRepository)),
        BlocProvider<ChatBloc>(
            create: (_) => ChatBloc(chatRepo: chatRepository)),
        BlocProvider<NotificationBloc>(
            create: (_) =>
                NotificationBloc(notificationRepo: notificationRepository))
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
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      return MaterialApp(
        title: 'Loop',
        theme: ThemeData(),
        home: const SplashScreen(),
      );
    });
  }
}
