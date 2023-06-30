import 'package:example_souf_route/pages/Register.dart';
import 'package:flutter/material.dart';
import 'administratorPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  void _saveData() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('username', username);

    await _secureStorage.write(key: 'password', value: password);
  }

  void _navigateToNextScreen() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter your username and password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(username: username),
        ),
      );
      _clearForm();
    }
  }


  void _navigateToRegisterScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(),
      ),
    );
  }

  void _showAccountBottomSheet(){
    showModalBottomSheet(
      context: context,
      backgroundColor:Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.vertical(
          top: Radius.circular(25),
        )
      ),
      builder:(context){
        return Container(
         padding: EdgeInsets.all(25),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisSize: MainAxisSize.min,
           children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   InkWell(
                     onTap: () {
                       Navigator.pop(context);
                     },
                     child: Container(
                       padding: EdgeInsets.all(8),
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: Colors.transparent,
                       ),
                       child: Icon(
                         Icons.cancel,
                         color: Colors.grey,
                         size: 30,
                       ),
                     ),
                   ),
                 ],
               ),
             Icon(Icons.key_rounded,
             color: Colors.black,
             size: 60,
             ),
             SizedBox(height: 10),
             Text('Do you want to log in to SoftRoute with your saved account?',
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
             ),
             ),
             SizedBox(height: 20),
             Text(
               'Email/Username: ${_usernameController.text}',
               style: TextStyle(
                 fontSize: 16,
               ),
             ),
             Text(
               'Password: ${_passwordController.text}',
               style: TextStyle(
                 fontSize: 16,
               ),
             ),
             SizedBox(height: 20),
             SizedBox(height: 10),

             ElevatedButton(onPressed: (){
               _usernameController.text = _usernameController.text;
               _passwordController.text = _passwordController.text;
               Navigator.pop(context);
             },
               style: ElevatedButton.styleFrom(
               backgroundColor: Colors.deepPurple,
               ),
                 child:Text('Confirm Use',
                 style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
                 ),
             )

           ],
          ),
        );
      },
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
                          //
                          onTap: () {
                            _showAccountBottomSheet();
                          },
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
                          onTap: () {
                            _showAccountBottomSheet();
                          },
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
                            //////////////////////////////////////////////
                            //
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed:
                                _navigateToNextScreen,
                                //_navigateToAdminScreen,
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
