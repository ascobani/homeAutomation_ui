import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final textFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  labelText: "Enter IP Address",
  labelStyle: const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
  icon: const Icon(
    Icons.search,
    color: Colors.black,
    size: 30,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.black, width: 3),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.black, width: 3),
  ),
  filled: true,
  hintText: "Enter IP Address",
  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
);
final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.black54,
  foregroundColor: Colors.white,
  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
  shape: new RoundedRectangleBorder(
    borderRadius: new BorderRadius.circular(30.0),
  ),
);
