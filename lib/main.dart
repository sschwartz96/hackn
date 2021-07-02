import 'package:flutter/material.dart';
import 'hacker_news.dart' as hnClient;

void main() {
  runApp(HackNApp());
}

class HackNApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackN Hacker News Client',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FutureBuilder(
        future: hnClient.fetchTopNews(),
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.hasData) {
            return HomePage(title: 'Top Stories', topStories: snapshot.data!);
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          );
        },
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

  final List<int> topStories;
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
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.topStories.length,
      itemBuilder: (context, i) {
        return _buildRow(i);
      },
    );
  }

  Widget _buildRow(int i) {
    final id = widget.topStories[i];
    return Text('$id');
  }
}
