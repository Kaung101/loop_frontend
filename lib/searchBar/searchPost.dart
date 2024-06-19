import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/colors.dart'; // Update with your actual import path

class SearchPost extends StatefulWidget {
  final String searchQuery;

  const SearchPost({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  final AuthRepository authRepository = AuthRepository();

  Future<List<Map<String, dynamic>>> getAllPosts(String searchQuery) async {
    final postCardList = await authRepository.fetchPosts(searchQuery);
    print(postCardList);
    print('PostCardList');
    try {
      return postCardList.map((card) => {
        'username': card['user_name'] ?? '', 
        'userImage': card['userImage'] ?? '',
        'postImageOne': 'http://localhost:3000/media?media_id=${card['original_photo'] ?? ''}', 
        'postImageTwo': 'http://localhost:3000/media?media_id=${card['reference_photo'] ?? ''}',        
        'status': card['artist_post'] ? "Upcycled by me" : "Looking for artist",
        'productName': card['name'] ?? '',
        'productPrice': card['price'] ?? '',
        'description': card['description'] ?? '',
      }).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getAllPosts(widget.searchQuery),
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
              print('search post');
              print(snapshot.data![index]);

              /* final post = snapshot.data![index];
              return ListTile(
                title: Text(post['title']),
                subtitle: Text(post['content']),
              ); */
              return PostWidget(
                username: snapshot.data![index]['username'] ?? '', 
                userImage: snapshot.data![index]['profileImage'] ?? '', 
                postImageOne: snapshot.data![index] ['postImageOne'] ?? '', 
                postImageTwo: snapshot.data![index]['postImageTwo'] ?? '', 
                status: snapshot.data![index]['status'] ?? '', 
                productName: snapshot.data![index]['productName'] ?? '', 
                productPrice: snapshot.data![index]['productPrice'] ?? '', 
                description: snapshot.data![index]['description'] ?? '',
          );
          },
          );
        }
      },
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
                  ClipOval(
                      child: userImage != 'null' && userImage.isNotEmpty
                        ? Image.network(
                           'http://localhost:3000/media?media_id=$userImage',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Image.asset('image/logo.png', width: 60, height: 60),
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