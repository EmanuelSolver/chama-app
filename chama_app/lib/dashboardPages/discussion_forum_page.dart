import 'package:flutter/material.dart';

class DiscussionForumPage extends StatefulWidget {
  @override
  _DiscussionForumPageState createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  List<Map<String, String>> topics = [
    {'title': 'Monthly Meeting Updates', 'author': 'Alice', 'time': '2h ago'},
    {'title': 'Savings Goal for 2024', 'author': 'John', 'time': '1d ago'},
    {'title': 'Loan Policy Discussion', 'author': 'Sarah', 'time': '3d ago'},
    {'title': 'Suggestions for Group Growth', 'author': 'Mike', 'time': '1w ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Forum'),
        backgroundColor: Colors.green,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return _buildTopicCard(topics[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create new topic page
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
        tooltip: 'Start a New Discussion',
      ),
    );
  }

  Widget _buildTopicCard(Map<String, String> topic) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade400,
          child: Text(topic['author']![0], style: TextStyle(color: Colors.white)),
        ),
        title: Text(
          topic['title']!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('by ${topic['author']} • ${topic['time']}'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to detailed discussion
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiscussionDetailPage(topic: topic['title']!),
            ),
          );
        },
      ),
    );
  }
}

class DiscussionDetailPage extends StatelessWidget {
  final String topic;

  DiscussionDetailPage({required this.topic});

  final List<Map<String, String>> posts = [
    {'author': 'Alice', 'message': 'What are the savings goals for next year?', 'time': '2h ago'},
    {'author': 'John', 'message': 'We are aiming for a 20% increase in savings.', 'time': '1h ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(posts[index]);
              },
            ),
          ),
          _buildReplyInput(),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, String> post) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  child: Text(post['author']![0], style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Text(post['author']!, style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(post['time']!, style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(post['message']!),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green),
            onPressed: () {
              // Send the reply
            },
          ),
        ],
      ),
    );
  }
}
