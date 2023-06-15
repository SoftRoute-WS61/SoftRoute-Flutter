import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DocumentType{
  final int id;
  final String name;

  DocumentType({
    required this.id,
    required this.name
});
}