import 'package:example_souf_route/widgets/appBarRegister.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isPasswordVisible = false;
  //
  final _secureStorage = FlutterSecureStorage();
  bool _isFormValid=false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final phoneNumber = _phoneNumberController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final code = _codeController.text;

      final url = Uri.parse('http://40.67.144.113:8080/api/v1/admin');

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': int.parse(phoneNumber),
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        print('Correcto');
        _saveData(); // guardar datos internamente
        _navigateToAdminScreen(); // Pop Up
        Navigator.pop(context);
      } else {
        print('Request failed with status: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Ocurrió un error al enviar el formulario.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }

  }

  void _loadSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedUsername = preferences.getString('username');
    String? savedPassword = await _secureStorage.read(key: 'password');

    setState(() {
      _emailController.text = savedUsername ?? '';
      _passwordController.text = savedPassword ?? '';
      _isFormValid = savedUsername != null && savedPassword != null;
    });
  }
  void _saveData() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('email',email);

    await _secureStorage.write(key: 'password', value: password);
  }
  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _isFormValid = false;
    });
  }
  void _navigateToAdminScreen() {
    if (_isFormValid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.lock,
              color: Colors.black,
              size: 50),
          title: Text('Save Data',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Do you want to save the entered data?'),
              SizedBox(height: 16),
              Text('Email: ${_emailController.text}'),
              Text('Password: ${_passwordController.text}'),
            ],
          ),
          actions: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                  onPressed: () {
                    _saveData();
                    Navigator.pop(context);
                    //_navigateToNextScreen();
                    _clearForm();
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    //_navigateToNextScreen();
                    _clearForm();
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBarRegister(),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        labelText: 'First Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6200EE),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        labelText: 'Last Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6200EE),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        labelText: 'Phone Number',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6200EE),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        labelText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6200EE),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        labelText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6200EE),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF6200EE),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _codeController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        labelText: 'Code',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6200EE),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF6200EE),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
