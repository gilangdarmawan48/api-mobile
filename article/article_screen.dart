import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutorial_iu_dashboard/article/add_article.dart';
import 'package:http/http.dart' as http;
import 'package:tutorial_iu_dashboard/article/edit_article.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final String url = 'http://10.0.2.2:8000/api/articles';

  Future getArticles() async {
    var response = await http.get(Uri.parse(url));

    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteArticle(String articleId) async {
    var headers =
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMjcuMC4wLjE6ODAwMFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTY1NzAzMDA4NiwiZXhwIjoxNjU3MDMzNjg2LCJuYmYiOjE2NTcwMzAwODYsImp0aSI6IkV4SGZJQU9PV1BZTDlaeGgiLCJzdWIiOjEsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.OGw_HSiYBxLUJ4_WRBEfvRgbX9OD1w8Ry-NjriGetQ4';

    final String url = 'http://10.0.2.2:8000/api/articles/' + articleId;

    var response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': headers},
    );
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddArticle()));
          }),
      appBar: AppBar(title: Text("Halaman Article")),
      body: FutureBuilder(
          future: getArticles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as Map;
              return ListView.builder(
                itemCount: data['data'].length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 180,
                    child: Card(
                      elevation: 5,
                      child: Row(children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  data['data'][index]['title'],
                                  style: const TextStyle(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(data['data'][index]['body']),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditArticle(
                                                  article: data['data']
                                                      [index])));
                                    },
                                    child: Icon(Icons.edit),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      deleteArticle(data['data'][index]['id']
                                              .toString())
                                          .then((value) {
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Article berhasil di hapus")));
                                      });
                                    },
                                    child: Icon(Icons.delete),
                                  )
                                ],
                              )
                            ],
                          ),
                        ))
                      ]),
                    ),
                  );
                },
              );
            } else {
              return Text("Data error");
            }
          }),
    );
  }
}
