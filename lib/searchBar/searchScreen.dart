import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/searchBar/searchPost.dart';
import 'package:loop/searchBar/searchUser.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {


  TextEditingController searchController = TextEditingController();
  int selectIndex = 0;
  String searchQuery = '';

  void updateSearchQuery(String query){
    setState((){
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 64,
                child: TextField(
                  autofocus: true,

            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundColor),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  onPressed: () {
                  },
                  child: const Icon(CupertinoIcons.search, color: AppColors.textColor),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.textColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.textColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.textColor),
              ),
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
            ),
            onChanged: updateSearchQuery,
            style: const TextStyle(color: AppColors.textColor),
            cursorColor: AppColors.textColor,

                ),
              ),
              ),
              SizedBox(height: 0),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color:  AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: TabBar(
                          onTap: (index) {
                            setState(() {
                              selectIndex = index;
                            });
                          },
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 05),
                          indicatorColor: AppColors.backgroundColor,
                          tabs: [
                            selectIndex != 0
                                ? const Text(
                                    'Username',
                                    style: TextStyle(
                                        color: AppColors.textColor, fontSize: 15),
                                  )
                                : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Username',
                                        style: TextStyle(
                                            color: AppColors.textColor, fontSize: 15),
                                      ),
                                    ),
                                  ),
                            selectIndex != 1
                                ? const Text(
                                    'Post',
                                    style: TextStyle(
                                        color: AppColors.textColor, fontSize: 15),
                                  )
                                : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Post',
                                        style: TextStyle(
                                            color: AppColors.textColor, fontSize: 15),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          
                          /* searchList(
                            searchQuery: searchQuery,
                          ), */
                          searchUser(
                            searchQuery: searchQuery,
                          ),
                          SearchPost(
                            searchQuery: searchQuery,
                          ),
                        ],
                        ),
                        ),
                    ],
                    ),
                    )
            ],
          )
        ),
      ),
    );
  }
}