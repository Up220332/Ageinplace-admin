import 'package:ageinplace_admin/E-MailSender/E-MailSend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../SuperAdmin/screen_PacientesVivienda.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../base_de_datos/postgres.dart';

class PacientesExistentesScreen extends StatefulWidget {
  final String role;
  final Vivienda vivienda;
  List<Paciente> paciente;

  PacientesExistentesScreen({
    super.key,
    required this.vivienda,
    required this.paciente,
    required this.role,
  });

  @override
  State<PacientesExistentesScreen> createState() =>
      _PacientesExistentesScreen();
}

class _PacientesExistentesScreen extends State<PacientesExistentesScreen> {
  List<PacientesExistentes> PacientesExistentesList = [];
  List<Paciente> PacientesCasaList = [];
  late String _currentLocale;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Pacientes Existentes',
      'no_hay': 'No hay pacientes disponibles',
      'organizacion': 'Organización',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'estado': 'Estado',
      'agregar': 'Agregar',
      'no_disponible': 'No disponible',
    },
    'en': {
      'titulo': 'Existing Patients',
      'no_hay': 'No patients available',
      'organizacion': 'Organization',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'estado': 'Status',
      'agregar': 'Add',
      'no_disponible': 'Not available',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Función helper para determinar estado basado en F_BAJA de USUARIO_PRIVADO
  String determinarEstado(DateTime? fechaBaja) {
    return fechaBaja == null ? 'Activo' : 'Inactivo';
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetPacientes();
    var PacienteCasa = await DBPostgres().DBGetPacientesVivienda(
      widget.vivienda.CodCasa,
      'null', // Solo pacientes activos en esta vivienda
    );
    
    setState(() {
      for (var p in Dbdata) {
        PacientesExistentesList.add(
          PacientesExistentes(
            p[0],  // CodUsuario
            p[1],  // Nombre
            p[2],  // Apellido1
            p[3],  // Apellido2
            p[4],  // FechaNacimiento
            p[5],  // Telefono
            p[6],  // Email
            p[7],  // Organizacion
            p[8],  // F_ALTA
            p[9],  // F_BAJA
            determinarEstado(p[9]), // Estado basado en F_BAJA
          ),
        );
      }
      
      for (var p in PacienteCasa) {
        PacientesCasaList.add(
          Paciente(
            p[0],  // CodUsuario
            p[1],  // Nombre
            p[2],  // Apellido1
            p[3],  // Apellido2
            p[4],  // FechaNacimiento
            p[5],  // Telefono
            p[6],  // Email
            p[7],  // Organizacion
            p[8],  // DesVarSocial
            p[9],  // VarSocial
            p[10], // DesVarSanitaria
            p[11], // VarSanitaria
            p[12], // F_ALTA
            p[13], // F_BAJA
            determinarEstado(p[13]), // Estado basado en F_BAJA
          ),
        );
      }
    });
    
    // Filtrar pacientes que ya están asociados a la vivienda
    for (var i = 0; i < widget.paciente.length; i++) {
      for (var j = 0; j < PacientesExistentesList.length; j++) {
        if (widget.paciente[i].CodUsuario ==
            PacientesExistentesList[j].CodUsuario) {
          PacientesExistentesList.removeAt(j);
        }
      }
    }

    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    _currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String newLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (_currentLocale != newLocale) {
      setState(() {
        _currentLocale = newLocale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PacientesExistentesList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PacientesViviendaScreen(
              vivienda: widget.vivienda,
              role: widget.role,
            ),
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
            padding: const EdgeInsets.all(20.0),
            child: PacientesExistentesList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.elderly_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          t('no_hay'),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: PacientesExistentesList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return PacientesModal(
                                paciente: PacientesExistentesList[index],
                                vivienda: widget.vivienda,
                                PacientesCasaList: PacientesCasaList,
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
                                    '${PacientesExistentesList[index].Nombre[0]}${PacientesExistentesList[index].Apellido1[0]}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${PacientesExistentesList[index].Nombre} ${PacientesExistentesList[index].Apellido1} ${PacientesExistentesList[index].Apellido2}',
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
                                            PacientesExistentesList[index].Email,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: PacientesExistentesList[index].Estado == 'Activo' 
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      PacientesExistentesList[index].Estado == 'Activo' 
                                          ? t('activo')
                                          : t('inactivo'),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: PacientesExistentesList[index].Estado == 'Activo' 
                                            ? Colors.green 
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      PacientesExistentesList[index].Organizacion,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorPrimario,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class PacientesModal extends StatelessWidget {
  final String role;
  final PacientesExistentes paciente;
  final Vivienda vivienda;
  List PacientesCasaList;

  PacientesModal({
    super.key,
    required this.paciente,
    required this.vivienda,
    required this.PacientesCasaList,
    required this.role,
  });

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  final Map<String, Map<String, String>> translations = {
    'es': {
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'estado': 'Estado',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'agregar': 'Agregar a la vivienda',
      'no_disponible': 'No disponible para agregar',
      'organizacion': 'Organización',
      'mensaje_inactivo': 'Este paciente está INACTIVO y no puede ser agregado a ninguna vivienda',
    },
    'en': {
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'estado': 'Status',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'agregar': 'Add to housing',
      'no_disponible': 'Not available to add',
      'organizacion': 'Organization',
      'mensaje_inactivo': 'This patient is INACTIVE and cannot be added to any housing',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    bool pacienteActivo = paciente.Estado == 'Activo';
    
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
            Stack(
              alignment: Alignment.bottomRight,
              children: [
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
                        '${paciente.Nombre[0]}${paciente.Apellido1[0]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!pacienteActivo)
                  Positioned(
                    right: 25,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.block,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${paciente.Nombre} ${paciente.Apellido1} ${paciente.Apellido2}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B3C),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              icon: Icons.email,
              label: t('email'),
              value: paciente.Email,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.phone,
              label: t('telefono'),
              value: paciente.Telefono,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.cake,
              label: t('fecha_nacimiento'),
              value: paciente.FechaNacimiento,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.business,
              label: t('organizacion'),
              value: paciente.Organizacion,
            ),
            const SizedBox(height: 12),
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
                      color: (pacienteActivo ? Colors.green : Colors.red).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      pacienteActivo ? Icons.check_circle : Icons.cancel,
                      color: pacienteActivo ? Colors.green : Colors.red,
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
                    pacienteActivo ? t('activo') : t('inactivo'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: pacienteActivo ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!pacienteActivo)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t('mensaje_inactivo'),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 6),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: pacienteActivo 
                      ? () async {
                          if (await DBPostgres().DBAddPaciente(
                                paciente.CodUsuario,
                                vivienda.CodCasa,
                              ) ==
                              'Correcto') {
                            SendAlta(paciente.Email);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PacientesViviendaScreen(
                                    vivienda: vivienda,
                                    role: role,
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pacienteActivo ? colorPrimario : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: pacienteActivo ? 2 : 0,
                  ),
                  child: Text(
                    pacienteActivo ? t('agregar') : t('no_disponible'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

class PacientesExistentes {
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

  PacientesExistentes(
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