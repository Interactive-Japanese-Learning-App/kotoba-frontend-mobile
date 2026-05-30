import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      'http://192.168.18.11:5000/api';

  // =========================
  // REGISTER USER
  // =========================

  static Future<Map<String, dynamic>>
      register({

    required String email,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/users/user/register',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'email': email,
        'password': password,

      }),
    );

    return jsonDecode(
      response.body,
    );
  }

  // =========================
  // LOGIN USER
  // =========================

  static Future<Map<String, dynamic>>
      login({

    required String email,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/users/user/login',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'email': email,
        'password': password,

      }),
    );

    return jsonDecode(
      response.body,
    );
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  static Future<Map<String, dynamic>>
      updateProfile({

    required String id,
    required String email,
    required String password,

  }) async {

    final response = await http.put(

      Uri.parse(
        '$baseUrl/users/user/$id',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'email': email,
        'password': password,

      }),
    );

    return jsonDecode(
      response.body,
    );
  }
}