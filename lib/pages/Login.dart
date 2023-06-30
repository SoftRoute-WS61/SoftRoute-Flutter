import 'dart:convert';

import 'package:example_souf_route/pages/Register.dart';
import 'package:flutter/material.dart';
import 'administratorPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminIdStorage {
  static int adminId=0;
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordVisible = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isFormValid = false;
  final _secureStorage = FlutterSecureStorage();


  Future<bool> _verifyLogin(String username, String password) async {
    final url = Uri.parse('http://40.67.144.113:8080/api/v1/admin');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final users = json.decode(response.body);

      for (var user in users) {
        if (user['email'] == username && user['password'] == password) {
          AdminIdStorage.adminId = user['id'];
            _navigateToNextScreen(username: user['name']);
          return true; // Los datos de inicio de sesión son correctos
        }
      }
    }
    return false; // Los datos de inicio de sesión son incorrectos
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedUsername = preferences.getString('username');
    String? savedPassword = await _secureStorage.read(key: 'password');

    setState(() {
      _usernameController.text = savedUsername ?? '';
      _passwordController.text = savedPassword ?? '';
      _isFormValid = savedUsername != null && savedPassword != null;
    });
  }
  void _clearForm() {
    _usernameController.clear();
    _passwordController.clear();
    setState(() {
      _isFormValid = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  void _navigateToAdminScreen() async {
    if (_isFormValid) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      final isValid = await _verifyLogin(username, password);

      if(!isValid){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Usuario o Contraseña Incorrectos'),
            content: Text('Por favor, intentelo denuevo'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Incomplete Form'),
          content: Text('Please enter your username and password.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _saveData() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('username', username);

    await _secureStorage.write(key: 'password', value: password);
  }

  void _navigateToNextScreen({String? username}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPage(username: username ?? _usernameController.text),
      ),
    );
  }

  void _navigateToRegisterScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/wallpaper_home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset('images/boxlogo.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                          controller: _usernameController,
                          onChanged: (value) {
                            _checkFormValidity();
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          onChanged: (value) {
                            _checkFormValidity();
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: _navigateToRegisterScreen,
                              child: Text('Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: _navigateToAdminScreen,
                              child: Text('Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
