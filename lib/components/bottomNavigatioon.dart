import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loop/chat/chat_view.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/components/nav.dart';
import 'package:loop/post_management/create_post.dart';
import 'package:loop/showlist.dart';
import 'package:loop/user_management/view_profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const ChatView(),
    const CreatePost(), 
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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
              selectedIcon: Icon(CupertinoIcons.chat_bubble, color: AppColors.backgroundColor),
              label: '',
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
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
    );
  }
}
