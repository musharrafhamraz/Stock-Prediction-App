import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ClassSelectionScreen extends StatelessWidget {
  final List<int> classes =
      List.generate(10, (index) => index + 3); // Classes 3-12

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Class")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(classNumber: classes[index]),
                  ),
                );
              },
              child: Text('Class ${classes[index]}',
                  style: TextStyle(fontSize: 18)),
            );
          },
        ),
      ),
    );
  }
}
