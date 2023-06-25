import 'dart:convert';
import 'package:example_souf_route/models/FeedbackModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/TypeOfComplaint.dart';

class ListCommentsView extends StatefulWidget {
  const ListCommentsView({Key? key}) : super(key: key);

  @override
  State<ListCommentsView> createState() => _ListCommentsViewState();
}

class _ListCommentsViewState extends State<ListCommentsView> {
  //DATOS QUE IRAN EN EL DROPDOWN
  List<TypeOfComplaint> items = [];
  TypeOfComplaint? selectedItem;
  String url = "http://20.150.216.134:7070/api/v1/feedback";
  List<FeedbackModel> comments = [];

  Future<void> fetchComments() async {
    final response = await http.get(Uri.parse('http://20.150.216.134:7070/api/v1/feedback'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        comments = data
            .map((json) => FeedbackModel(
          id: json['id'],
          date: json['date'],
          description: json['description'],
          typeOfComplaintId: json['typeOfComplaintId'],
            shipmentId: json['shipmentId'],
        ))
            .toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComments();
    fetchData().then((data) {
      setState(() {
        items = data;
        selectedItem = data.isNotEmpty ? data[0] : null;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  //dropdown
  Future<List<TypeOfComplaint>> fetchData() async {
    final url = 'http://20.150.216.134:7070/api/v1/typeofcomplaint';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => TypeOfComplaint.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los datos de la API');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FeedbackModel> filteredComments = [];

    if (selectedItem != null) {
      filteredComments = comments
          .where((comment) => comment.typeOfComplaintId == selectedItem!.id)
          .toList();
    } else {
      filteredComments = comments;
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: filteredComments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Mostrar el card del filtro en el primer índice
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.filter_list),
                title: DropdownButtonFormField<TypeOfComplaint>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1, color: Color(0xffC8A1FF)),
                    ),
                  ),
                  value: selectedItem,
                  items: items.map((item) {
                    return DropdownMenuItem<TypeOfComplaint>(
                      value: item,
                      child: Text(item.name, style: TextStyle(fontSize: 15)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                ),
              ),
            );
          } else {
            // Mostrar las tarjetas de comentarios filtrados
            final commentIndex = index - 1;
            final comment = filteredComments[commentIndex];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xFFFFFFFF),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      color: Colors.purpleAccent,
                      child: Text(
                        'Nombre del usuario',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(comment.description),
                      subtitle: Text(comment.date),
                      contentPadding: EdgeInsets.all(16.0),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          // Acción cuando se presiona el botón "responder"
                          // Puedes agregar aquí la lógica para responder al comentario
                        },
                        child: Text(
                          'Responder',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}