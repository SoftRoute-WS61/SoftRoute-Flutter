class Shipment {
  final int id;
  final String description;
  final int quantity;
  final int freight;
  final int weight;
  final String date;
  final int destinyId;
  final int consigneesId;
  final int senderId;
  final int typeOfPackageId;
  final int documentId;


  Shipment(
      {
        required this.id,
        required this.description,
        required this.quantity,
        required this.freight,
        required this.weight,
        required this.date,
        required this.destinyId,
        required this.consigneesId,
        required this.senderId,
        required this.typeOfPackageId,
        required this.documentId
      });

  Map<String,dynamic> toMap(){
    return {
      'id': (id==0)? null:id,
      'description': description,
      'quantity': quantity,
      'freight': freight,
      'weight': weight,
      'date': date,
      'destinyId': destinyId,
      'consigneesId': consigneesId,
      'senderId': senderId,
      'typeOfPackageId': typeOfPackageId,
      'documentId': documentId,
    };
  }
}
