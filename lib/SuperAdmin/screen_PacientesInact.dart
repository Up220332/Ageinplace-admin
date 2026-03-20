import 'package:ageinplace_admin/SuperAdmin/screen_ModPaciente.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_Pacientes.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

/// *****************************************************************************
/// Pantalla que muestra todos los pacientes inactivos
///****************************************************************************
class PacientesInactivosScreen extends StatefulWidget {
  final String role;

  const PacientesInactivosScreen({super.key, required this.role});

  @override
  State<PacientesInactivosScreen> createState() => _PacientesInactivosScreenState();
}

class _PacientesInactivosScreenState extends State<PacientesInactivosScreen> {
  List<PacientesInactivos> pacientesInactivosList = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Pacientes Inactivos',
      'no_hay': 'No hay pacientes inactivos',
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'direccion': 'Dirección',
      'patologia': 'Patología',
      'autonomia': 'Autonomía',
      'estado': 'Estado',
      'inactivo': 'Inactivo',
      'fecha_baja': 'Fecha de baja',
      'activar': 'Activar Paciente',
      'editar': 'Editar',
      'cancelar': 'Cancelar',
      'confirmar_activar': '¿Estás seguro de activar a',
      'activando': 'Activando...',
      'no_vivienda': 'Sin vivienda asignada',
    },
    'en': {
      'titulo': 'Inactive Patients',
      'no_hay': 'No inactive patients',
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'direccion': 'Address',
      'patologia': 'Pathology',
      'autonomia': 'Autonomy',
      'estado': 'Status',
      'inactivo': 'Inactive',
      'fecha_baja': 'Deactivation date',
      'activar': 'Activate Patient',
      'editar': 'Edit',
      'cancelar': 'Cancel',
      'confirmar_activar': 'Are you sure you want to activate',
      'activando': 'Activating...',
      'no_vivienda': 'No housing assigned',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetPacientes();
    setState(() {
      pacientesInactivosList.clear();
      for (var p in Dbdata) {
        // Solo pacientes INACTIVOS (F_BAJA no es null)
        if (p[9] != null) {
          pacientesInactivosList.add(
            PacientesInactivos(
              p[0],  // CodUsuario
              p[1],  // Nombre
              p[2],  // Apellido1
              p[3],  // Apellido2
              p[4],  // FechaNacimiento
              p[5],  // Telefono
              p[6],  // Email
              p[7],  // Organizacion
              p[8],  // F_ALTA
              p[9],  // F_BAJA (USUARIO_PRIVADO)
              p[10], // Direccion
              p[11], // Numero
              p[12], // Piso
              p[13], // Puerta
              p[14], // Localidad
              p[15], // Provincia
              p[16], // VarSocial
              p[17], // VarSanitaria
              p[18], // F_BAJA_Casa
            ),
          );
        }
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _activarPaciente(int codUsuario) async {
    try {
      var result = await DBPostgres().DBActDesActPaciente(
        codUsuario,
        0,
        null, // F_BAJA_PACIENTE_CASA = null para activar
        null, // F_BAJA_PACIENTE = null para activar
        null, // F_BAJA_PACIENTE_WEARABLE = null para activar
      );

      if (result == 'Correcto' && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paciente activado correctamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        getData(); // Recargar lista
      } else if (context.mounted) {
        _showErrorDialog('Error al activar el paciente');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog('Error: $e');
      }
    }
  }

  void _showConfirmDialog(BuildContext context, int codUsuario, String nombreCompleto) {
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
            Text(t('activar')),
          ],
        ),
        content: Text(
          '${t('confirmar_activar')} $nombreCompleto?',
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
              Navigator.pop(context); // Cerrar diálogo
              _activarPaciente(codUsuario);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(t('activar')),
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
    pacientesInactivosList.sort((a, b) => b.F_BAJA.compareTo(a.F_BAJA)); // Ordenar por fecha de baja (más reciente primero)
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
            child: pacientesInactivosList.isEmpty
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
                    itemCount: pacientesInactivosList.length,
                    itemBuilder: (context, index) {
                      return _buildPacienteCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPacienteCard(BuildContext context, int index) {
    final paciente = pacientesInactivosList[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return PacienteInactivoModal(
                paciente: paciente,
                role: widget.role,
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
              // Avatar con iniciales (en gris para inactivos)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade400,
                      Colors.grey.shade600,
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
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          '${t('fecha_baja')}: ${formatDate(paciente.F_BAJA, [dd, '/', mm, '/', yyyy])}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Chip de estado inactivo
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
/// Modal para mostrar los datos del paciente inactivo
///****************************************************************************
class PacienteInactivoModal extends StatefulWidget {
  final PacientesInactivos paciente;
  final String role;
  final VoidCallback onStatusChanged;

  const PacienteInactivoModal({
    super.key,
    required this.paciente,
    required this.role,
    required this.onStatusChanged,
  });

  @override
  State<PacienteInactivoModal> createState() => _PacienteInactivoModalState();
}

class _PacienteInactivoModalState extends State<PacienteInactivoModal> {
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
      'inactivo': 'Inactivo',
      'fecha_baja': 'Fecha de baja',
      'activar': 'Activar Paciente',
      'editar': 'Editar',
      'cancelar': 'Cancelar',
      'confirmar_activar': '¿Estás seguro de activar a',
      'activando': 'Activando...',
      'no_vivienda': 'Sin vivienda asignada',
    },
    'en': {
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'direccion': 'Address',
      'patologia': 'Pathology',
      'autonomia': 'Autonomy',
      'estado': 'Status',
      'inactivo': 'Inactive',
      'fecha_baja': 'Deactivation date',
      'activar': 'Activate Patient',
      'editar': 'Edit',
      'cancelar': 'Cancel',
      'confirmar_activar': 'Are you sure you want to activate',
      'activando': 'Activating...',
      'no_vivienda': 'No housing assigned',
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

  Future<void> _activarPaciente() async {
    setState(() => _isLoading = true);

    try {
      var result = await DBPostgres().DBActDesActPaciente(
        widget.paciente.CodUsuario,
        0,
        null,
        null,
        null,
      );

      if (result == 'Correcto' && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paciente activado correctamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        widget.onStatusChanged();
      } else if (context.mounted) {
        _showErrorDialog('Error al activar el paciente');
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
            Text(t('activar')),
          ],
        ),
        content: Text(
          '${t('confirmar_activar')} ${widget.paciente.Nombre} ${widget.paciente.Apellido1}?',
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
              _activarPaciente();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(t('activar'),style: TextStyle(color: Colors.white),),
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
            
            // Avatar grande (en gris para inactivos)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade400,
                      Colors.grey.shade600,
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
            
            const SizedBox(height: 8),
            
            // Fecha de baja
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${t('fecha_baja')}: ${formatDate(widget.paciente.F_BAJA, [dd, '/', mm, '/', yyyy])}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
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
            
            _buildInfoCard(
              icon: Icons.home,
              label: t('direccion'),
              value: widget.paciente.F_BAJA_Casa == null
                  ? '${widget.paciente.Direccion}, ${widget.paciente.Numero}, ${widget.paciente.Piso}${widget.paciente.Puerta}, ${widget.paciente.Localidad}, ${widget.paciente.Provincia}'
                  : t('no_vivienda'),
            ),
            
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
                    t('inactivo'),
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
            
            // BOTÓN ACTIVAR (verde)
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: t('activar'),
                    icon: Icons.check_circle,
                    color: Colors.green,
                    onPressed: _isLoading ? null : () => _showConfirmDialog(context),
                    isLoading: _isLoading,
                    loadingText: t('activando'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // BOTÓN EDITAR (azul)
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: t('editar'),
                    icon: Icons.edit,
                    color: colorPrimario,
                    onPressed: _isLoading ? null : () {
                      Navigator.pop(context);
                      
                      // Crear un objeto Pacientes a partir de PacientesInactivos
                      final pacienteActivo = Pacientes(
                        widget.paciente.CodUsuario,
                        widget.paciente.Nombre,
                        widget.paciente.Apellido1,
                        widget.paciente.Apellido2,
                        widget.paciente.FechaNacimiento,
                        widget.paciente.Telefono,
                        widget.paciente.Email,
                        widget.paciente.Organizacion,
                        widget.paciente.F_ALTA,
                        widget.paciente.F_BAJA,
                        widget.paciente.Direccion,
                        widget.paciente.Numero,
                        widget.paciente.Piso,
                        widget.paciente.Puerta,
                        widget.paciente.Localidad,
                        widget.paciente.Provincia,
                        widget.paciente.VarSocial,
                        widget.paciente.VarSanitaria,
                        widget.paciente.F_BAJA_Casa,
                        'Inactivo',
                      );
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModPacienteScreen(
                            paciente: pacienteActivo,
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

class PacientesInactivos {
  final int CodUsuario;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final DateTime F_ALTA;
  final DateTime F_BAJA;
  final String Direccion;
  final String Numero;
  final String Piso;
  final String Puerta;
  final String Localidad;
  final String Provincia;
  final String VarSocial;
  final String VarSanitaria;
  final DateTime? F_BAJA_Casa;

  PacientesInactivos(
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
    this.Direccion,
    this.Numero,
    this.Piso,
    this.Puerta,
    this.Localidad,
    this.Provincia,
    this.VarSocial,
    this.VarSanitaria,
    this.F_BAJA_Casa,
  );
}