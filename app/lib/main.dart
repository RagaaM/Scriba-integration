// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

var ipUrl = "http://192.168.1.9:8003/image";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _imageFile;

  bool imageSelected = false;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Miu Session"),
      ),
      body: Center(
        child: imageSelected
            ? Image.file(File(_imageFile!.path))
            : const Text(
                'You have not yet picked an image.',
                textAlign: TextAlign.center,
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              try {
                final XFile? pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {
                  _imageFile = pickedFile;
                  imageSelected = true;
                });
              } catch (e) {
                print(e);
              }
            },
            child: const Icon(Icons.photo),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                try {
                  final bytes = File(_imageFile!.path).readAsBytesSync();
                  String img64 = base64Encode(bytes);
                  final Dio _dio = Dio();
                  _dio.post(
                    ipUrl,
                    data: {"image": img64},
                  ).then((value) {
                    print(value.data['status']);
                    if (value.data['status'] == "Image Opened") {
                      Fluttertoast.showToast(
                        msg: "Image Sent To Backend",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
