import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/components/bottomNavigatioon.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/post_management/create_post_bloc.dart';
import 'package:loop/post_management/create_post_event.dart';
import 'package:loop/post_management/create_post_state.dart';
import 'package:loop/post_management/post_repo.dart';
import 'package:mime/mime.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final PostRepository postRepository = PostRepository();
  bool status = true;


  Widget _statusField(){

    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Column(
          children: [
            RadioListTile<bool>(  
              title: const Text('Looking for artist'),        
              value: false, 
              groupValue: status, 
              onChanged: (bool? st) {
                setState(() {
                  status = st!;
                });
                 context.read<CreatePostBloc>().add(PostStatusChanged(status: false));

              },
            ),

            RadioListTile<bool>(  
              title: const Text('Upcycled by me'),        
              value: true, 
              groupValue: status, 
              onChanged: (bool? st) {
                setState(() {
                  status = st!;
                });
                context.read<CreatePostBloc>().add(PostStatusChanged(status: true));
              },
            ),
          ],
        );
      },
    );
  }

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

  Widget _beforePhotoButton() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return SizedBox(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              // backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Transform.rotate(
              angle: 45 * 3.1427 / 180,
              child:
                  const Icon(Icons.attach_file, color: AppColors.primaryColor),
            ),
            onPressed: () async {
              final ImagePicker imagePicker = ImagePicker();
              final pickedFile =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                context
                    .read<CreatePostBloc>()
                    .add(BeforePhotoChanged(beforePhoto: pickedFile));
              }
            },
            label: const Text(
              "Attach",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _afterPhotoButton() {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return SizedBox(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              // backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Transform.rotate(
              angle: 45 * 3.1427 / 180,
              child:
                  const Icon(Icons.attach_file, color: AppColors.primaryColor),
            ),
            onPressed: () async {
              final ImagePicker imagePicker = ImagePicker();
              final pickedFile =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                context
                    .read<CreatePostBloc>()
                    .add(AfterPhotoChanged(afterPhoto: pickedFile));
              }
            },
            label: const Text(
              "Attach",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
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
              if (_formKey.currentState!.validate()) {
                // ignore: use_build_context_synchronously
                context.read<CreatePostBloc>().add(PostSubmitted());
                Fluttertoast.showToast(
                    msg:
                        state.errorMessage == '' ? "Post Created Successfully" : state.errorMessage,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    webPosition: "center",
                    webBgColor: '#B8BF7B',
                    timeInSecForIosWeb: 1,
                    backgroundColor: state.errorMessage == ''
                        ? AppColors.tertiaryColor
                        : AppColors.warningColor,
                    textColor: state.errorMessage == ''
                        ? AppColors.backgroundColor
                        : AppColors.textColor,
                    fontSize: 16.0);

                if (state.errorMessage == '') {
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
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 17,
                fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _statusField(),

                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                      padding: EdgeInsets.only(left: 10.0, top: 10),
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
                      padding: EdgeInsets.only(left: 10.0, top: 10),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Upload Original Product Photo",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Row(children: [
                      _beforePhotoButton(),
                    ]),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Upload Reference or ‘After’ Product Photo",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Row(children: [_afterPhotoButton()]),
                     Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: _postButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
