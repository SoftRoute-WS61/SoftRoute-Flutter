import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/Admin.dart';
import '../../pages/Login.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int adminId = AdminIdStorage.adminId;
  List<Admin> adminInfos = [];

  Future<void> fetchAdminInfo() async {
    String URL = 'http://40.67.144.113:8080/api/v1/admin/$adminId';
    print(adminId);

    final url = Uri.parse(URL);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map) {
        int id = jsonData['id'];
        String name = jsonData['name'];
        String lastName = jsonData['lastName'];
        String email = jsonData['email'];
        String password = jsonData['password'];
        int phoneNumber = jsonData['phoneNumber'];
        String code = jsonData['code'];
        Admin adminInfo = Admin(
          id: id,
          name: name,
          lastName: lastName,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          code: code,
        );
        adminInfos.add(adminInfo);
        setState(() {}); // Actualizar el widget para reflejar los datos obtenidos
      } else {
        print('Invalid JSON format: Expected a map.');
      }

    }else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    print('JULIAN TE AMO');
    super.initState();
    fetchAdminInfo();
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
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
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
                  'Name: ${adminInfos.isNotEmpty ? adminInfos[0].name : ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Lastname: ${adminInfos.isNotEmpty
                      ? adminInfos[0].lastName
                      : ''}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${adminInfos.isNotEmpty ? adminInfos[0].email : ''}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone Number: ${adminInfos.isNotEmpty ? adminInfos[0]
                      .phoneNumber : ''}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   child: Text('Editar'),
                //   onPressed: () {
                //     // Acción al presionar el botón de editar
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}