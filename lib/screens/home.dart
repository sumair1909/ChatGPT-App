import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import '../components/chat_message.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _textEditingController;
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;
  bool _isTyping = false;
  void _sendMessage() {
    ChatMessage message =
        ChatMessage(text: _textEditingController.text, sender: "user");

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _textEditingController.clear();

    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder("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",
            orgId: "org-gW7OitLCtNnphE5sMlyvyNLC")
        .onCompleteStream(request: request)
        .listen((response) {
      ChatMessage botMessage =
          ChatMessage(text: response!.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();

    chatGPT = ChatGPT.instance;
    chatGPT!.builder("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",
        orgId: "org-gW7OitLCtNnphE5sMlyvyNLC");
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("J.A.R.V.I.S"),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _messages.clear();
                    _isTyping = false;
                  });
                },
                child: const Text("Clear")),
          ))
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
                  itemCount: _messages.length,
                  physics: const ClampingScrollPhysics(),
                  reverse: true,
                  //   padding: EdgeInsets.fromLTRB(70, 0, 70, 10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: _messages[index],
                    );
                  })),
          if (_isTyping) const Text("J.A.R.V.I.S is typing..."),
          const Divider(
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              color: Colors.white,
              //  decoration: BoxDecoration(),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) => _sendMessage(),
                      decoration: const InputDecoration.collapsed(
                          hintText: "Ask me anything!"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
