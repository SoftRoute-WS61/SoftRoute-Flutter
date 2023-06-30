import 'dart:convert';
import 'package:example_souf_route/models/Shipment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ListShipmentView extends StatefulWidget {
  @override
  State<ListShipmentView> createState() => _ListShipmentViewState();
}

class _ListShipmentViewState extends State<ListShipmentView> {
  String url = "http://20.150.216.134:7070/api/v1/shipments";
  String urlDestino = "http://20.150.216.134:7070/api/v1/destinations";
  String urlRemitente = "http://20.150.216.134:7070/api/v1/sender";
  String urlConsignado = "http://20.150.216.134:7070/api/v1/consignees";

  List<Shipment> shipments = [];
  Map<int, String> destinoNames = {};
  Map<int, String> remitenteNames = {};
  Map<int, String> consignadoNames = {};

  Future<void> fetchShipments() async {
    final response = await http.get(Uri.parse(url));
    final responseDestino = await http.get(Uri.parse(urlDestino));
    final responseRemitente = await http.get(Uri.parse(urlRemitente));
    final responseConsignado = await http.get(Uri.parse(urlConsignado));

    if (response.statusCode == 200 &&
        responseDestino.statusCode == 200 &&
        responseRemitente.statusCode == 200 &&
        responseConsignado.statusCode == 200
    ) {

      final List<dynamic> data = json.decode(response.body);
      setState(() {
        final destinos = json.decode(responseDestino.body);
        final remitentes = json.decode(responseRemitente.body);
        final consignados = json.decode(responseConsignado.body);
        destinoNames = Map.fromIterable(destinos, key: (destino) => destino['id'], value: (destino) => destino['name']);
        remitenteNames = Map.fromIterable(remitentes, key: (remitente) => remitente['id'], value: (remitente) => remitente['name']);
        consignadoNames = Map.fromIterable(consignados, key: (consignado) => consignado['id'], value: (consignado) => consignado['name']);
        shipments = data.map((json)  =>
            Shipment(
                id: json['id'],
                description: json['description'],
                quantity: json['quantity'],
                freight: json['freight'],
                weight: json['weight'],
                date: json['date'],
                destinyId: json['destinyId'],
                consigneesId: json['consigneesId'],
                senderId: json['senderId'],
                typeOfPackageId: json['typeOfPackageId'],
                documentId: json['documentId'])
        ).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    this.fetchShipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: shipments.length,
        itemBuilder: (context, index) {
          final destinoName = destinoNames[shipments[index].destinyId];
          final consignadoName = consignadoNames[shipments[index].consigneesId];
          final remitenteName = remitenteNames[shipments[index].senderId];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(5),
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListTile(
                leading: Text(shipments[index].id.toString()),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Destino:${destinoName ?? ''}'),
                    Text('Consignatario:${consignadoName ?? ''}'),
                    Text('Remitente:${remitenteName ?? ''}'),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Descripción: ' +
                        shipments[index].description),
                    Text('Fecha: ' + shipments[index].date),
                    Text('Flete: ' + shipments[index].freight.toString()),
                    Text('Peso: ' + shipments[index].weight.toString()),
                    Text('Cantidad:' + shipments[index].quantity.toString()),
                  ],
                ),
                trailing: Icon(Icons.edit),
                onTap: () {

                },
              ),
            ),
          );
        },
      ),
    );
  }
}
