import 'package:ageinplace_admin/E-MailSender/E-MailSend.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_NewCuidador.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_cuidadoresInact.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../BarraLateral/NavBar_admin.dart';
import '../BarraLateral/NavBar_super_admin.dart';
import '../SuperAdmin/screen_ModCuidador.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart'; // Solo para textos generales

/// *****************************************************************************
/// Funcion que muestra todos los cuidadores activos
///****************************************************************************
class CuidadoresScreen extends StatefulWidget {
  final String role;

  const CuidadoresScreen({super.key, required this.role});

  @override
  State<CuidadoresScreen> createState() => _CuidadoresScreenState();
}

class _CuidadoresScreenState extends State<CuidadoresScreen> {
  List<Cuidadores> CuidadoresList = [];
  List<Cuidadores> listaCuidadoresUnicos = [];
  List<CuidadoresCasa> CuidadoresCasList = [];
  List<PacientesCuidadores> PacientesCuidadoresList = [];
  Map<int, String> Direccion = {};
  
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones específico para esta pantalla
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Cuidadores',
      'no_hay': 'No hay cuidadores registrados',
      'anade': 'Añade cuidadores usando el botón +',
      'anadir': 'Añadir Cuidadores',
      'inactivos': 'Cuidadores Inactivos',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'organizacion': 'Organización',
      'estado': 'Estado',
      'desactivar': 'Desactivar',
      'modificar': 'Modificar',
      'viviendas_asignadas': 'Viviendas asignadas',
      'no_viviendas': 'No hay viviendas asignadas',
    },
    'en': {
      'titulo': 'Caregivers',
      'no_hay': 'No caregivers registered',
      'anade': 'Add caregivers using the + button',
      'anadir': 'Add Caregivers',
      'inactivos': 'Inactive Caregivers',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'organizacion': 'Organization',
      'estado': 'Status',
      'desactivar': 'Deactivate',
      'modificar': 'Edit',
      'viviendas_asignadas': 'Assigned houses',
      'no_viviendas': 'No houses assigned',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetCuidador('null');
    String Estado = "";
    setState(() {
      for (var p in Dbdata[0]) {
        if (p[9] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        CuidadoresList.add(
          Cuidadores(
            p[0],
            p[1],
            p[2],
            p[3],
            p[4],
            p[5],
            p[6],
            p[7],
            p[8],
            p[9],
            p[10],
            Estado,
          ),
        );
      }
      for (var p in Dbdata[1]) {
        CuidadoresCasList.add(CuidadoresCasa(p[0], p[1], p[2]));
      }
      for (var p in Dbdata[2]) {
        PacientesCuidadoresList.add(
          PacientesCuidadores(
            p[0],
            p[1],
            p[2],
            p[3],
            p[4],
            p[5],
            p[6],
            p[7],
            p[8],
            p[9],
            p[10],
            Estado,
          ),
        );
      }
    });

    return 'Successfully Fetched data';
  }

  Map<int, String> DirrecionCuidador(
    List<Cuidadores> cuidadoresList,
    List<CuidadoresCasa> cuidadoresCasaList,
  ) {
    Map<int, List<String>> dirrecionesByCodUsuarioCuidador = {};
    Map<String, Cuidadores> emailsUnicos = {};

    for (Cuidadores cuidador in CuidadoresList) {
      if (!emailsUnicos.containsKey(cuidador.Email)) {
        emailsUnicos[cuidador.Email] = cuidador;
      }
    }

    listaCuidadoresUnicos = emailsUnicos.values.toList();

    for (var cuidadorCasa in cuidadoresCasaList) {
      if (!dirrecionesByCodUsuarioCuidador.containsKey(
        cuidadorCasa.CodUsuarioCuidador,
      )) {
        dirrecionesByCodUsuarioCuidador[cuidadorCasa.CodUsuarioCuidador] = [];
      }
      dirrecionesByCodUsuarioCuidador[cuidadorCasa.CodUsuarioCuidador]!.add(
        cuidadorCasa.Dirrecion,
      );
    }

    for (var cuidador in cuidadoresList) {
      if (dirrecionesByCodUsuarioCuidador.containsKey(
        cuidador.CodUsuarioCuidador,
      )) {
        String joinedDirreciones =
            dirrecionesByCodUsuarioCuidador[cuidador.CodUsuarioCuidador]!.join(
              ';\n\n',
            );
        Direccion[cuidador.CodUsuarioCuidador] = joinedDirreciones;
      }
    }
    return Direccion;
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      DirrecionCuidador(CuidadoresList, CuidadoresCasList);
    });
  }

  @override
  Widget build(BuildContext context) {
    CuidadoresList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViviendasScreen(tipoUsuario: widget.role),
          ),
        );
        return false;
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButtons(),
        appBar: AppBar(
          backgroundColor: colorPrimario,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            t('titulo'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        endDrawer: widget.role == 'superadmin' ? NavBarSuperAdmin() : NavBarAdmin(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: listaCuidadoresUnicos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          t('no_hay'),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t('anade'),
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: listaCuidadoresUnicos.length,
                    itemBuilder: (context, index) {
                      return _buildCuidadorCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewCuidadorScreen()),
            ),
            label: Text(
              t('anadir'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            backgroundColor: colorPrimario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CuidadoresInactScreen(),
              ),
            ),
            backgroundColor: Colors.red,
            label: Text(
              t('inactivos'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.visibility_outlined, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuidadorCard(BuildContext context, int index) {
    final cuidador = listaCuidadoresUnicos[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return CuidadorModal(
                cuidador: cuidador,
                direcciones: CuidadoresCasList,
                pacientesCuidadoresList: PacientesCuidadoresList,
                role: widget.role,
              );
            },
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar con iniciales
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPrimario.withOpacity(0.8),
                      colorPrimario,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    '${cuidador.Nombre[0]}${cuidador.Apellido1[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Información del cuidador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cuidador.Nombre} ${cuidador.Apellido1} ${cuidador.Apellido2}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            cuidador.Email,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.business_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          cuidador.Organizacion,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Chip de estado activo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t('activo'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// *****************************************************************************
/// Modal para mostrar los datos del cuidador
///****************************************************************************
class CuidadorModal extends StatelessWidget {
  final String role;
  final Cuidadores cuidador;
  final List<CuidadoresCasa> direcciones;
  final List<PacientesCuidadores> pacientesCuidadoresList;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  CuidadorModal({
    super.key,
    required this.cuidador,
    required this.direcciones,
    required this.pacientesCuidadoresList,
    required this.role,
  });

  // Mapa de traducciones para el modal
  final Map<String, Map<String, String>> translations = {
    'es': {
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'organizacion': 'Organización',
      'estado': 'Estado',
      'activo': 'Activo',
      'viviendas_asignadas': 'Viviendas asignadas',
      'no_viviendas': 'No hay viviendas asignadas',
      'desactivar': 'Desactivar',
      'modificar': 'Modificar',
    },
    'en': {
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'organizacion': 'Organization',
      'estado': 'Status',
      'activo': 'Active',
      'viviendas_asignadas': 'Assigned houses',
      'no_viviendas': 'No houses assigned',
      'desactivar': 'Deactivate',
      'modificar': 'Edit',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  List<String> getDirecciones() {
    List<String> direccionesList = [];
    for (var direccion in direcciones) {
      if (direccion.CodUsuarioCuidador == cuidador.CodUsuarioCuidador) {
        direccionesList.add(direccion.Dirrecion);
      }
    }
    return direccionesList;
  }

  List<String> getPacientes() {
    return pacientesCuidadoresList
        .where((paciente) => paciente.CodCasa == cuidador.CodCasaCuidador)
        .map(
          (paciente) =>
              '${paciente.Nombre} ${paciente.Apellido1} ${paciente.Apellido2}',
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final direccionesList = getDirecciones();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de arrastre
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Avatar grande
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPrimario.withOpacity(0.8),
                      colorPrimario,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${cuidador.Nombre[0]}${cuidador.Apellido1[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nombre completo
            Text(
              '${cuidador.Nombre} ${cuidador.Apellido1} ${cuidador.Apellido2}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B3C),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información en tarjetas
            _buildInfoCard(
              icon: Icons.email,
              label: t('email'),
              value: cuidador.Email,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.phone,
              label: t('telefono'),
              value: cuidador.Telefono,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.cake,
              label: t('fecha_nacimiento'),
              value: cuidador.FechaNacimiento,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.business,
              label: t('organizacion'),
              value: cuidador.Organizacion,
            ),
            
            const SizedBox(height: 12),
            
            // Estado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${t('estado')}:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t('activo'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Casas asignadas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home, size: 20, color: colorPrimario),
                      const SizedBox(width: 8),
                      Text(
                        t('viviendas_asignadas'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (direccionesList.isEmpty)
                    Center(
                      child: Text(
                        t('no_viviendas'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...direccionesList.map(
                      (direccion) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          direccion,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: t('desactivar'),
                    icon: Icons.block,
                    color: Colors.red,
                    onPressed: () async {
                      if (await DBPostgres().DBActDesActCuidador(
                            cuidador.CodUsuarioCuidador,
                            'CURRENT_TIMESTAMP',
                          ) ==
                          'Correcto') {
                        SendBaja(cuidador.Email);
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CuidadoresScreen(role: role),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: t('modificar'),
                    icon: Icons.edit,
                    color: colorPrimario,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ModCuidadorScreen(cuidador: cuidador, role: role),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorPrimario.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: colorPrimario),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A2B3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}

class Cuidadores {
  final int CodUsuarioCuidador;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final int? CodCasaCuidador;
  final String Estado;

  Cuidadores(
    this.CodUsuarioCuidador,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Email,
    this.Organizacion,
    this.F_ALTA,
    this.F_BAJA,
    this.CodCasaCuidador,
    this.Estado,
  );

  Object? get TipoCuidador => null;
}

class CuidadoresCasa {
  final int CodUsuarioCuidador;
  final int CodCasa;
  final String Dirrecion;

  CuidadoresCasa(this.CodUsuarioCuidador, this.CodCasa, this.Dirrecion);
}

class PacientesCuidadores {
  final int CodUsuarioPaceinte;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final int CodCasa;
  final String Estado;

  PacientesCuidadores(
    this.CodUsuarioPaceinte,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Email,
    this.Organizacion,
    this.F_ALTA,
    this.F_BAJA,
    this.CodCasa,
    this.Estado,
  );
}