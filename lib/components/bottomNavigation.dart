import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loop/chat/chat_view.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/other_profile/other_profile.dart';
import 'package:loop/post_management/create_post.dart';
import 'package:loop/showlist.dart';
import 'package:loop/user_management/edit_profile.dart';
import 'package:loop/user_management/view_profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final List<Widget> screens = [
    const HomeScreen(),
    const ChatView(),
    const CreatePost(), 
    const ProfileView(),
  ];
    void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => screens[index],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            top: BorderSide(
              color: AppColors.primaryColor,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          surfaceTintColor: AppColors.primaryColor,
          indicatorColor: AppColors.primaryColor,
          backgroundColor: AppColors.backgroundColor,
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.house_alt_fill, color: AppColors.primaryColor),
              selectedIcon: Icon(CupertinoIcons.house_alt_fill, color: AppColors.backgroundColor),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.chat_bubble, color: AppColors.primaryColor),
              selectedIcon: Icon(CupertinoIcons.chat_bubble_fill, color: AppColors.backgroundColor),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.add, color: AppColors.primaryColor, size: 30),
              selectedIcon: Icon(CupertinoIcons.add, color: AppColors.backgroundColor),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined, color: AppColors.primaryColor, size: 30),
              selectedIcon: Icon(Icons.account_circle_outlined, color: AppColors.backgroundColor),
              label: '',
            ),
          ],
        ),
      ),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => screens[_selectedIndex];
              break;
            case '/editProfile':
              builder = (BuildContext _) => const EditProfile();
              break;
            default:
              builder = (BuildContext _) => const Scaffold(
                    body: Center(child: Text('Page not found')),
                  );
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },

    ));
  }
}
