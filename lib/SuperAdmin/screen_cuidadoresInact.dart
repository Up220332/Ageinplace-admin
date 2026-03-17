import 'package:ageinplace_admin/E-MailSender/E-MailSend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';
import 'screen_Cuidadores.dart';

/// *****************************************************************************
/// Funcion que muestra todos los cuidadores inactivos
///****************************************************************************
class CuidadoresInactScreen extends StatefulWidget {
  const CuidadoresInactScreen({super.key});

  @override
  State<CuidadoresInactScreen> createState() => _CuidadoresInactScreenState();
}

class _CuidadoresInactScreenState extends State<CuidadoresInactScreen> {
  List<Cuidadores> CuidadoresList = [];
  List<CuidadoresCasa> CuidadoresCasList = [];
  List<Cuidadores> Filtro_Status = [];
  
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Cuidadores Inactivos',
      'no_hay': 'No hay cuidadores inactivos',
      'descripcion': 'Los cuidadores desactivados aparecerán aquí',
      'inactivo': 'Inactivo',
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'organizacion': 'Organización',
      'estado': 'Estado',
      'activar': 'Activar Cuidador',
      'aceptar': 'Aceptar',
    },
    'en': {
      'titulo': 'Inactive Caregivers',
      'no_hay': 'No inactive caregivers',
      'descripcion': 'Deactivated caregivers will appear here',
      'inactivo': 'Inactive',
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'organizacion': 'Organization',
      'estado': 'Status',
      'activar': 'Activate Caregiver',
      'aceptar': 'Accept',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Mapa de traducciones para estados
  Map<String, String> statusTranslations = {
    'Activo': 'Active',
    'Inactivo': 'Inactive',
  };

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetCuidador('not null');
    String Estado;
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
            Estado,
          ),
        );
      }
      for (var p in Dbdata[1]) {
        CuidadoresCasList.add(CuidadoresCasa(p[0], p[1], p[2]));
      }
    });
    Filtro_Status = CuidadoresList.where(
      (Estado) => Estado.Estado == 'Inactivo',
    ).toList();
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    CuidadoresList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CuidadoresScreen(role: 'superadmin'),
          ),
        );
        return false;
      },
      child: Scaffold(
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
            child: Filtro_Status.isEmpty
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
                          t('descripcion'),
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: Filtro_Status.length,
                    itemBuilder: (context, index) {
                      return _buildCuidadorCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCuidadorCard(BuildContext context, int index) {
    final cuidador = Filtro_Status[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return CuidadorModal(cuidador: cuidador);
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
              // Avatar con iniciales (en rojo para inactivos)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.7),
                      Colors.red,
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
              
              // Chip de estado INACTIVO
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t('inactivo'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
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
/// Modal para mostrar los datos del cuidador inactivo
///****************************************************************************
class CuidadorModal extends StatelessWidget {
  final Cuidadores cuidador;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  CuidadorModal({super.key, required this.cuidador});

  // Mapa de traducciones para el modal
  final Map<String, Map<String, String>> translations = {
    'es': {
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'organizacion': 'Organización',
      'estado': 'Estado',
      'inactivo': 'Inactivo',
      'activar': 'Activar Cuidador',
      'aceptar': 'Aceptar',
    },
    'en': {
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'organizacion': 'Organization',
      'estado': 'Status',
      'inactivo': 'Inactive',
      'activar': 'Activate Caregiver',
      'aceptar': 'Accept',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Map<String, String> StatusTranslations = {
    'Activo': 'Active',
    'Inactivo': 'Inactive',
  };

  @override
  Widget build(BuildContext context) {
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
            
            // Avatar grande (en rojo para inactivo)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.7),
                      Colors.red,
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
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
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
                    StatusTranslations[cuidador.Estado] ?? t('inactivo'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botón de activar
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (await DBPostgres().DBActDesActCuidador(
                        cuidador.CodUsuario,
                        null,
                      ) ==
                      'Correcto') {
                    SendAlta(cuidador.Email);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CuidadoresScreen(role: 'superadmin'),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: Text(
                  t('activar'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
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
}

class Cuidadores {
  final int CodUsuario;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Estado;

  Cuidadores(
    this.CodUsuario,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Email,
    this.Organizacion,
    this.F_ALTA,
    this.F_BAJA,
    this.Estado,
  );
}

class CuidadoresCasa {
  final int CodUsuarioCuidador;
  final int CodCasa;
  final String Dirrecion;

  CuidadoresCasa(this.CodUsuarioCuidador, this.CodCasa, this.Dirrecion);
}