import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tamz/custom_button.dart';

class HttpTesting extends StatefulWidget {
  @override
  _HttpTestingState createState() => _HttpTestingState();
}

class _HttpTestingState extends State<HttpTesting> {
  final TextEditingController _urlController = TextEditingController()
    ..text = 'https://homel.vsb.cz/~mor03/TAMZ/TAMZ.php';
  final TextEditingController _loginController = TextEditingController();
  String token;
  String message;

  void requestToken() async {
    setState(() {
      message = null;
    });
    final res = await get('${_urlController.text}?${Uri(queryParameters: {
      'login': _loginController.text
    }).query}')
        .catchError((_) => null);
    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
      });
    }
  }

  void testToken() async {
    final res = await post(_urlController.text, headers: {
      'API-Token': base64Encode(utf8.encode('${_loginController.text}:$token'))
    });
    setState(() {
      message = res.body;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('HTTP testing'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: _urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              Text(message?.isNotEmpty ?? false
                  ? 'Received data: $message'
                  : token?.isNotEmpty ?? false
                      ? 'Received token: $token'
                      : 'Do a request first'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomButton(
                    text: 'Request token',
                    onPressed: token == null || (message?.isNotEmpty ?? false)
                        ? requestToken
                        : null,
                  ),
                  CustomButton(
                    text: 'Test token',
                    onPressed: token == null ? null : testToken,
                  )
                ],
              )
            ],
          ),
        )),
      );
}
