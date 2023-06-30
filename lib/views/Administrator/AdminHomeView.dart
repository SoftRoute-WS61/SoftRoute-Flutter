import 'dart:convert';
import 'package:example_souf_route/models/Destination.dart';
import 'package:example_souf_route/widgets/destinationCard.dart';
import 'package:flutter/material.dart';
import '../../widgets/trackingCard.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';




class AdminHomeView extends StatefulWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {

  String? previosSearchQuery;
  late String codeSended;
  final code=TextEditingController();

  List<Destination> destinationList = [];
  @override
  void initState() {
    super.initState();
    codeSended = '';
    fetchDestination();
  }

  Future<void> fetchDestination() async{
    String base_url='http://20.150.216.134:7070/api/v1/destinations';
    final url=Uri.parse(base_url);
    var response =await http.get(url);
    if(response.statusCode==200){
      final jsonData = jsonDecode(response.body); //decodificacion del cuerpo
      List<Destination> destinations = [];
      for (var item in jsonData) {
        Destination destination = Destination(
            id:item['id'],
            name: item['name']
        );
        destinations.add(destination);
      }
      setState(() {
        destinationList = destinations;
      });
    }else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyCI8MZF0vPLVOxsfUzyMVdhTbxtcYHwBOQ'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['results'] != null && jsonData['results'].length > 0) {
          final location = jsonData['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while geocoding address: $e');
    }
    return null;
  }

  void updateSearchQuery(String query) {
    setState(() {
      codeSended = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                TextField(
                  controller: code,
                  style: const TextStyle(color:Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffC8A1FF),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none
                    ),
                    hintText: "Enter tracking number",
                    hintStyle: const TextStyle(
                        color:Colors.white
                    ),
                    prefixIcon: IconButton(
                      icon:Icon(Icons.search),
                      color:Colors.white,
                      onPressed: (){
                        codeSended=code.text;
                        updateSearchQuery(code.text);
                        print("Boton presionado!");
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tracking',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TrackingCard(searchQuery: codeSended),
              ],
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Destinations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (destinationList.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: destinationList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<LatLng?>(
                    future: getCoordinatesFromAddress(destinationList[index].name),
                    builder: (BuildContext context, AsyncSnapshot<LatLng?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        LatLng? location = snapshot.data;
                        if (location != null) {
                          return DestinationCard(
                            name: destinationList[index].name.toString(),
                            location: location,
                          );
                        } else {
                          return Text('No se encontraron coordenadas para esta ubicación');
                        }
                      }
                    },
                  );
                },
              ),
            if (destinationList.isEmpty)
              CircularProgressIndicator(),

          ],
        ),
      ),
    );
  }
}
