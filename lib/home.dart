import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FacebookLogo(),
        ),
      ),
    ),
  );
}

class FacebookLogo extends StatelessWidget {
  const FacebookLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 80.0,
            height: 80.0,
            color: Colors.white,
            child: Center(
              child: Text(
                'F',
                style: TextStyle(
                  fontSize: 64.0,
                  color: Colors.blue,
                 
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}