import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myakinator/util/app_keys.dart';
import 'package:myakinator/widget/chat_form_field.dart';
import 'package:myakinator/widget/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GenerativeModel model;
  late ChatSession _chatSession;
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;
  late bool _isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    // setup the model
    model = GenerativeModel(model: geminiModel, apiKey: apiKey);
    // start the chart session

    _chatSession = model.startChat(history: [
      Content.text(
          'Lets play the Akinator game. You be the Akinator who asks yes or no type of questions one by one to guess the person or a thing in the user mind. Users responses with only answers - yes, probably or no'),
      Content.model([TextPart('Sure. Let us start the game. Is it a person ?')])
    ]);
    // initializeChatBot();
    // build(context);
    _isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyAkinator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return const SizedBox.shrink();
            } else {
              var content = _chatSession.history.toList()[index];
              final message = getMessage(content);

              return MessageWidget(
                  message: message, isFromUser: content.role == 'user');
            }
          },
          itemCount: _chatSession.history.length,
          controller: _scrollController,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                  flex: 3,
                  child: Form(
                    key: _formKey,
                    child: ChatFormField(
                      controller: _textEditingController,
                      onFieldSubmitted: onFieldSubmitted,
                      focusNode: _focusNode,
                      isReadOnly: _isLoading,
                    ),
                  )),
              const SizedBox(
                width: 8.0,
              ),
              if (!_isLoading) ...[
                ElevatedButton(
                    onPressed: () {
                      onFieldSubmitted(_textEditingController.text);
                    },
                    child: const Text('Send'))
              ] else ...[
                const CircularProgressIndicator.adaptive()
              ],
            ],
          ),
        ),
      ),
    );
  }

  String getMessage(Content content) {
    var text = content.parts.whereType<TextPart>().map((e) => e.text).join('');
    return text;
  }

  Future<void> onFieldSubmitted(String message) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await _chatSession.sendMessage(Content.text(message));
      final text = response.text;
      if (text == null) {
        showError("No response was received");
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
      }
    } catch (e) {
      showError(e.toString());
      setState(() {
        _isLoading = false;
      });
    } finally {
      _textEditingController.clear();
      _focusNode.requestFocus();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            scrollable: true,
            content: SingleChildScrollView(
              child: Text(message),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ok'))
            ],
          );
        });
  }
}
