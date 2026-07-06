import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EdubotDrawer extends StatelessWidget {
  final String idpersona;

  const EdubotDrawer({
    super.key,
    required this.idpersona,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Premium Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D3142), Color(0xFF4F5D75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white24,
              child: ClipOval(
                child: Image.network(
                  'https://educaysoft.org/sica/images/logo.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.school,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            accountName: const Text(
              'Edubot AI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            accountEmail: Text(
              'ID Persona: $idpersona',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          
          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.chat_bubble_rounded,
                  label: 'Asistente IA',
                  iconColor: const Color(0xFF4F46E5),
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.pushNamed(context, '/chatbot');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_rounded,
                  label: 'Yo (Mi Perfil)',
                  iconColor: const Color(0xFF0D9488),
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.pushNamed(context, '/perfil', arguments: idpersona);
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.storefront_rounded,
                  label: 'ComUniTi (Marketplace)',
                  iconColor: const Color(0xFFEA580C),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Módulo ComUniTi (Próximamente)')),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_rounded,
                  label: 'Salud',
                  iconColor: const Color(0xFFE11D48),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Módulo Salud (Próximamente)')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer with Logout
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            onTap: () async {
              Navigator.pop(context); // Close Drawer
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/loginx');
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }
}
