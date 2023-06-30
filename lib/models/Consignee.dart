import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Consignee{
  final int id;
  final String dni;
  final String address;
  final String name;

  Consignee({
    required this.id,
    required this.dni,
    required this.name,
    required this.address,
  });

  Map<String,dynamic> toMap(){
    return {
      'id':(id==0)? null: id,
      'dni':dni,
      'address':address,
      'name':name,
    };
  }

}