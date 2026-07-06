import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'LoginPagex.dart';
import 'RegistroPage.dart';
import 'ChatbotScreen.dart';
import 'PerfilUsuarioPage.dart';
import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

  String initialRoute = '/loginx';
  if (isLoggedIn) {
    if (biometricsEnabled) {
      initialRoute = '/login';
    } else {
      // In SICA, if they are logged in but no biometrics, they typically go to home
      // but if we want to force login:
      initialRoute = '/home';
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edubot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/loginx': (context) => const LoginPagex(),
        '/registro': (context) => const RegistroPage(),
        '/home': (context) => const HomePage(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/perfil': (context) {
          final idpersona = ModalRoute.of(context)?.settings.arguments as String?;
          return YoWrapperPage(idpersona: idpersona ?? '');
        },
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final idpersona = ModalRoute.of(context)?.settings.arguments as String?;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edubot - Inicio'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/loginx');
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Cinta de menú deslizable horizontalmente (Menu Ribbon)
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildMenuRibbonItem(
                  context: context,
                  label: 'Asistente IA',
                  icon: Icons.chat_bubble_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)], // Indigo gradient
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                ),
                _buildMenuRibbonItem(
                  context: context,
                  label: 'Yo (Mi Perfil)',
                  icon: Icons.person_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)], // Teal/cyan gradient
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/perfil', arguments: idpersona);
                  },
                ),
                _buildMenuRibbonItem(
                  context: context,
                  label: 'ComUniTi',
                  icon: Icons.storefront_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEA580C), Color(0xFFF97316)], // Orange gradient
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Módulo ComUniTi (Próximamente)')),
                    );
                  },
                ),
                _buildMenuRibbonItem(
                  context: context,
                  label: 'Salud',
                  icon: Icons.favorite_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE11D48), Color(0xFFF43F5E)], // Rose/pink gradient
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Módulo Salud (Próximamente)')),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Bienvenido al nuevo proyecto Edubot.\nID Persona: ${idpersona ?? "Desconocido"}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YoWrapperPage extends StatefulWidget {
  final String idpersona;

  const YoWrapperPage({super.key, required this.idpersona});

  @override
  State<YoWrapperPage> createState() => _YoWrapperPageState();
}

class _YoWrapperPageState extends State<YoWrapperPage> {
  Persona? _persona;
  List<Perfil> _perfiles = [];
  Perfil? _perfilSeleccionado;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final persona = await ApiService.fetchPersonaInfo(widget.idpersona);
      final perfiles = await ApiService.fetchPerfiles(persona.idusuario);
      
      setState(() {
        _persona = persona;
        _perfiles = perfiles;
        if (_perfiles.isNotEmpty) {
          _perfilSeleccionado = _perfiles.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil (Yo)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _persona == null 
          ? const Center(child: Text('No se pudo cargar la información.'))
          : PerfilUsuarioPage(
              persona: _persona,
              perfiles: _perfiles,
              perfil: _perfilSeleccionado,
              onPerfilChanged: (p) => setState(() => _perfilSeleccionado = p),
            ),
    );
  }
}
