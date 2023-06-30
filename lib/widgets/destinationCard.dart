import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../views/Administrator/GoogleMapsScreen.dart';



class DestinationCard extends StatelessWidget {

  final String name;
  final LatLng location;


  DestinationCard({
    required this.name,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ClientPage()));
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
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image: AssetImage('images/maps.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                      name,
                                      style: TextStyle(
                                        color: Color(0xFF6200EE),
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
                                if (MediaQuery.of(context).size.width >= 600) {
                                  print("julian t amo");
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GoogleMapsScreen(
                                        name: name,
                                        location: location,
                                      ),
                                    ),
                                  );
                                }
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
        )
      ],
    );
  }
}
