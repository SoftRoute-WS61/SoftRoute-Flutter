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
}
