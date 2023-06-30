class FeedbackModel {
  final int id;
  final String description;
  final String date;
  final int typeOfComplaintId;
  final int shipmentId;


  FeedbackModel(
      {
        required this.id,
        required this.description,
        required this.date,
        required this.shipmentId,
        required this.typeOfComplaintId

      });


  Map<String,dynamic> toMap(){
    return {
      'id': (id==0)? null:id,
      'description': description,
      'date': date,
      'typeOfComplaintId': typeOfComplaintId,
      'shipmentId': shipmentId,
    };
  }
}