import 'package:flutter/material.dart';
import 'package:hackn/hacker_news.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments.dart';

class StoryTile extends StatelessWidget {
  final Item item;
  final bool isComment;

  const StoryTile({Key? key, required this.item, required this.isComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _launchURL(item.url),
      contentPadding: EdgeInsets.only(left: 12, right: 12),
      title: Text('${item.title}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 4),
          Text(
            _getBaseURL(item.url),
            style: TextStyle(color: Color(0xff1698A0)),
          ),
          Container(height: 6),
          Row(
            children: [
              Text(_getTimeAgo(item.time)),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text(' | '),
              ),
              TextButton(
                onPressed: () => print('pressing by: ${item.by}'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size(0, 0),
                ),
                child: Text('${item.by.trim()}',
                    style: TextStyle(color: Colors.grey)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text(' | '),
              ),
              InkWell(
                onTap: () {
                  print('pressing score: ${item.title}');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(item.score.toString() + ' '),
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text(' | '),
              ),
              InkWell(
                onTap: () => isComment
                    ? null
                    : Navigator.of(context).push(_commentRoute(item.id)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(item.kids.length.toString() + ' '),
                    Icon(
                      Icons.comment,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _getBaseURL(String url) {
  return url
      .replaceFirst('https://', '')
      .replaceFirst('http://', '')
      .replaceFirst('www.', '')
      .split('/')[0];
}

String _getTimeAgo(int postedTime) {
  final delta = (DateTime.now().millisecondsSinceEpoch / 1000) - postedTime;
  const hour = 3600;
  const day = 86400;
  const year = 31536000;
  if (delta < hour) {
    final rounded = (delta / 60).round();
    return '$rounded minute${rounded != 1 ? 's' : ''} ago';
  } else if (delta < day) {
    final rounded = (delta / 3600).round();
    return '$rounded hour${rounded != 1 ? 's' : ''} ago';
  } else if (delta < year) {
    final rounded = (delta / day).round();
    return '$rounded day${rounded != 1 ? 's' : ''} ago';
  }
  final rounded = (delta / year).round();
  return '$rounded year${rounded != 1 ? 's' : ''} ago';
}

void _launchURL(String _url) async {
  await canLaunch(_url)
      ? await launch(_url)
      : showToast('Could not open up:' + _url);
}

Route _commentRoute(int id) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CommentsPage(id: id),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
