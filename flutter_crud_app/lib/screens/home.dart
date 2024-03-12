import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_app/screens/add.dart';
import 'package:flutter_crud_app/screens/delete.dart';
import 'package:flutter_crud_app/screens/edit.dart';
import 'package:flutter_crud_app/screens/single.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dio = Dio();
  bool isLoading = true;
  List<dynamic> blogs = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Flutter using MockAPI CRUD',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Color.fromARGB(255, 0, 101, 196),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];
                final id = blog["id"];
                final title = blog['name'];
                final avatar = blog['avatar'];
                final description = blog['description'];
                return ListTile(
                  onTap: () => navigateToNextPageId(id),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                  ),
                  title: Text(title),
                  subtitle: Text(
                    description,
                    maxLines: 3,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            var data = await showDialog(
                                context: context,
                                builder: (_) => EditBlog(blog));
                            if (data == null) return;
                            setState(() {
                              blogs.insert(0, blog);
                              // blogs.add(blog);
                            });
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () async {
                            var data = await showDialog(
                                context: context,
                                builder: (_) {
                                  return Delete(blog);
                                });
                            if (data == true) {
                              setState(() {
                                blogs.remove(blog);
                              });
                            }
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                );
              }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              var blog =
                  await showDialog(context: context, builder: (_) => AddBlog());
              if (blog == null) return;
              setState(() {
                blogs.insert(0, blog);
                // blogs.add(blog);
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void navigateToNextPageId(String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => SingleScreen(id)));
  }

  void getData() async {
    var response =
        await dio.get('https://65d8a84dc96fbb24c1bc0a15.mockapi.io/api');
    if (response.statusCode == 200) {
      setState(() {
        blogs = response.data;
        isLoading = false;
      });
    }
  }
}
