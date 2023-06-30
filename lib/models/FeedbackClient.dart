import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackClient {
  String date;
  String description;
  int typeOfComplaintId;
  int shipmentId;

  FeedbackClient({
    required this.date,
    required this.description,
    required this.typeOfComplaintId,
    required this.shipmentId,
  });


  Map<String,dynamic> toMap(){
    return {
      'date': date,
      'description': description,
      'typeOfComplaintId': typeOfComplaintId,
      'shipmentId': shipmentId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'description': description,
      'typeOfComplaintId': typeOfComplaintId,
      'shipmentId': shipmentId,
    };
  }
}