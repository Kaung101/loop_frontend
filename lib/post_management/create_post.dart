import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/bottomNavigatioon.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/post_management/create_post_bloc.dart';
import 'package:loop/post_management/create_post_event.dart';
import 'package:loop/post_management/create_post_state.dart';
import 'package:loop/post_management/post_repo.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final PostRepository postRepository = PostRepository();
  String errormsg = '';
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  Uint8List? _beforePhoto;
  Uint8List? _afterPhoto;

  Widget _nameField() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
      return SingleChildScrollView(
        child: TextFormField(
          decoration: InputDecoration(
              fillColor: AppColors.backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          onChanged: (value) => context
              .read<CreatePostBloc>()
              .add(CreatePostNameChanged(name: value)),
        ),
      );
    });
  }

  Widget _priceField() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
      return SingleChildScrollView(
        child: TextFormField(
          decoration: InputDecoration(
              fillColor: AppColors.backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          onChanged: (value) => context
              .read<CreatePostBloc>()
              .add(CreatePostPriceChanged(price: value)),
        ),
      );
    });
  }

  Widget _descField() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
      return SingleChildScrollView(
        child: TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
              fillColor: AppColors.backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          onChanged: (value) => context
              .read<CreatePostBloc>()
              .add(CreatePostDescChanged(description: value)),
        ),
      );
    });
  }

  Widget _postButton() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return SizedBox(
          width: 160.0,
          height: 40.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              errormsg = await postRepository.createPost(
                  name: state.name,
                  price: state.price,
                  description: state.description);
              if (_formKey.currentState!.validate()) {
                // ignore: use_build_context_synchronously
                context.read<CreatePostBloc>().add(PostSubmitted());
                Fluttertoast.showToast(
                    msg:
                        errormsg == '' ? "Post Created Successfully" : errormsg,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    webPosition: "center",
                    webBgColor: '#B8BF7B',
                    timeInSecForIosWeb: 1,
                    backgroundColor: errormsg == '' ? AppColors.tertiaryColor : AppColors.warningColor,
                    textColor: errormsg == '' ? AppColors.backgroundColor : AppColors.textColor,
                    fontSize: 16.0);

                if (errormsg == '') {
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepositoryProvider(
                          create: (context) => AuthRepository(),
                          child: const BottomNav(),
                        ),
                      ),
                    );
                  });
                }
              }
            },
            child: const Text(
              "Post",
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: AppColors.textColor),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BottomNav(),
                ),
              );
            },
          ),
          title: const Align(
            alignment: Alignment.topLeft,
            child: Text('Create Post'),
          ),
        ),
        body: BlocProvider(
          create: (_) => CreatePostBloc(postRepo: postRepository),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(top: 200),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Product Name",
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.textColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      _nameField(),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Estimate Price",
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.textColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      _priceField(),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.textColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      _descField(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: _postButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
