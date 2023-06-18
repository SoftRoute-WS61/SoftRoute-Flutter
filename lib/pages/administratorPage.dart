import 'dart:convert';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../widgets/appBar.dart';
import '../views/Administrator/AddShipmentView.dart';
import '../views/Administrator/AdminHomeView.dart';


class AdminPage extends StatefulWidget {

  final String username;

  AdminPage({required this.username});

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
          appBar: CustomAppBar(username: widget.username),
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
        widget= AddShipmentView();
        break;
      default:
        widget= AdminHomeView();
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
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
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
          leading: const Icon(Icons.car_rental),
          title: const Text('Deliveries'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => DeliveriesView(),
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
          leading: const Icon(Icons.verified_user),
          title: const Text('Consignees'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveriesView())); // Navega a la vista de destinatarios
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_rounded),
          title: const Text('Senders'),
          onTap: () {
            onTabTapped(0);
            Navigator.pop(context);
          },
        ),
        const Divider(color: Colors.black54),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            // Agrega aquí la lógica para realizar la operación de cierre de sesión
          },
        ),
      ],
    ),
  );
}

class DeliveriesView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(onTabTapped: (index){}),
        appBar: CustomAppBar(username: "Deliveries"),
        body: const Center(
          child: Text('Deliveries'),
        ),
      ),
    );
  }
}
