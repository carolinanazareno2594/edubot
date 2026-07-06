import "package:flutter/material.dart";
import "api_service.dart";

class PerfilUsuarioPage extends StatefulWidget {
  final Persona? persona;
  final Perfil? perfil;
  final List<Perfil> perfiles;
  final Function(Perfil)? onPerfilChanged;

  const PerfilUsuarioPage({
    Key? key,
    this.persona,
    this.perfil,
    this.perfiles = const [],
    this.onPerfilChanged,
  }) : super(key: key);

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  late Future<List<Portafolio>> _portafolioFuture;

  @override
  void initState() {
    super.initState();
    if (widget.persona != null) {
      _portafolioFuture = ApiService.fetchPortafolio(widget.persona!.idpersona);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.persona == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final fotoUrl =
        "https://educaysoft.org/descargar2.php?archivo=${widget.persona!.cedula}.jpg";

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FA),
      child: ListView(
        children: [
          const SizedBox(height: 40),
          // Imagen del usuario en el centro superior
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  fotoUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // ID del usuario
          Center(
            child: Text(
              'Usuario ID: ${widget.persona!.idusuario}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Nombres del usuario
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.persona!.lapersona,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Cédula: ${widget.persona!.cedula}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // SECCIÓN: TUS PERFILES
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.badge, size: 20, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Tus Perfiles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Listado de perfiles (ahora dentro del ListView)
          ...widget.perfiles.map((p) {
            final isSelected = p.idperfil == widget.perfil?.idperfil;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent.withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isSelected ? Colors.blueAccent : Colors.grey[100],
                  child: Icon(
                    Icons.person_outline,
                    color: isSelected ? Colors.white : Colors.blueAccent,
                  ),
                ),
                title: Text(
                  p.nombre,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blueAccent : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                    : const Icon(Icons.arrow_forward_ios,
                        size: 14, color: Colors.grey),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Perfil: ${p.nombre} seleccionado'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  if (widget.onPerfilChanged != null) {
                    widget.onPerfilChanged!(p);
                  }
                },
              ),
            );
          }).toList(),

          const SizedBox(height: 30),

          // SECCIÓN: TU PORTAFOLIO
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.folder_shared, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Tu Portafolio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Listado de portafolios con FutureBuilder
          FutureBuilder<List<Portafolio>>(
            future: _portafolioFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Error al cargar portafolios',
                      style: TextStyle(color: Colors.red[700])),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final portafolios = snapshot.data!;
                return Column(
                  children: portafolios.map((p) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.folder_open,
                            color: Colors.orange, size: 28),
                        title: Text(
                          'Portafolio: ${p.idportafolio}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${p.lapersona}\n${p.elperiodo}',
                            style: const TextStyle(fontSize: 12)),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new,
                              color: Colors.blueAccent),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ver documentos de portafolio ${p.idportafolio} (No implementado)')),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: Text('No hay portafolios para mostrar.')),
                );
              }
            },
          ),

          const SizedBox(height: 40),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'SICA - Gestión de Perfil',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
