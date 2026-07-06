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

  static Future<String> chatWithAgenteIa(String promptUsuario) async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/Agenteia/chat_api');
    try {
      final response = await http.post(
        url,
        body: {'prompt_usuario': promptUsuario},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['respuesta'] ?? 'Error: Sin respuesta del agente';
      } else {
        return 'Error en la conexión con el servidor (${response.statusCode})';
      }
    } catch (e) {
      return 'Error: No se pudo conectar con el agente. Detalle: $e';
    }
  }

  static Future<Persona> fetchPersonaInfo(String idpersona) async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/persona/persona_flutter');
    final response = await http.post(
      url,
      body: {
        'idpersona': idpersona,
      },
    );

    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        final List<dynamic>? dataList = decoded['data'];

        if (dataList != null && dataList.isNotEmpty) {
          final Map<String, dynamic> personaMap = Map<String, dynamic>.from(dataList.first);
          return Persona.fromJson(personaMap);
        } else {
          throw Exception('Respuesta de la API de Persona vacía o sin clave "data".');
        }
      } catch (e) {
        throw Exception('Error al procesar la información de la persona. Detalle: $e');
      }
    } else {
      throw Exception('Error al conectar con el servidor (${response.statusCode})');
    }
  }

  static Future<List<Perfil>> fetchPerfiles(String idusuario) async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/perfil/perfil_personaflutter');
    final response = await http.post(
      url,
      body: {
        'idusuario': idusuario,
      },
    );
    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('data')) {
          final data = decoded['data'];
          if (data is List) {
            return data.map((e) => Perfil.fromJson(e)).toList();
          }
        }
        return [];
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<List<Portafolio>> fetchPortafolio(String idpersona) async {
    final url = Uri.parse('https://educaysoft.org/sica/index.php/portafolio/portafolio_flutter?idpersona=$idpersona');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => Portafolio.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar portafolio');
    }
  }
}

class Persona {                                                                                               
  final String idpersona;
  final String lapersona;
  final String cedula;
  final String idusuario;
  
  Persona({required this.idpersona, required this.cedula, required this.lapersona, required this.idusuario});
  
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      idpersona: json['idpersona'].toString(),
      cedula: json['cedula'] ?? '',
      lapersona: json['lapersona'] ?? '',
      idusuario: json['idusuario']?.toString() ?? '',
    );
  }
}

class Perfil {
  final String idperfil;
  final String nombre;

  Perfil({required this.idperfil, required this.nombre});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      idperfil: json['idperfil']?.toString() ?? '',
      nombre: json['nombreperfil'] ?? json['perfil'] ?? json['nombre'] ?? 'Invitado',
    );
  }
}

class Portafolio {                                                                                               
  final String idportafolio;
  final String elperiodo;
  final String lapersona;
  
  Portafolio({required this.elperiodo, required this.idportafolio, required this.lapersona});
  
  factory Portafolio.fromJson(Map<String, dynamic> json) {
    return Portafolio(
      idportafolio: json['idportafolio'].toString(),
      elperiodo: json['elperiodo'],
      lapersona: json['lapersona'],
    );
  }
}
