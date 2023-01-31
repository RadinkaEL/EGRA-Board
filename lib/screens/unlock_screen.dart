import 'package:flutter/material.dart';

class UnlockScreen extends StatelessWidget {
  String enteredPin = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff343d52),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(child: Image.asset('assets/images/logo.jpg', height: 175,), borderRadius: BorderRadius.circular(25.0),),
              SizedBox(
                height: 20.0,
              ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: TextField(
                    maxLength: 6,
                    textAlign: TextAlign.center,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff5d6475),
                          hintText: 'Enter 6 digit PIN',
                      ),
                      onChanged: (value) {
                          enteredPin = value;
                      },
                      keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                    height: 20.0,
                ),
                ElevatedButton(
                    child: Text('Unlock'),
                    onPressed: () {
                        if (enteredPin == "210328") {
                            Navigator.pushNamed(context, '/home');
                        } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Incorrect PIN'),
                                        actions: <Widget>[
                                            TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                    Navigator.of(context).pop();
                                                },
                                            ),
                                        ],
                                    );
                                },
                            );
                        }
                    },
                ),
            ],
        ),
    );
  }
}