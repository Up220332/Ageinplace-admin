import 'package:ageinplace_admin/SuperAdmin/screen_ModPaciente.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_NewPaciente.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_PacientesInact.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../BarraLateral/NavBar_admin.dart';
import '../BarraLateral/NavBar_super_admin.dart';
import '../base_de_datos/postgres.dart';

class PacientesScreen extends StatefulWidget {
  final String role;

  const PacientesScreen({super.key, required this.role});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  List<Pacientes> PacientesList = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  
  // Mapa para cachear si el paciente tiene vivienda activa
  Map<int, bool> _tieneViviendaActiva = {};

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Pacientes',
      'no_hay': 'No hay pacientes activos',
      'anade': 'Pacientes inactivos usando el botón rojo',
      'inactivos': 'Pacientes Inactivos',
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'direccion': 'Dirección',
      'patologia': 'Patología',
      'autonomia': 'Autonomía',
      'estado': 'Estado',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'editar': 'Editar Paciente',
      'desactivar': 'Desactivar Paciente',
      'vivienda_actual': 'Vivienda actual',
      'no_vivienda': 'Sin vivienda asignada',
      'cancelar': 'Cancelar',
      'confirmar_desactivar': '¿Estás seguro de desactivar a',
      'desactivando': 'Desactivando...',
      'sin_vivienda_activa': '⚠️ Sin vivienda asignada',
      'ultima_vivienda': 'Última vivienda conocida (dado de baja)',
    },
    'en': {
      'titulo': 'Patients',
      'no_hay': 'No active patients',
      'anade': 'Inactive patients using the red button',
      'inactivos': 'Inactive Patients',
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'direccion': 'Address',
      'patologia': 'Pathology',
      'autonomia': 'Autonomy',
      'estado': 'Status',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'editar': 'Edit Patient',
      'desactivar': 'Deactivate Patient',
      'vivienda_actual': 'Current housing',
      'no_vivienda': 'No housing assigned',
      'cancelar': 'Cancel',
      'confirmar_desactivar': 'Are you sure you want to deactivate',
      'desactivando': 'Deactivating...',
      'sin_vivienda_activa': '⚠️ No housing assigned',
      'ultima_vivienda': 'Last known housing (deactivated)',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Función helper para determinar estado
  String determinarEstado(DateTime? fechaBaja) {
    return fechaBaja == null ? 'Activo' : 'Inactivo';
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetPacientes();
    
    // Limpiar cache anterior
    _tieneViviendaActiva.clear();
    
    setState(() {
      PacientesList.clear();
      for (var p in Dbdata) {
        // Solo pacientes ACTIVOS (F_BAJA is null)
        if (p[9] == null) {
          PacientesList.add(
            Pacientes(
              p[0],  // CodUsuario
              p[1] ?? '',  // Nombre
              p[2] ?? '',  // Apellido1
              p[3] ?? '',  // Apellido2
              p[4] ?? '',  // FechaNacimiento
              p[5] ?? '',  // Telefono
              p[6] ?? '',  // Email
              p[7] ?? '',  // Organizacion
              p[8],  // F_ALTA
              p[9],  // F_BAJA (USUARIO_PRIVADO)
              p[10] ?? '', // Direccion
              p[11] ?? '', // Numero
              p[12] ?? '', // Piso
              p[13] ?? '', // Puerta
              p[14] ?? '', // Localidad
              p[15] ?? '', // Provincia
              p[16] ?? '', // VarSocial
              p[17] ?? '', // VarSanitaria
              p[18], // F_BAJA_Casa
              determinarEstado(p[9]),
            ),
          );
          
          // Verificar si tiene vivienda activa (de manera asíncrona)
          _verificarViviendaActiva(p[0]);
        }
      }
    });
    return 'Successfully Fetched data';
  }

  // Método para verificar si el paciente tiene vivienda activa
  Future<void> _verificarViviendaActiva(int codUsuario) async {
    try {
      // Obtenemos TODAS las viviendas activas
      var viviendas = await DBPostgres().DBGetVivienda('null');
      
      // Por cada vivienda, verificamos si el paciente está asignado activamente
      for (var vivienda in viviendas) {
        int codCasa = vivienda[0];
        
        // Obtenemos los pacientes activos de esa vivienda
        var pacientesVivienda = await DBPostgres().DBGetPacientesVivienda(
          codCasa, 
          'null'  // Solo pacientes activos en la vivienda
        );
        
        // Buscamos si nuestro paciente está en esa lista
        for (var p in pacientesVivienda) {
          if (p[0] == codUsuario) {
            if (mounted) {
              setState(() {
                _tieneViviendaActiva[codUsuario] = true;
              });
            }
            return;
          }
        }
      }
      
      // Si no se encontró en ninguna vivienda activa
      if (mounted) {
        setState(() {
          _tieneViviendaActiva[codUsuario] = false;
        });
      }
      
    } catch (e) {
      print('Error verificando vivienda para usuario $codUsuario: $e');
      if (mounted) {
        setState(() {
          _tieneViviendaActiva[codUsuario] = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    PacientesList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
            child: PacientesList.isEmpty
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
                    itemCount: PacientesList.length,
                    itemBuilder: (context, index) {
                      return _buildPacienteCard(context, index);
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
          // BOTÓN DE PACIENTES INACTIVOS
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PacientesInactivosScreen(role: widget.role),
              ),
            ).then((_) => getData()),
            backgroundColor: Colors.red,
            label: Text(
              t('inactivos'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.visibility_off, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPacienteCard(BuildContext context, int index) {
    final paciente = PacientesList[index];
    bool tieneViviendaActiva = _tieneViviendaActiva[paciente.CodUsuario] ?? false;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return PacienteModal(
                paciente: paciente,
                role: widget.role,
                tieneViviendaActiva: tieneViviendaActiva,
                onStatusChanged: () {
                  getData();
                },
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
                    '${paciente.Nombre[0]}${paciente.Apellido1[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Información del paciente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${paciente.Nombre} ${paciente.Apellido1} ${paciente.Apellido2}',
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
                            paciente.Email,
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
                        Icon(
                          tieneViviendaActiva ? Icons.home : Icons.home_work,
                          size: 14, 
                          color: tieneViviendaActiva 
                              ? Colors.green.shade500 
                              : Colors.orange.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getTextoDireccion(paciente, tieneViviendaActiva),
                            style: TextStyle(
                              fontSize: 13,
                              color: tieneViviendaActiva
                                  ? Colors.grey.shade600
                                  : Colors.orange.shade700,
                              fontWeight: tieneViviendaActiva 
                                  ? FontWeight.normal 
                                  : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
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

  String _getTextoDireccion(Pacientes paciente, bool tieneViviendaActiva) {
    if (!tieneViviendaActiva) {
      return t('sin_vivienda_activa');
    }
    if (paciente.Direccion.isNotEmpty) {
      return '${paciente.Direccion}, ${paciente.Localidad}';
    }
    return t('no_vivienda');
  }
}

/// *****************************************************************************
/// Modal para mostrar los datos del paciente
///****************************************************************************
class PacienteModal extends StatefulWidget {
  final Pacientes paciente;
  final String role;
  final bool tieneViviendaActiva;
  final VoidCallback onStatusChanged;

  const PacienteModal({
    super.key,
    required this.paciente,
    required this.role,
    required this.tieneViviendaActiva,
    required this.onStatusChanged,
  });

  @override
  State<PacienteModal> createState() => _PacienteModalState();
}

class _PacienteModalState extends State<PacienteModal> {
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  bool _isLoading = false;

  final Map<String, Map<String, String>> translations = {
    'es': {
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'direccion': 'Dirección',
      'patologia': 'Patología',
      'autonomia': 'Autonomía',
      'estado': 'Estado',
      'activo': 'Activo',
      'editar': 'Editar Paciente',
      'desactivar': 'Desactivar Paciente',
      'vivienda_actual': 'Vivienda actual',
      'no_vivienda': 'Sin vivienda asignada',
      'cancelar': 'Cancelar',
      'confirmar_desactivar': '¿Estás seguro de desactivar a',
      'desactivando': 'Desactivando...',
      'sin_vivienda_activa': '⚠️ Sin vivienda asignada actualmente',
      'ultima_vivienda': 'Última vivienda conocida (dado de baja)',
    },
    'en': {
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'direccion': 'Address',
      'patologia': 'Pathology',
      'autonomia': 'Autonomy',
      'estado': 'Status',
      'activo': 'Active',
      'editar': 'Edit Patient',
      'desactivar': 'Deactivate Patient',
      'vivienda_actual': 'Current housing',
      'no_vivienda': 'No housing assigned',
      'cancelar': 'Cancel',
      'confirmar_desactivar': 'Are you sure you want to deactivate',
      'desactivando': 'Deactivating...',
      'sin_vivienda_activa': '⚠️ No housing currently assigned',
      'ultima_vivienda': 'Last known housing (deactivated)',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Map<String, String> translationsVarSocial = {
    "Autónomo": "Autonomous",
    "Dependiente grave": "Severely Dependent",
    "Dependiente leve": "Mildly Dependent",
    "Riesgo aislamiento": "Isolation Risk",
    "Tensiones económicas": "Economic Tensions",
    "Con red social de apoyo": "With Social Support Network",
    "Red social apoyo reducida": "Reduced Social Support Network",
    "Sin red social de apoyo": "Without Social Support Network",
    "Otros": "Others",
  };

  Map<String, String> translationsVarSanitaria = {
    "Adicciones": "Addictions",
    "Alzheimer": "Alzheimer",
    "Anemia": "Anemia",
    "Ansiedad": "Anxiety",
    "Artrosis": "Osteoarthritis",
    "Cáncer": "Cancer",
    "Demencia": "Dementia",
    "Depresion": "Depression",
    "Diabetes": "Diabetes",
    "Esquizofrenia": "Schizophrenia",
    "Fragilidad": "Frailty",
    "Hipertensión": "Hypertension",
    "Ictus": "Stroke",
    "Incontinencia Urinaria": "Urinary Incontinence",
    "Infarto": "Heart Attack",
    "Osteoporosis": "Osteoporosis",
    "Parkinson": "Parkinson's",
    "Problemas auditivos": "Hearing Problems",
    "Problemas visuales": "Visual Problems",
    "Sano": "Healthy",
    "Trastornos de sueño": "Sleep Disorders",
    "Trastornos mentales": "Mental Disorders",
    "Otros": "Others",
  };

  String getTranslatedSocialVar(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      List<String> parts = original.split(', ');
      List<String> translatedParts = parts.map((part) {
        return translationsVarSocial[part] ?? part;
      }).toList();
      return translatedParts.join(', ');
    }
    return original;
  }

  String getTranslatedSanitariaVar(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      List<String> parts = original.split(', ');
      List<String> translatedParts = parts.map((part) {
        return translationsVarSanitaria[part] ?? part;
      }).toList();
      return translatedParts.join(', ');
    }
    return original;
  }

  Future<void> _desactivarPaciente() async {
    setState(() => _isLoading = true);

    try {
      var result = await DBPostgres().DBActDesActPaciente(
        widget.paciente.CodUsuario,
        0,
        'CURRENT_TIMESTAMP',
        'CURRENT_TIMESTAMP',
        'CURRENT_TIMESTAMP',
      );

      if (result == 'Correcto' && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paciente desactivado correctamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        widget.onStatusChanged();
      } else if (context.mounted) {
        _showErrorDialog('Error al desactivar el paciente');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog('Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 10),
            Text(t('desactivar')),
          ],
        ),
        content: Text(
          '${t('confirmar_desactivar')} ${widget.paciente.Nombre} ${widget.paciente.Apellido1}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('cancelar'),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _desactivarPaciente();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(t('desactivar'), style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Aceptar',
              style: TextStyle(color: colorPrimario),
            ),
          ),
        ],
      ),
    );
  }

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
                    '${widget.paciente.Nombre[0]}${widget.paciente.Apellido1[0]}',
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
              '${widget.paciente.Nombre} ${widget.paciente.Apellido1} ${widget.paciente.Apellido2}',
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
              value: widget.paciente.Email,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.phone,
              label: t('telefono'),
              value: widget.paciente.Telefono,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.cake,
              label: t('fecha_nacimiento'),
              value: widget.paciente.FechaNacimiento,
            ),
            
            const SizedBox(height: 12),
            
            // Tarjeta de dirección con información de estado
            _buildDireccionCard(),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.medical_services,
              label: t('patologia'),
              value: getTranslatedSanitariaVar(widget.paciente.VarSanitaria),
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.accessibility_new,
              label: t('autonomia'),
              value: getTranslatedSocialVar(widget.paciente.VarSocial),
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
            
            const SizedBox(height: 24),
            
            // BOTÓN DESACTIVAR
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: t('desactivar'),
                    icon: Icons.block,
                    color: Colors.red,
                    onPressed: _isLoading ? null : () => _showConfirmDialog(context),
                    isLoading: _isLoading,
                    loadingText: t('desactivando'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // BOTÓN EDITAR
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: t('editar'),
                    icon: Icons.edit,
                    color: colorPrimario,
                    onPressed: _isLoading ? null : () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModPacienteScreen(
                            paciente: widget.paciente,
                            role: widget.role,
                          ),
                        ),
                      ).then((_) => widget.onStatusChanged());
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

  Widget _buildDireccionCard() {
    String direccionCompleta = '';
    if (widget.paciente.Direccion.isNotEmpty) {
      direccionCompleta = '${widget.paciente.Direccion}, ${widget.paciente.Numero}';
      if (widget.paciente.Piso.isNotEmpty) {
        direccionCompleta += ', ${widget.paciente.Piso}${widget.paciente.Puerta}';
      }
      direccionCompleta += ', ${widget.paciente.Localidad}, ${widget.paciente.Provincia}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.tieneViviendaActiva 
              ? Colors.green.withOpacity(0.3) 
              : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.tieneViviendaActiva 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.tieneViviendaActiva ? Icons.home : Icons.home_work,
                  size: 20, 
                  color: widget.tieneViviendaActiva 
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('direccion'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      direccionCompleta.isNotEmpty ? direccionCompleta : t('no_vivienda'),
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
          if (!widget.tieneViviendaActiva && direccionCompleta.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t('ultima_vivienda'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
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
    required VoidCallback? onPressed,
    bool isLoading = false,
    String loadingText = '',
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: Colors.white),
        label: Text(
          isLoading ? loadingText : label,
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

class Pacientes {
  final int CodUsuario;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final DateTime F_ALTA;
  final DateTime? F_BAJA_Usuario;
  final String Direccion;
  final String Numero;
  final String Piso;
  final String Puerta;
  final String Localidad;
  final String Provincia;
  final String VarSocial;
  final String VarSanitaria;
  final DateTime? F_BAJA_Casa;
  final String Estado;

  // Propiedades adicionales para compatibilidad
  String get DesVarSocial => '';
  String get DesVarSanitaria => '';

  Pacientes(
    this.CodUsuario,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Email,
    this.Organizacion,
    this.F_ALTA,
    this.F_BAJA_Usuario,
    this.Direccion,
    this.Numero,
    this.Piso,
    this.Puerta,
    this.Localidad,
    this.Provincia,
    this.VarSocial,
    this.VarSanitaria,
    this.F_BAJA_Casa,
    this.Estado,
  );
}