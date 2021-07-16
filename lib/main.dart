import 'package:flutter/material.dart';
import 'package:hackn/story.dart';
import 'package:oktoast/oktoast.dart';
import 'custom/list_divider.dart';
import 'hacker_news.dart';

void main() {
  HNClient hnClient = HNClient();
  runApp(HackNApp(hnClient));
}

class HackNApp extends StatelessWidget {
  final HNClient hnClient;

  HackNApp(this.hnClient);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'HackN Hacker News Client',
        theme: ThemeData(
          brightness: Brightness.dark,
          //scaffoldBackgroundColor: Color(0xff252323),
          primaryColor: Color(0xff252323),
          primarySwatch: Colors.teal,
        ),
        home: FutureBuilder<List<Item>>(
          future: hnClient.fetchTopNewsItems(),
          builder: (context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasData) {
              return HomePage(
                  title: 'Top Stories', topStories: snapshot.data ?? []);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.title,
    required this.topStories,
  }) : super(key: key);

  final List<Item> topStories;
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _showNews(),
    );
  }

  Widget _showNews() {
    return ListView.builder(
      // * 2 - 3 gives us length for dividers
      itemCount: widget.topStories.length * 2 - 1,
      itemBuilder: (context, i) {
        if (i % 2 == 0)
          return _buildRow((i ~/ 2));
        else
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: FancyLine(width: MediaQuery.of(context).size.width),
            ),
          );
      },
    );
  }

  Widget _buildRow(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: StoryTile(
        isComment: false,
        item: widget.topStories[i],
      ),
    );
  }
}
