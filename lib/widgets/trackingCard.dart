
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/clientPage.dart';

class TrackingCard extends StatefulWidget {

  String? searchQuery;

  TrackingCard({Key? key,this.searchQuery}):super(key:key);

  @override
  State<TrackingCard> createState() => _TrackingCardState();
}

class _TrackingCardState extends State<TrackingCard> {

  Map<String, dynamic>? trackingData={}; //Se utiliza para asignar un objeto JSON al mismo
  //Como el JSON tiene propiedades como string o int entonces tiene que ser dynamic
  String consigneeName='';
  String date='';
  bool firstVisit=true;
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    fetchTrackingData();
  }

  @override
  void didUpdateWidget(TrackingCard oldWidget){
    firstVisit=false;
    super.didUpdateWidget(oldWidget);
    if(widget.searchQuery!=oldWidget.searchQuery){
      consigneeName='';
      trackingData={};
      fetchTrackingData();
    }
  }

  Future<void> fetchDeliveryData(int shipmentId) async {
    String URL = 'http://20.150.216.134:7070/api/v1/deliveries';
    final url = Uri.parse(URL);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var deliveriesData = json.decode(response.body);
      if (deliveriesData is List<dynamic> && deliveriesData.isNotEmpty) {
        var filteredDelivery = deliveriesData.firstWhere(
                (delivery) => delivery['shipmentId'] == shipmentId,
            orElse: () => null);
        date=filteredDelivery['date'];
      }
    }
    return;
  }

  Future<void> fetchConsigneerData(int consigneerId) async {
    String URL = 'http://20.150.216.134:7070/api/v1/consignees/$consigneerId';
    final url = Uri.parse(URL);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var consigneeData = json.decode(response.body);

      if (consigneeData is List<dynamic> && consigneeData.isNotEmpty) {
        var onlyConsigneer = consigneeData[0];
        consigneeName=onlyConsigneer['name'];
        return onlyConsigneer;
      }
    } else {
      print("Error al obtener los datos del consignee");
    }
  }

  Future<void> fetchTrackingData() async {

    setState(() {
      isLoading = true; // Mostrar el CircularProgressIndicator
    });

    String? searchQuery = widget.searchQuery;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      print("Se entró al url");
      String URL = 'http://20.150.216.134:7070/api/v1/shipments/$searchQuery';
      final url = Uri.parse(URL);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData is List<dynamic> && jsonData.isNotEmpty) { // Verificar si es una lista no vacía
          setState(() {
            trackingData = jsonData[0]; // Obtener el primer elemento de la lista
          });

          if(trackingData!.isNotEmpty || trackingData!=null){
            int consigneeId=trackingData?['consigneesId'];
            await fetchConsigneerData(consigneeId);
            await fetchDeliveryData(int.parse(searchQuery));
          }
          setState(() {
            isLoading = false; // Ocultar el CircularProgressIndicator
          });

        } else {
          print("La respuesta no es una lista válida o está vacía");
        }
      } else {
        print("Error en la solicitud");
      }
    }

    setState(() {
      isLoading = false; // Ocultar el CircularProgressIndicator
    });
  }


  @override
  Widget build(BuildContext context) {

    if (trackingData==null || (trackingData!.isEmpty && firstVisit)) {
      return Row( // Agregado: Envuelve el Card con Row
        children: [
          Expanded(
            child: Card(
              color: Color(0xFFF0E5FF),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.search_sharp,
                    color: Color(0xFF6200EE),
                    size: 24,
                    semanticLabel: "Search Progress",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Busca algún paquete..."),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }else if (trackingData!.isNotEmpty ) {
      return Row(
        children: [
          Expanded(
            child: Card(
              color: Color(0xFFF0E5FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: isLoading
                  ? Column(

                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
                  : GestureDetector(
                onTap: () {
                  print("Nothing");
                },
                child: Card(
                  color: Color(0xFFF0E5FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 120,
                              height: 120, // Ajusta el tamaño según tus necesidades
                              // Agrega aquí la vista de Google Maps o cualquier otro widget que desees mostrar
                              // Puedes utilizar el widget `GoogleMap` de la biblioteca `google_maps_flutter` para mostrar el mapa
                              // Ejemplo: GoogleMap(...),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Card(
                                    color: Color(0xFFFFFFFF),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5, // Espaciado vertical
                                        horizontal: 10, // Espaciado horizontal
                                      ),
                                      child: Text(
                                        'Order #${widget.searchQuery.toString()}',
                                        style: TextStyle(
                                          color: Color(0xFF6200EE),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  Card(
                                    color: Color(0xFF6200EE),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5, // Espaciado vertical
                                        horizontal: 10, // Espaciado horizontal
                                      ),
                                      child: Text(
                                        'Processing',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),

                            // Icon(Icons.arrow_forward),

                            Card(
                              color:Color(0xFFBA8EFC),
                              child: IconButton(
                                onPressed: (){
                                  print("Card");
                                },
                                icon: Icon(Icons.arrow_forward_ios_sharp),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }else{
      return Row( // Agregado: Envuelve el Card con Row
        children: [
          Expanded(
            child: Card(
              color: Color(0xFFF0E5FF),
              child: isLoading? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.error_sharp,
                    color: Color(0xFF6200EE),
                    size: 24,
                    semanticLabel: "Shipment not found!",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Tarjeta no habida"),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
