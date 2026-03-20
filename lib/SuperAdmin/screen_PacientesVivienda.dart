library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:marquee/marquee.dart';

import '../BarraLateral/NavBar_admin.dart';
import '../SuperAdmin/screen_ModPacienteVivienda.dart';
import '../SuperAdmin/screen_NewPaciente.dart';
import '../SuperAdmin/screen_PacientesExistentes.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../SuperAdmin/screen_wearables.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

class PacientesViviendaScreen extends StatefulWidget {
  final String role;
  final Vivienda vivienda;

  const PacientesViviendaScreen({
    super.key,
    required this.vivienda,
    required this.role,
  });

  @override
  State<PacientesViviendaScreen> createState() =>
      _PacientesViviendaScreenSate();
}

class _PacientesViviendaScreenSate extends State<PacientesViviendaScreen> {
  List<Paciente> PacientesViviendaList = [];

  // Función helper para determinar estado basado en F_BAJA
  String determinarEstado(DateTime? fechaBaja) {
    return fechaBaja == null ? 'Activo' : 'Inactivo';
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetPacientesVivienda(
      widget.vivienda.CodCasa,
      'null', // Esto trae SOLO pacientes activos en la vivienda (F_BAJA is null)
    );

    setState(() {
      PacientesViviendaList.clear();
      for (var p in Dbdata) {
        // Como pedimos 'null', todos los que vienen tienen F_BAJA = null
        // y por lo tanto están activos en la vivienda
        PacientesViviendaList.add(
          Paciente(
            p[0], // CodUsuario
            p[1], // Nombre
            p[2], // Apellido1
            p[3], // Apellido2
            p[4], // FechaNacimiento
            p[5], // Telefono
            p[6], // Email
            p[7], // Organizacion
            p[8], // DesVarSocial
            p[9], // VarSocial
            p[10], // DesVarSanitaria
            p[11], // VarSanitaria
            p[12], // F_ALTA
            p[13], // F_BAJA (de PACIENTE_CASA)
            'Activo', // Todos los que vienen aquí están activos en la vivienda
          ),
        );
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    PacientesViviendaList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return WillPopScope(
      onWillPop: () async {
        var NumHabitacion = await DBPostgres().DBGetNumHabitaciones(
          widget.vivienda.CodCasa,
        );
        var NumCuidadores = await DBPostgres().DBGetNumCuidadores(
          widget.vivienda.CodCasa,
        );
        var NumPacientes = await DBPostgres().DBGetNumPacientes(
          widget.vivienda.CodCasa,
        );
        var NumSensores = await DBPostgres().DBGetNumSensoresVivienda(
          widget.vivienda.CodCasa,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViviendaScreen(
              vivienda: widget.vivienda,
              NumHabitacion: NumHabitacion,
              NumCuidadores: NumCuidadores,
              NumPacientes: NumPacientes,
              NumSensores: NumSensores,
              role: widget.role,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(context),
        appBar: AppBar(
          backgroundColor: colorPrimario,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Center(
            child: SizedBox(
              height: 50.0,
              child: Marquee(
                text:
                    '${LocaleData.pacientesDeLaVivienda.getString(context)}: ${widget.vivienda.Direccion}, ${widget.vivienda.Numero}, ${widget.vivienda.Piso} ${widget.vivienda.Puerta}, ${widget.vivienda.Localidad}, ${widget.vivienda.Provincia}, ${widget.vivienda.Pais}, ${widget.vivienda.CodPostal}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 100.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
        ),
        endDrawer: widget.role == 'superadmin'
            ? NavBarSuperAdmin()
            : NavBarAdmin(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: PacientesViviendaList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.pacientesNoHayEnVivienda.getString(
                            context,
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.pacientesAnadeConBoton.getString(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: PacientesViviendaList.length,
                    itemBuilder: (context, index) {
                      return _buildPatientCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          color: const Color.fromARGB(255, 25, 144, 234),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          LocaleData.pacientesAnadirTitulo.getString(context),
                        ),
                      ],
                    ),
                    content: Text(
                      LocaleData.pacientesAnadirOpcion.getString(context),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewPacienteScreen(
                              vivienda: widget.vivienda,
                              role: widget.role,
                            ),
                          ),
                        ).then((_) => getData()), // Recargar datos al volver
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              25,
                              144,
                              234,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            LocaleData.pacientesNuevo.getString(context),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 144, 234),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PacientesExistentesScreen(
                              vivienda: widget.vivienda,
                              paciente: PacientesViviendaList,
                              role: widget.role,
                            ),
                          ),
                        ).then((_) => getData()), // Recargar datos al volver
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              25,
                              144,
                              234,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            LocaleData.pacientesExistente.getString(context),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 144, 234),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            label: Text(
              LocaleData.pacientesAnadir.getString(context),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 25, 144, 234),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, int index) {
    final paciente = PacientesViviendaList[index];
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PacienteScreen(
                paciente: paciente,
                vivienda: widget.vivienda,
                role: widget.role,
              ),
            ),
          );
        },
        onLongPress: () => _showDesactivateDialog(context, index),
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
                    colors: [colorPrimario.withOpacity(0.8), colorPrimario],
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
                        Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
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
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          paciente.Telefono,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: paciente.Estado == 'Activo'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      paciente.Estado == 'Activo'
                          ? LocaleData.pacientesActivo.getString(context)
                          : LocaleData.pacientesInactivo.getString(context),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: paciente.Estado == 'Activo'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(paciente.F_ALTA, [dd, '/', mm, '/', yyyy]),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDesactivateDialog(BuildContext context, int index) {
  final paciente = PacientesViviendaList[index];

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 10),
          Text('Eliminar de la vivienda'),
        ],
      ),
      content: Text(
        '¿Estás seguro de eliminar a ${paciente.Nombre} ${paciente.Apellido1} de esta vivienda?',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            LocaleData.pacientesCancelar.getString(context),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // Usamos DBActDesActPaciente pero SOLO para dar de baja en PACIENTE_CASA
            // Pasamos COD_CASA = widget.vivienda.CodCasa, y los demás parámetros como null
            var Dbdata = await DBPostgres().DBActDesActPaciente(
              paciente.CodUsuario,
              widget.vivienda.CodCasa,  // Importante: pasamos el COD_CASA correcto
              'CURRENT_TIMESTAMP', // F_BAJA_PACIENTE_CASA - SOLO esto se actualizará
              null, // F_BAJA_PACIENTE - lo dejamos null para NO desactivar globalmente
              null, // F_BAJA_PACIENTE_WEARABLE - lo dejamos null
            );

            if (Dbdata == 'Correcto') {
              if (context.mounted) {
                setState(() {
                  PacientesViviendaList.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Paciente eliminado de la vivienda correctamente',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } else {
              Navigator.pop(context);
              _showErrorDialog(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Eliminar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Text(LocaleData.pacientesError.getString(context)),
          ],
        ),
        content: Text(LocaleData.pacientesErrorDesactivar.getString(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.pacientesOk.getString(context),
              style: const TextStyle(color: Color.fromARGB(255, 25, 144, 234)),
            ),
          ),
        ],
      ),
    );
  }
}

class PacienteScreen extends StatelessWidget {
  final String role;
  final Paciente paciente;
  final Vivienda vivienda;

  PacienteScreen({
    super.key,
    required this.paciente,
    required this.vivienda,
    required this.role,
  });

  Map<String, String> StatusTranslations = {
    'Activo': 'Active',
    'Inactivo': 'Inactive',
  };

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

  @override
  Widget build(BuildContext context) {
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PacientesViviendaScreen(vivienda: vivienda, role: role),
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
          title: Text(
            '${LocaleData.pacientetitulo.getString(context)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        endDrawer: NavBarSuperAdmin(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildHeaderCard(context),
                  const SizedBox(height: 16),
                  _buildModernCard(
                    title: LocaleData.pacienteInfoPersonal.getString(context),
                    icon: Icons.person,
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          Icons.email,
                          LocaleData.pacienteEmail.getString(context),
                          paciente.Email,
                        ),
                        _buildInfoRow(
                          context,
                          Icons.phone,
                          LocaleData.pacienteTelefono.getString(context),
                          paciente.Telefono,
                        ),
                        _buildInfoRow(
                          context,
                          Icons.cake,
                          LocaleData.pacienteNacimiento.getString(context),
                          paciente.FechaNacimiento,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoChipCard(
                          LocaleData.pacientePatologia.getString(context),
                          translationsVarSanitaria[paciente.VarSanitaria] ??
                              paciente.VarSanitaria,
                          Icons.medical_services,
                          Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoChipCard(
                          LocaleData.pacienteAutonomia.getString(context),
                          translationsVarSocial[paciente.VarSocial] ??
                              paciente.VarSocial,
                          Icons.accessibility_new,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildModernCard(
                    title: LocaleData.pacienteEstado.getString(context),
                    icon: Icons.info,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: (paciente.Estado == 'Activo')
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                paciente.Estado == 'Activo'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: paciente.Estado == 'Activo'
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                paciente.Estado == 'Activo'
                                    ? LocaleData.pacientesActivo.getString(
                                        context,
                                      )
                                    : LocaleData.pacientesInactivo.getString(
                                        context,
                                      ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: paciente.Estado == 'Activo'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    LocaleData.pacienteDispositivos.getString(context),
                    Icons.watch,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WearablesScreen(
                          paciente: paciente,
                          vivienda: vivienda,
                          role: role,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    LocaleData.pacienteEditar.getString(context),
                    Icons.edit,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModPacienteViviendaScreen(
                          paciente: paciente,
                          vivienda: vivienda,
                          role: role,
                        ),
                      ),
                    ),
                    color: Color.fromARGB(255, 25, 144, 234),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorPrimario.withOpacity(0.2),
                  colorPrimario,
                  colorPrimario.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${paciente.Nombre} ',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A2B3C),
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: paciente.Apellido1,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF2C3E50),
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (paciente.Apellido2.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  paciente.Apellido2,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF5D6D7E),
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.grey.shade300],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorPrimario.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  LocaleData.pacienteInfoCompleta.getString(context),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w500,
                    color: colorPrimario,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade300, Colors.transparent],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Widget child,
    Color iconColor = const Color.fromARGB(255, 25, 144, 234),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
          const Divider(height: 25, thickness: 0.8),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoChipCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 19, color: Colors.blueGrey[300]),
          const SizedBox(width: 12),
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    Color color = const Color.fromARGB(255, 25, 144, 234),
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class Paciente {
  final int CodUsuario;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final String DesVarSocial;
  final String VarSocial;
  final String DesVarSanitaria;
  final String VarSanitaria;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Estado;

  Paciente(
    this.CodUsuario,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Email,
    this.Organizacion,
    this.DesVarSocial,
    this.VarSocial,
    this.DesVarSanitaria,
    this.VarSanitaria,
    this.F_ALTA,
    this.F_BAJA,
    this.Estado,
  );
}
