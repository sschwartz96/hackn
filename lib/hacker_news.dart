import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HNClient {
  static const _topStoriesURL =
      "https://hacker-news.firebaseio.com/v0/topstories.json";
  static const _itemURL =
      "https://hacker-news.firebaseio.com/v0/item/"; // have to add *1234*.json to end

  Future<List<int>> fetchTopNewsIDs(bool forceRefresh) async {
    final resp = await http.get(Uri.parse(_topStoriesURL));
    final List<dynamic> data = jsonDecode(resp.body);
    final List<int> convertedData = data.map((e) => e as int).toList();
    // return Future.value(convertedData);
    final oneStory = convertedData.sublist(0, 20);
    return oneStory;
  }

  Future<List<Item>> fetchTopNewsItems() async {
    final ids = await fetchTopNewsIDs(true);
    List<String> itemJSONStrings = List.filled(ids.length, '');
    for (int i = 0; i < ids.length; i++) {
      final iURL = _itemURL + ids[i].toString() + '.json';
      final resp = await http.get(Uri.parse(iURL));
      itemJSONStrings[i] = resp.body;
    }
    return compute(jsonStringsToItems, itemJSONStrings);
    //return _jsonStringsToItems(itemJSONStrings);
  }
}

List<Item> jsonStringsToItems(List<String> jsonStrings) {
  List<Item> items = List<Item>.empty(growable: true);
  for (int i = 0; i < jsonStrings.length; i++) {
    items.add(Item.fromJson(jsonDecode(jsonStrings[i])));
  }
  return items;
}

class Item {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final int poll;
  final List<int> kids;
  final String url;
  final int score;
  final String title;
  final List<int> parts;
  final int descendants;

  Item(
    this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants,
  );

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        deleted = json['deleted'] ?? false,
        type = json['type'] ?? '',
        by = json['by'] ?? '',
        time = json['time'] ?? 0,
        text = json['text'] ?? '',
        dead = json['dead'] ?? false,
        parent = json['parent'] ?? 0,
        poll = json['poll'] ?? 0,
        kids = (json['kids'] != null)
            ? List<int>.from(json['kids'])
            : List<int>.empty(),
        url = json['url'] ?? '',
        score = json['score'] ?? 0,
        title = json['title'] ?? '',
        parts = (json['parts'] != null)
            ? List<int>.from(json['parts'])
            : List<int>.empty(),
        descendants = json['descendants'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'deleted': deleted,
        'type': type,
        'by': by,
        'time': time,
        'text': text,
        'dead': dead,
        'parent': parent,
        'poll': poll,
        'kids': kids,
        'url': url,
        'score': score,
        'title': title,
        'parts': parts,
        'decendants': descendants,
      };
}

class User {
  final String about;
  final int created;
  final int delay;
  final String id;
  final int karma;
  final List<int> submitted;

  User(
    this.about,
    this.created,
    this.delay,
    this.id,
    this.karma,
    this.submitted,
  );

  User.fromJson(Map<String, dynamic> json)
      : about = json['about'] ?? '',
        created = json['created'] ?? 0,
        delay = json['delay'] ?? 0,
        id = json['id'] ?? 0,
        karma = json['karma'] ?? 0,
        submitted = json['submitted'] != null
            ? List<int>.from(json['submitted'])
            : List<int>.empty();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['created'] = this.created;
    data['delay'] = this.delay;
    data['id'] = this.id;
    data['karma'] = this.karma;
    data['submitted'] = this.submitted;
    return data;
  }
}
