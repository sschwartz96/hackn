import 'dart:convert';

import 'package:http/http.dart' as http;

const topStoriesURL = "https://hacker-news.firebaseio.com/v0/topstories.json";

Future<List<int>> fetchTopNews() async {
  final resp = await http.get(Uri.parse(topStoriesURL));
  final List<dynamic> data = jsonDecode(resp.body);
  final List<int> convertedData = data.map((e) => e as int).toList();
  return Future.value(convertedData);
}
