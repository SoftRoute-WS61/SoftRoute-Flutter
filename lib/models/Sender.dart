import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sender{
  final int id;
  final String name;
  final String email;

  Sender({
    required this.id,
    required this.name,
    required this.email
});

  Map<String,dynamic> toMap(){
    return{
      'id':(id==0)? null: id,
      'name':name,
      'email':email
    };
  }
}