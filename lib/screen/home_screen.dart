import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myakinator/screen/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyAkinator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.tryParse('350'),
              decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: const Text(
                "Welcome to MyAkinator App. Akinator tries to guess the thing in your mind. You just have to answer yes or no for the questions it asks.\n  Get ready to experience the Genie!!",
                style: TextStyle(
                  color: Colors.white,
                  wordSpacing: 5,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                child: const Text("Lets Play"))
          ],
        ),
      ),
    );
  }
}
