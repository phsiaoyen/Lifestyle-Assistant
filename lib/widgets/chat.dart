//import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bubble/bubble.dart';
import 'package:test_dart/main.dart';


class NewPage extends StatefulWidget {
  const NewPage({required this.history, super.key});
  final List<String> history;
  
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  String character='';
  
  String _userInput = '';
  late List<String> _chatHistory;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatHistory = widget.history;
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 30),
      curve: Curves.easeOut,
    );
  });
  }

  void changerobot(){
    setState(() {
      if(robotnum==1)
      {
        character='Act as an assistant who likes simplified answer';
      }
      else if(robotnum==2)
      {
        character='Act as a vulgar, bad assistant who say bad words often';
      }
      else
      {
        character='Act as a cat, viewing the user as the litter box officer.';
      }
    });
  }

  void getChatResponse() async {
    changerobot();
    if(_userInput.isEmpty) return;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNzc5NGU3NmQtMzgxMi00MzI0LWI2NWUtOTIwYzhiODIwMWE4IiwidHlwZSI6ImFwaV90b2tlbiJ9.bUzUl3I9DPqgSBl-ku3DbgnJjCEGbOuI41QEmoHPk-c',//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiOTYzYWE3YTItZTRhNy00NzNjLTkzMDUtMWU1ZjU2ZDY5MDkxIiwidHlwZSI6ImFwaV90b2tlbiJ9.SryJ_WqmKguxy5jVJTrsrb-zJFbcHuHW9KZ9dSwOr1A',
    };

    var url = Uri.parse('https://api.edenai.run/v2/text/chat');

    var payload = {
      'providers': 'openai',
      'text': _userInput,
      //'chatbot_global_action': 'Act as an angry assistant',
      //'chatbot_global_action': 'Act as a servant of a princess',
      //'chatbot_global_action': 'Act as a vulgar, bad assistant',
      //'chatbot_global_action': 'Act as an sweet heart',
      //'chatbot_global_action': 'Act as a cat, viewing the user as the litter box officer.',
      //'chatbot_global_action': 'Act as an assistant who likes simplified answer',
      'chatbot_global_action':character,
      'previous_history': [
        ..._chatHistory.map((chat) {
          var parts = chat.split(': ');
          return {
            'role': parts[0].toLowerCase(),
            'message': parts[1],
          };
        }).toList(),
        {
          'role': 'user',
          'message':
              'I want to become healthier.'
              'I weight ${weightnow.toString()} kg. My goal weight is ${idealweight.toString()}kg. '
              'This week, between vegetable, milk, fruit, meet, rice, I ate $lackfood the least.'
              'But only give me these information only when I ask you'
              'No repeat information',
              //'Always answer me in less than 70 words',
        }
      ],
      'temperature': 0.0,
      'max_tokens': 150,
      'fallback_providers': ''
    };

    var response = await http.post(url, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        _chatHistory.add('User: $_userInput\nBot: ${result['openai']['generated_text']}');
        _userInput = '';
        _controller.clear();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

    } else {
      setState(() {
        _chatHistory.add('Request failed with status: ${response.statusCode}.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                var parts = _chatHistory[index].split('\n');
                var isUser = parts[0].startsWith('User');
                return Column(
                    children: [
                      const SizedBox(height: 10),
                      Bubble(
                        alignment: Alignment.topRight,
                        color: Colors.grey[200],
                        margin: const BubbleEdges.only(right: 15, left: 30),
                        child: Text(parts[0].substring(5)), // Display user's question
                      ),
                      const SizedBox(height: 15),
                      Bubble(
                          alignment: Alignment.topLeft,
                          color: Colors.blue[200],
                          margin: const BubbleEdges.only(right: 30, left: 15),
                          child: Text(parts[1].substring(5)), // Display bot's answer
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                _userInput = value;
              },
              onSubmitted: (value) {
                getChatResponse();
              },
              decoration: const InputDecoration(
                labelText: 'Enter your message',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
            child: ElevatedButton(
              onPressed: getChatResponse,
              child: const Text('Send message'),
            ),
          ),
        ],
      ),
    );
  }
}