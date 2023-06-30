import 'dart:convert';
import 'package:example_souf_route/views/Administrator/ConsigneesView.dart';
import 'package:example_souf_route/views/Administrator/ListComments.dart';
import 'package:example_souf_route/views/Administrator/SendersView.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../views/Administrator/ProfileView.dart';
import '../widgets/appBar.dart';
import '../views/Administrator/AddShipmentView.dart';
import '../views/Administrator/AdminHomeView.dart';
import '../views/Administrator/ListShipmentView.dart';


class AdminPage extends StatefulWidget {

  final String email;

  AdminPage({required this.email});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final items=[
    Icon(Icons.home, color: Colors.white),
    Icon(Icons.book, color: Colors.white),
    Icon(Icons.car_crash, color: Colors.white),
    Icon(Icons.comment, color: Colors.white),
    Icon(Icons.person, color: Colors.white),
  ];

  int index=0;
  int homePageIndex = 0;


  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      this.index = index;
      if (index == 0) {
        homePageIndex = 0;
      }
    });
  }



  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(username: widget.email),
          drawer: NavigationDrawer(onTabTapped: onTabTapped),
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            backgroundColor: Colors.transparent,
            color: Colors.deepPurple,
            items: items,
            index: index,
            onTap: (index){
              setState(() {
                this.index=index;
              });
            },
            animationDuration: Duration(milliseconds: 300),
          ),
          body: Container(
            child: getSelectedWidget(index:index),
          )
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch(index){
      case 0:
        widget= AdminHomeView();
        break;
      case 1:
        widget= ListShipmentView();
        break;
      case 2:
        widget= AddShipmentView();
        break;
        case 3:
          widget= ListCommentsView();
      case 4:
        widget= ProfileScreen();
      default:
        widget= AddShipmentView();
        break;
    }
    return widget;
  }
}

//Navigation Drawer

class NavigationDrawer extends StatelessWidget {

  final Function(int) onTabTapped;

  const NavigationDrawer({Key? key, required this.onTabTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ]
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context)=> Container(
    color: Color(0xff6200EE),
      padding: EdgeInsets.only(
      top: 24+MediaQuery.of(context).padding.top ,
      bottom: 24,
    ),
    child: Column(
      children: const [
        CircleAvatar(
          radius:52,
          backgroundImage: NetworkImage(
              "https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Administrator',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () {
/*            Navigator.popUntil(context, ModalRoute.withName('/home')); // Regresar a la página principal*/
            onTabTapped(0); // Establecer la pantalla de inicio como seleccionada en el bottomNavigationBar
            Navigator.pop(context); // Cerrar el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user),
          title: const Text('Consignees'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ConsigneesView(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_rounded),
          title: const Text('Senders'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => SendersView(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
        ),
        const Divider(color: Colors.black54),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
              ),
                  (route) => false,
            );
          },
        ),
      ],
    ),
  );
}


