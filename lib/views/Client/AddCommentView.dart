import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/FeedbackClient.dart';
import '../../models/TypeOfComplaint.dart';
class AddCommentView extends StatefulWidget {
  const AddCommentView({super.key});

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  //DATOS QUE IRAN EN EL DROPDOWN
  List<TypeOfComplaint> items = [];
  TypeOfComplaint? selectedItem;
  //Para PopUp
  bool _feedbackSend = false;

  //Datos para el POST del Comment
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeOfComplaintIdController = TextEditingController();
  final TextEditingController _shipmentIdController = TextEditingController();

  //Pop Up para confirmar el envío del Comment
  Future<void>_showFeedbacksentDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Color(0xffC8A1FF), size: 50),
              SizedBox(height: 16),
              Text('Feedback enviado', style: TextStyle(fontSize: 20)),
            ],
          ),
          actions: [
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(fontSize: 16, color: Color(0xffC8A1FF)))),
              ),
          ],
        );
      },
    );
  }
  Future<void> addComment() async { try {
    final feedbackClient = FeedbackClient(
      date: DateTime.now().toString(),
      description: _descriptionController.text,
      typeOfComplaintId: int.parse(selectedItem?.id.toString() ?? ''),
      shipmentId: int.parse(_shipmentIdController.text),
    );
    print(feedbackClient.typeOfComplaintId);
    print(feedbackClient.shipmentId);
    print(feedbackClient.description);
    print(feedbackClient.date);
  //Future para hacer Post del Comment
    final url = Uri.parse('http://20.150.216.134:7070/api/v1/feedback');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(feedbackClient),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Comentario enviado con éxito');
    } else {
      print('Error al enviar el comentario');
    }
  }catch (error) {
    print('Error en la solicitud POST: $error');

  }

  }
  //Future Para obtener los datos del Dropdown
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
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        items = data;
        selectedItem = data.isNotEmpty ? data[0] : null;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: const Text("Add Comment",style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),),
          ),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color:Color(0xffC8A1FF),
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 200,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 150,
                        child: Text(
                          "Type of complaint",
                          style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 163,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(width: 1, color: Color(0xffC8A1FF)),
                          ),
                        ),
                        value: selectedItem?.name,
                        items: items
                            .map(
                              (item) => DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(item.name, style: TextStyle(fontSize: 15)),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedItem = items.firstWhere((item) => item.name == value);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 120,
              height: 40,
              child: TextField(
                controller: _shipmentIdController,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 1, color: Color(0xFFC8A1FF)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  hintText: ' ShipmentId',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(width:1,color:Color(0xFFC8A1FF))
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20),
              hintText: " Add feedback",
              hintStyle: const TextStyle(
                  color:Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: (){
                  addComment();
                  _showFeedbacksentDialog();
                },
                child: const Text("Send",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffC8A1FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
    );
  }
}
