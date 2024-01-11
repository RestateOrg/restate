import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, String>?> getLocationInfo(String pincode) async {
  final url = Uri.parse(
      'http://postalpincode.in/api/pincode/$pincode'); // Replace with your chosen API URL
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['Status'] == 'Success') {
      final city = data['PostOffice'][0]['District'];
      final state = data['PostOffice'][0]['State'];
      final country = 'India';
      return {'city': city, 'state': state, 'country': country};
    } else {
      return null; // Indicate invalid pincode
    }
  } else {
    return null; // Indicate API request failure
  }
}
