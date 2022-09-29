import 'dart:convert';

import 'package:http/http.dart' as http;

class NetWorkHelper {
  String url = 'https://api.openrouteservice.org/v2/directions/';
  String apiKey = '5b3ce3597851110001cf624880a6ea24e5b94231b40fa2c3bc1dda19';
  String journeyMode = 'driving-car';
  double? startLng = 16.4053917;
  double? startLat = 102.807208;
  double? endLng = 16.4053917;
  double? endLat = 102.807208;
  NetWorkHelper({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
  });

  Future getData()async{
    Uri url2uri = Uri.parse('$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat');
    http.Response response = await http.get(url2uri);
    print('$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat');

    if(response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }else{
      print(response.statusCode);
    }
  }
}
