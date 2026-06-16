import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://192.168.18.9:5000/api';

  // =========================
  // REGISTER USER
  // =========================

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/user/register'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // GOOGLE LOGIN
  // =========================
  static Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/user/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // LOGIN USER
  // =========================

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/user/login'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  static Future<Map<String, dynamic>> updateProfile({
    required String id,
    required String email,
    required String password,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/user/$id'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/verify-otp'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'otp': otp}),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // RESEND OTP
  // =========================
  static Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/resend-otp'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email}),
    );

    return jsonDecode(response.body);
  }
  // =========================
  // FORGOT PASSWORD
  // =========================
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // =========================
  // RESET PASSWORD
  // =========================

  static Future<Map<String, dynamic>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/verify-reset-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }
  //DETECT OBJECT API

static Future<List<dynamic>> detectObject(File image) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/detect'),
  );

  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      image.path,
    ),
  );

  final streamedResponse = await request.send();

  final response = await http.Response.fromStream(
    streamedResponse,
  );

  return jsonDecode(response.body);
}

}







