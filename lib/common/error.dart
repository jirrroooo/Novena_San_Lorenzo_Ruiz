import 'dart:convert';

import 'package:flutter/material.dart';

Future<void> showError(BuildContext context, String error) async {
  Map<String, dynamic> data = {};
  String? title;
  String? description;

  try {
    data = jsonDecode(error);

    title = data['title'];
    description = data['description'];
  } catch (e) {
    title = null;
    description = null;
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // Background color for the sheet content
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0), bottom: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16.0),
          height: 300, // Set height for the bottom sheet
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "./assets/error.png",
                height: 60,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title == null || title == '' ? 'Unknown Error' : title,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                description == null || description == ''
                    ? "Unknown error occurred. Try again."
                    : description,
                style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  child: const Text(
                    "OKAY",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
