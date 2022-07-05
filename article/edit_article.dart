import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:tutorial_iu_dashboard/article/article_screen.dart';

class EditArticle extends StatelessWidget {
  // const EditArticle({Key? key}) : super(key: key);

  final Map article;

  EditArticle({Key? key, required this.article}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  Future updateArticle() async {
    var headers =
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMjcuMC4wLjE6ODAwMFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTY1NzAzMDA4NiwiZXhwIjoxNjU3MDMzNjg2LCJuYmYiOjE2NTcwMzAwODYsImp0aSI6IkV4SGZJQU9PV1BZTDlaeGgiLCJzdWIiOjEsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.OGw_HSiYBxLUJ4_WRBEfvRgbX9OD1w8Ry-NjriGetQ4';
    final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8000/api/articles/' + article['id'].toString()),
        headers: {
          'Authorization': headers
        },
        body: {
          "title": _titleController.text,
          "body": _bodyController.text,
        });

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Article")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController..text = article['title'],
              decoration: InputDecoration(labelText: "Title"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title is Required";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _bodyController..text = article['body'],
              decoration: InputDecoration(labelText: "Body"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Body is Required";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateArticle().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticleScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Article berhasil di ubah")));
                    });
                  }
                },
                child: Text("Update Article"))
          ],
        ),
      ),
    );
  }
}
