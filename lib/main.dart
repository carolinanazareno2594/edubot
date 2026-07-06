import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'LoginPagex.dart';
import 'RegistroPage.dart';
import 'ChatbotScreen.dart';

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
          // Menú horizontal sin opciones
          Container(
            height: 60,
            color: Colors.blue.shade100,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Aquí irían las opciones del menú horizontal, por ahora está vacío o con placeholders deshabilitados
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Menú Horizontal:',
                      style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Asistente IA'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/chatbot');
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
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
