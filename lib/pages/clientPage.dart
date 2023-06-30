import 'dart:convert';
import 'package:example_souf_route/views/Client/AddCommentView.dart';
import 'package:example_souf_route/views/Client/ClientHomeView.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../widgets/appBar.dart';
import '../widgets/trackingCard.dart';


class ClientPage extends StatefulWidget {

  // final String username;
  //ClientPage({required this.username});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final items=[
    Icon(Icons.home, color: Colors.white),
    Icon(Icons.comment, color: Colors.white),
  ];
  int index=0;

  late String codeSended;
  final code = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeSended = '';
  }

  void updateSearchQuery(String query) {
    setState(() {
      codeSended = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(username: "Client"),
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
          body: getSelectedWidgetClient(index: index),
      ),
    );
  }
  Widget getSelectedWidgetClient({required int index}) {
    Widget widget;
    switch(index){
      case 0:
        widget= ClientHome();
        break;
      case 1:
        widget=AddCommentView() ;
        break;
      default:
        widget= ClientHome();
        break;
    }
    return widget;
  }
}