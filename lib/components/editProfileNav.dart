import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/other_profile/other_profile.dart';
import 'package:loop/showlist.dart';
import 'package:loop/user_management/edit_profile.dart';
import 'package:loop/user_management/view_profile.dart';


class ProfileNav extends StatefulWidget {
  //retrieve userId from flutter storage
  const ProfileNav({super.key});

  @override
  State<ProfileNav> createState() => _ProfileNavState();
  
}

class _ProfileNavState extends State<ProfileNav> {
    
  GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();
  @override

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if(settings.name == '/editProfile') {
              return const EditProfile();
            }
            if(settings.name == '/viewProfile') {
              return const ProfileView();
            }
            //main page of the profile section
            return const ProfileView();
            
          },
        );
      },
    );
  }
}