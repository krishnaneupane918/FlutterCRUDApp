import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final dio = Dio();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final avatarController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Blog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration:
                InputDecoration(labelText: 'name', hintText: 'enter name'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'description'),
            maxLines: 3,
          ),
          TextFormField(
            controller: avatarController,
            decoration: InputDecoration(labelText: 'avatar'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              var data = {
                "name": nameController.text,
                "description": descriptionController.text,
                "avatar": avatarController.text,
              };
              addData(data);
            },
            child: isLoading
                ? SizedBox(
                    // height: 20,
                    // width: 20,
                    child: CircularProgressIndicator(),
                  )
                : Text('Add')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'))
      ],
    );
  }

  void addData(Map blog) async {
    setState(() {
      isLoading = true;
    });
    var response = await dio
        .post('https://65d8a84dc96fbb24c1bc0a15.mockapi.io/api', data: blog);

    if (response.statusCode == 201) {
      Navigator.pop(context, response.data);
    }
  }
}
