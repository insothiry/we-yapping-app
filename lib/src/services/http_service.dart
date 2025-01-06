import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> createUser(String firstName, String? lastName, File? profileImage,
    String username, String phoneNumber) async {
  String? imageUrl;

  if (profileImage != null) {
    String base64Image = base64Encode(profileImage.readAsBytesSync());
    imageUrl = "data:image/png;base64,$base64Image";
  }

  final response = await http.post(
    Uri.parse('http://localhost:3000/api/users/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': imageUrl,
      'username': username,
      'phoneNumber': phoneNumber,
    }),
  );

  if (response.statusCode == 201) {
    // User created successfully
    print('User created: ${response.body}');
  } else {
    print('Error creating user: ${response.body}');
  }
}
