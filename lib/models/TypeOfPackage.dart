import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TypeOfPackage{
  final String name;
  final int id;

  TypeOfPackage({
    required this.name,
    required this.id
});
}