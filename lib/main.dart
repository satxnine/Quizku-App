import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as myHttp;
import 'package:quizapp/model/question_model.dart';
import 'package:quizapp/result_page.dart';
import 'package:quizapp/test_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Datum> questionList = [];
  TextEditingController usernameController = TextEditingController();

  Future<void> getAllData(String username) async {
    try {
      var response = await myHttp.get(Uri.parse(
          "https://script.google.com/macros/s/AKfycbyWXUJO8gS1mGDn9igHnpnTX-e0OEExG7R5xavubveBFVB-DF7lY-aao29DOloBtziM/exec"));
      Welcome welcome = Welcome.fromJson(json.decode(response.body));

      questionList = welcome.data;

      print('Question List Length: ' + questionList.length.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestPage(
            questionList: questionList,
            username: username,
          ),
        ),
      ).then((value) {
        setState(() {});
      });
    } catch (err) {
      print('Error: ' + err.toString());
    }
  }

  void startQuiz() {
    String username = usernameController.text.trim();

    if (username.isNotEmpty) {
      getAllData(username);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Username harus diisi!'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "QUIZku",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Masukkan username",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: startQuiz,
                  child: Text("MULAI"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
