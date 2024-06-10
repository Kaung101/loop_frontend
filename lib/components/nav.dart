import 'package:flutter/material.dart';
import 'package:loop/showlist.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder:(BuildContext context){
            if(settings.name == '/'){
              return const HomeScreen();
            } 
            return const Scaffold(
              body: Center(
                child: Text('Page not found'),
              ),
            );
          }
        );
      },
    );
  }
}