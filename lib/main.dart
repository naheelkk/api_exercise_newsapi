import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:news_app/consts.dart';
import 'package:news_app/models/article.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Article> articles = [];

  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Example'),
        ),
        body: _buildUi(),
      ),
    );
  }

  Widget _buildUi() {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            onTap: () {
              _launchUrl(Uri.parse(article.url ?? "https://www.google.com"));
            },
            leading: Image.network(
              article.urlToImage ?? PLACEHOLDER_IMAGE_URL,
              height: 250,
              width: 100,
              fit: BoxFit.cover,
            ),
            title: Text(article.title ?? ""),
            subtitle: Text(article.publishedAt ?? ""),
          );
        });
  }

  Future _getNews() async {
    final res = await Dio()
        .get('https://newsapi.org/v2/top-headlines?country=us&apiKey=$API_KEY');
    final articleJson = res.data['articles'] as List;
    setState(() {
      List<Article> newsArticle =
          articleJson.map((e) => Article.fromJson(e)).toList();
      // print(articles);
      articles = newsArticle.where((element) => articles != "[Removed]").toList();
      articles = newsArticle;
    });
    // print(res);
  }

  Future _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
