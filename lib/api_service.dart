import 'dart:convert';
import 'package:http/http.dart' as http;

class Login {
  final String idusuario;
  final String email;
  final String password;
  final String idpersona;

  Login({
    required this.idusuario,
    required this.email,
    required this.password,
    required this.idpersona,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      idusuario: json['idusuario']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      idpersona: json['idpersona']?.toString() ?? '',
    );
  }
}

class ApiService {
  static Future<List<Login>> login(String email, String password) async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/login/login_flutter');

    final response = await http.post(url, body: {
      'email': email.trim(),
      'password': password,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data'];
      if (data is List && data.isNotEmpty) {
        return data.map((json) => Login.fromJson(json)).toList();
      } else {
        throw Exception('Credenciales incorrectas.');
      }
    } else {
      throw Exception('Error de red o servidor: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSexos() async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/login/sexos_flutter');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['data']);
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchPaises() async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/login/paises_flutter');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['data']);
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchEventosRegistro() async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/login/eventos_flutter');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['data']);
    }
    return [];
  }

  static Future<Map<String, dynamic>> register({
    required String idevento,
    required String cedula,
    required String apellidos,
    required String nombres,
    required String email,
    required String idsexo,
    required String fechanacimiento,
    required String telefono,
    required String idpais,
    required String password,
  }) async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/login/new_user_registration');
    final response = await http.post(url, body: {
      'idevento': idevento,
      'cedula': cedula,
      'apellidos': apellidos,
      'nombres': nombres,
      'email': email,
      'idsexo': idsexo,
      'fechanacimiento': fechanacimiento,
      'telefono': telefono,
      'idpais': idpais,
      'password': password,
      'fuente': '1', // Indicar que es JSON para el backend
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar usuario');
    }
  }
}
