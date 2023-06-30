import 'package:flutter/material.dart';

class CustomAppBarRegister extends StatelessWidget implements PreferredSizeWidget {

  CustomAppBarRegister();

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Welcome to Soft Route!',
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.0); // Ajusta la altura deseada
}

