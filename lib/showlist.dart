import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/searchBar/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthRepository authRepository = AuthRepository();
  
  //get all post future method and return post data
  Future<List<dynamic>> getAllPost() async {
    final postList = await authRepository.fetchAllPost();
    return postList.map((post) => PostWidget(
      username: post['user_name'],
      userImage: (post['user_img'] != null )? post['user_img'] : 'image/logo.png', // Replace with actual data if available
      postImageOne: 'http://localhost:3000/media?media_id=${post['original_photo']}', // Replace with actual data if available
      postImageTwo: 'http://localhost:3000/media?media_id=${post['reference_photo']}', // Replace with actual data if available
      status: 'Looking for artist', // Replace with actual data if available
      productName: post['name'],
      productPrice: post['price'],
      description: post['description'],
    )).toList();
  }

  //get 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: Container(
          margin: const EdgeInsets.only(top: 1.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundColor),
                    elevation: MaterialStateProperty.all(0),
                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //   RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //   ),
                    // ),
                  ),
                  onPressed: () {

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const searchScreen(),
                                  settings: const RouteSettings(name: '/changePw'),
                                ),
                              );
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
            style: const TextStyle(color: AppColors.textColor),
            cursorColor: AppColors.textColor,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getAllPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index];
              },
            );
          }
        },
      ),
    );
  }
}
class PostWidget extends StatelessWidget {
  //final String postId;
  //final String userId;
  final String username;
  final String userImage;
  final String postImageOne;
  final String postImageTwo;
  final String status;
  final String productName;
  final String productPrice;
  final String description;

  const PostWidget({
    super.key, 
    //required this.postId,
   // required this.userId,
    required this.username,
    required this.userImage,
    required this.postImageOne,
    required this.postImageTwo,
    required this.status,
    required this.productName,
    required this.productPrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: AppColors.textColor, width: 1.0), // Set border color and width
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(userImage),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                  style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.transparent;
                      }
                      if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                    onPressed: (){

                    },
                     child: Text(
                    username,
                    style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textColor
                    ),
                  ),
                    )

                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image.network(
                          postImageOne,
                          height: 100,
                        ),
                        Text('Original Product'),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Image.network(
                          postImageTwo,
                          height: 100,
                        ),
                        Text('Reference'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• $status'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• $productName'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• $productPrice ฿'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• $description',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
