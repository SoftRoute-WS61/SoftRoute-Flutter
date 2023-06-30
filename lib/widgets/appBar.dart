import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String username;

  CustomAppBar({required this.username});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF6200EE),
      flexibleSpace: Container(
        height: 120, // Ajusta la altura deseada
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/boxlogo.png',
              width: 50,
              height: 50,
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Welcome $username!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Acción al presionar el ícono de configuración
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.0); // Ajusta la altura deseada
}

