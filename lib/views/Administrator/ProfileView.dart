import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/Admin.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> getAdminInfo()async{
    String URL='http://40.67.144.113:8080/api/v1/admin';


    final url = Uri.parse(URL);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Admin> adminInfos = []; // Crear una lista de nombres de consignees
      for (var item in jsonData) {
        int id = item['id'];
        String name = item['name'];
        String lastName = item['lastName'];
        String email = item['email'];
        String password = item['password'];
        int phoneNumber = item['phoneNumber'];
        String code = item['code'];
        Admin adminInfo=Admin(id: id, name: name, lastName: lastName, email: email,password: password,phoneNumber: phoneNumber,code: code);
        adminInfos.add(adminInfo);
      }
    } else {
      print('Request failed with status: ${response.statusCode}');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage("https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre: JUlian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Age: 30 years old',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email address: julian.creep@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Edit'),
                  onPressed: () {
                    // Acción al presionar el botón de editar
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}