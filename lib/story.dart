import 'package:flutter/material.dart';
import 'package:hackn/hacker_news.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments.dart';

final baseURLMap = {};
final timeAgoMap = {};

class StoryTile extends StatelessWidget {
  final Item item;
  final bool isComment;

  const StoryTile({Key? key, required this.item, required this.isComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _launchURL(item.url),
      contentPadding: const EdgeInsets.only(left: 12, right: 12),
      title: Text('${item.title}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            _getBaseURL(item.url),
            style: TextStyle(color: const Color(0xff1698A0)),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                child: Text(_getTimeAgo(item.time)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: const Text('|'),
              ),
              TextButton(
                onPressed: () => print('pressing by: ${item.by}'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(8.0),
                  minimumSize: Size.zero,
                ),
                child: Text('${item.by.trim()}',
                    style: const TextStyle(color: Colors.grey)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: const Text('|'),
              ),
              TextButton.icon(
                onPressed: () => print('pressed upvote on ${item.title}'),
                icon: Icon(
                  Icons.arrow_upward,
                  color: Colors.grey,
                  size: 16,
                ),
                label: Text(
                  '${item.score}',
                  style: const TextStyle(color: Colors.grey),
                ),
                style: TextButton.styleFrom(),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: const Text('|'),
              ),
              InkWell(
                onTap: () => isComment
                    ? null
                    : Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(id: item.id),
                        ),
                      ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(item.kids.length.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// get base url for a story
String _getBaseURL(String url) {
  if (baseURLMap.containsKey(url)) return baseURLMap[url];
  final baseURL = url
      .replaceFirst('https://', '')
      .replaceFirst('http://', '')
      .replaceFirst('www.', '')
      .split('/')[0];
  baseURLMap[url] = baseURL;
  return baseURL;
}

// get time ago for a story
String _getTimeAgo(int postedTime) {
  if (timeAgoMap.containsKey(postedTime)) return timeAgoMap[postedTime];
  String timeAgo;

  final delta = (DateTime.now().millisecondsSinceEpoch / 1000) - postedTime;
  const hour = 3600;
  const day = 86400;
  const year = 31536000;
  if (delta < hour) {
    final rounded = (delta / 60).round();
    timeAgo = '$rounded minute${rounded != 1 ? 's' : ''} ago';
  } else if (delta < day) {
    final rounded = (delta / 3600).round();
    timeAgo = '$rounded hour${rounded != 1 ? 's' : ''} ago';
  } else if (delta < year) {
    final rounded = (delta / day).round();
    timeAgo = '$rounded day${rounded != 1 ? 's' : ''} ago';
  } else {
    final rounded = (delta / year).round();
    timeAgo = '$rounded year${rounded != 1 ? 's' : ''} ago';
  }
  timeAgoMap[postedTime] = timeAgo;
  return timeAgo;
}

void _launchURL(String _url) async {
  await canLaunch(_url)
      ? await launch(_url)
      : showToast('Could not open up:' + _url);
}
