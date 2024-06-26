import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/components/editProfileNav.dart';
import 'package:loop/other_profile/other_profile.dart';

class searchUser extends StatefulWidget {
    const searchUser({Key? key, required this.searchQuery})
      : super(key: key);
          
      final String searchQuery;


  @override
  State<searchUser> createState() => _searchUserState();
}

class _searchUserState extends State<searchUser> {

    final AuthRepository authRepository = AuthRepository();
    String? ownerUserId;
    //late String searchQuery = ''; // Define the searchQuery state variable

  /*    Future<List<Map<String, dynamic>>> getAllUsers(String searchQuery) async {
    try {
      return await authRepository.fetchUsers( 'http://54.254.8.87:3000',  searchQuery: searchQuery);
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  } */

/*   Future<List<Map<String, dynamic>>> getAllUsers(String searchQuery) async {
    try {
      return await authRepository.fetchUsers(searchQuery);
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  } */
 @override
  void initState() {
    super.initState();
    authRepository.fetchUserData().then((value) {
      setState(() {
        ownerUserId = value?['user']['id'];
      });
    });
  }

  Future<List<Map<String, dynamic>>> getAllUsers(String searchQuery) async {
    final searchCardList = await authRepository.fetchUsers(searchQuery);
    try {
      return searchCardList.map((card) => {
        'username': card['username'] ?? '', 
        'userImage': card['profileImage'] ?? '',
        'userId': card['_id'] ?? '',
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  @override
   Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getAllUsers(widget.searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              print(snapshot.data![index]);
              print('snap shot data');

              return searchCard(
                username: snapshot.data![index]['username'] ?? '',
                userImage: snapshot.data![index]['userImage'] ?? '',
                userId: snapshot.data![index]['userId'] ?? '',
                ownUserId: ownerUserId ?? '',
              );
              /* final user = snapshot.data![index];
              print('snap shot data');
              print(user);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user['profileImage']),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.77,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['username'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        //Text('${user['firstName']} ${user['lastName']}'),
                        // Add more user details here as needed
                      ],
                    ),
                  ),
                ],
              ); */
            },
          );
        }
      },
    );
  }
}

class searchCard extends StatelessWidget{
  final String username;
  final String userImage;
  final String userId;
  final String ownUserId;

  const searchCard({
    super.key,
    required this.username,
    required this.userImage,
    required this.userId,
    required this.ownUserId,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(left: 12),
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => ownUserId == userId ? const ProfileNav() : OtherProfile(userId: userId),
                      settings: ownUserId == userId ? RouteSettings(name: '/viewProfile') : RouteSettings(name: ''),
                  ));
            },
            child: Row(
              children: [
                ClipOval(
                  child: userImage != 'null' && userImage.isNotEmpty
                  ? Image.network(
                    'http://54.254.8.87:3000/media?media_id=$userImage',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ): Image.asset('image/logo.png',
                  width: 60,
                  height: 60),
                ),
                /* CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(userImage),
                ), */
                const SizedBox(width: 1),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => ownUserId.toString() == userId.toString() ? const ProfileNav() : OtherProfile(userId: userId),
                      settings: ownUserId.toString() == userId.toString() ? RouteSettings(name: '/viewProfile') : RouteSettings(name: ''),
                  ));
                  },
                  child: Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor
                      ),
                  )
                  )

              ],
            ),
          ),
        ],
      ),
    );
  }
}