import 'package:flutter/material.dart';

class SignalementPage extends StatelessWidget {
  const SignalementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(""),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
