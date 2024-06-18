import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/colors.dart';

class searchList extends StatefulWidget {
  //const searchList({super.key});
    //const searchList({super.key, required this.searchQuery});
    const searchList({Key? key, required this.searchQuery})
      : super(key: key);
          
      final String searchQuery;


  @override
  State<searchList> createState() => _searchListState();
}

class _searchListState extends State<searchList> {

    final AuthRepository authRepository = AuthRepository();
    late String searchQuery = ''; // Define the searchQuery state variable

  /*    Future<List<Map<String, dynamic>>> getAllUsers(String searchQuery) async {
    try {
      return await authRepository.fetchUsers( 'http://localhost:3000',  searchQuery: searchQuery);
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  } */

  Future<List<Map<String, dynamic>>> getAllUsers(String searchQuery) async {
    try {
      return await authRepository.fetchUsers(searchQuery);
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
              final user = snapshot.data![index];
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
              );
            },
          );
        }
      },
    );
  }
  /* Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllUsers(searchQuery),
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
                final user = snapshot.data![index];
                return /* ListTile(
                  title: Text(user['username']),
                  subtitle: Text(user['email']),
                  // Customize as needed based on your user data structure
                ); */
                Row(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.image),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.77,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(myData.sDate),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(myData.eDate),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(myData.carName),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border:
                                          Border.all(color: AppColors.textColor)),
                                  child: Text(myData.lNumber),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: AppColors.backgroundColor,
                                    ),
                                  ),
                                  child: Text(
                                    myData.status,
                                    style:
                                        const TextStyle(color: AppColors.textColor),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            const Divider(
                              color: AppColors.textColor,
                            )
                          ],
                        ),
                      ),
                    ],
                );
              },
            );
          } 


         /*  if (snapshot.hasData) {
            List<RentalsModel> data = snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var myData = data[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(myData.image),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.77,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myData.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            sizedBox5,
                            Row(
                              children: [
                                Text(myData.sDate),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(myData.eDate),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            sizedBox5,
                            Text(myData.carName),
                            sizedBox10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border:
                                          Border.all(color: gOffBlack)),
                                  child: Text(myData.lNumber),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: gOffWhite,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: gOffWhite,
                                    ),
                                  ),
                                  child: Text(
                                    myData.status,
                                    style:
                                        const TextStyle(color: gOffBlack),
                                  ),
                                ),
                              ],
                            ),
                            sizedBox10,
                            const Divider(
                              color: gOffBlack,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          } */
        },
      ),
    );
  } */
}