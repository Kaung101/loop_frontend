

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loop/util/jwt.dart';
import 'notification_event.dart';
import 'notification_repo.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepo;

  NotificationBloc({required this.notificationRepo}) : super(NotificationState()){
    on<NotificationUserLoggedIn>(_onUserLoggedIn);
  }

  Future<void> _onUserLoggedIn(
      NotificationUserLoggedIn event, Emitter<NotificationState> emit) async {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        return;
      }

      notificationRepo.updateFcmToken(fcmToken: fcmToken);
  }
}