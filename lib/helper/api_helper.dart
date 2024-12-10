import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modal/contact_modal.dart';

class ApiHelper {
  static const String _baseUrl = 'https://reqres.in/api/users';

  static Future<ContactResponse> fetchContacts(int page) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?page=$page&per_page=10'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ContactResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch contacts');
    }
  }
}
