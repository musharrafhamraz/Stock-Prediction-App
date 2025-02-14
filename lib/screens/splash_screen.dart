import 'package:chatbot/screens/class_selection.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClassSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: Stack(
        children: [
          /// Background Gradient for a colorful look
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Centered Animation and Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🎥 School-Themed Lottie Animation (Replace with your JSON file)
                Lottie.asset(
                  'lib/assets/school_splash.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 20),

                /// 🏫 App Title with Cool Font
                Text(
                  'School ChatBot',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black38,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                /// 📖 Tagline
                Text(
                  'Your AI study buddy!',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          /// 📎 Loading Indicator
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
