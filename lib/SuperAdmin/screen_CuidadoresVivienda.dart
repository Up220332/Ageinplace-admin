import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_ModCuidadorVivienda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:marquee/marquee.dart';

import '../BarraLateral/NavBar_admin.dart';
import '../SuperAdmin/screen_CuidadoresExistentes.dart';
import '../SuperAdmin/screen_NewCuidadorVivienda.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

/// *****************************************************************************
/// Funcion que muestra todos los cuidadores de una vivienda.
///****************************************************************************
class CuidadoresViviendaScreen extends StatefulWidget {
  final String role;
  final CodCasa;
  final Vivienda vivienda;

  const CuidadoresViviendaScreen({
    super.key,
    required this.CodCasa,
    required this.vivienda,
    required this.role,
  });

  @override
  State<CuidadoresViviendaScreen> createState() =>
      _CuidadoresViviendaScreenSate();
}

class _CuidadoresViviendaScreenSate extends State<CuidadoresViviendaScreen> {
  List<Cuidadores> CuidadoresViviendaList = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Función para obtener el nombre traducido del tipo de cuidador
  String getTranslatedCaregiverType(String type, String desOtros, BuildContext context) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    
    if (currentLocale == 'en') {
      // Buscar la traducción en el mapa EN
      String translatedType = LocaleData.EN[type] ?? type;
      if (type == 'Otros') {
        return '$translatedType $desOtros';
      }
      return translatedType;
    } else {
      // En español, usar el valor original o buscar en ES
      String spanishType = LocaleData.ES[type] ?? type;
      return type == 'Otros' ? '$spanishType $desOtros' : spanishType;
    }
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetCuidadoresVivienda(widget.CodCasa);
    setState(() {
      String Estado;
      for (var p in Dbdata) {
        if (p[9] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        CuidadoresViviendaList.add(
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
            p[11],
            p[12],
            Estado,
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
    CuidadoresViviendaList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    
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
                text: '${LocaleData.cuidadoresDe.getString(context)}: ${widget.vivienda.Direccion}, ${widget.vivienda.Localidad}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
            child: CuidadoresViviendaList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.cuidadoresNoHay.getString(context), 
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.cuidadoresAnade.getString(context), 
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: CuidadoresViviendaList.length,
                    itemBuilder: (context, index) {
                      return _buildCuidadorCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
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
                    Icon(Icons.person_add, color: colorPrimario),
                    const SizedBox(width: 10),
                    Text(LocaleData.cuidadoresAnadirTitulo.getString(context)), 
                  ],
                ),
                content: Text(
                  LocaleData.cuidadoresAnadirOpcion.getString(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewCuidadorViviendaScreen(
                          vivienda: widget.vivienda,
                          role: widget.role,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorPrimario.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        LocaleData.cuidadoresNuevo.getString(context),
                        style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CuidadoresExistentesScreen(
                          vivienda: widget.vivienda,
                          cuidador: CuidadoresViviendaList,
                          role: widget.role,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorPrimario.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        LocaleData.cuidadoresExistente.getString(context),
                        style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        label: Text(
          LocaleData.cuidadoresAnadir.getString(context), 
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: colorPrimario,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCuidadorCard(BuildContext context, int index) {
    final cuidador = CuidadoresViviendaList[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return CuidadorModal(
                cuidador: cuidador,
                vivienda: widget.vivienda,
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
                        Icon(Icons.family_restroom, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          getTranslatedCaregiverType(
                            cuidador.TipoCuidador, 
                            cuidador.DesOtros, 
                            context
                          ),
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
              
              // Fecha y estado
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cuidador.Estado == 'Activo' 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cuidador.Estado == 'Activo' 
                          ? LocaleData.cuidadoresActivo.getString(context)
                          : LocaleData.cuidadoresInactivo.getString(context),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cuidador.Estado == 'Activo' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// *****************************************************************************
/// Modal para mostrar los datos del cuidador de la vivienda.
///****************************************************************************
class CuidadorModal extends StatelessWidget {
  final String role;
  final Cuidadores cuidador;
  final Vivienda vivienda;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  const CuidadorModal({
    super.key,
    required this.cuidador,
    required this.vivienda,
    required this.role,
  });

  // Función para obtener el nombre traducido del tipo de cuidador
  String getTranslatedCaregiverType(String type, String desOtros, BuildContext context) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    
    if (currentLocale == 'en') {
      // Buscar la traducción en el mapa EN
      String translatedType = LocaleData.EN[type] ?? type;
      if (type == 'Otros') {
        return '$translatedType $desOtros';
      }
      return translatedType;
    } else {
      // En español, usar el valor original o buscar en ES
      String spanishType = LocaleData.ES[type] ?? type;
      return type == 'Otros' ? '$spanishType $desOtros' : spanishType;
    }
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
              context,
              icon: Icons.email,
              label: LocaleData.cuidadoresEmail.getString(context),
              value: cuidador.Email,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.phone,
              label: LocaleData.cuidadoresTelefono.getString(context),
              value: cuidador.Telefono,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.cake,
              label: LocaleData.cuidadoresFechaNacimiento.getString(context),
              value: cuidador.FechaNacimiento,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.family_restroom,
              label: LocaleData.cuidadoresParentesco.getString(context),
              value: getTranslatedCaregiverType(
                cuidador.TipoCuidador, 
                cuidador.DesOtros, 
                context
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.business,
              label: LocaleData.cuidadoresOrganizacion.getString(context),
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
                      color: cuidador.Estado == 'Activo'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cuidador.Estado == 'Activo' ? Icons.check_circle : Icons.cancel,
                      color: cuidador.Estado == 'Activo' ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${LocaleData.cuidadoresEstado.getString(context)}:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cuidador.Estado == 'Activo' 
                        ? LocaleData.cuidadoresActivo.getString(context)
                        : LocaleData.cuidadoresInactivo.getString(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cuidador.Estado == 'Activo' ? Colors.green : Colors.red,
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
                    context,
                    label: LocaleData.cuidadoresDeshabilitar.getString(context),
                    icon: Icons.block,
                    color: Colors.red,
                    onPressed: () async {
                      var deleteOk = await DBPostgres().DBActDesactCuidaorVivienda(
                        vivienda.CodCasa,
                        cuidador.CodUsuario,
                        'CURRENT_TIMESTAMP',
                      );
                      if (deleteOk == true) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CuidadoresViviendaScreen(
                              CodCasa: vivienda.CodCasa,
                              vivienda: vivienda,
                              role: role,
                            ),
                          ),
                        );
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
                    context,
                    label: LocaleData.cuidadoresEditar.getString(context),
                    icon: Icons.edit,
                    color: colorPrimario,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModCuidadorViviendaScreen(
                            cuidador: cuidador,
                            vivienda: vivienda,
                            role: role,
                          ),
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

  Widget _buildInfoCard(BuildContext context, {
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

  Widget _buildActionButton(
    BuildContext context, {
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
  final String TipoCuidador;
  final int CodTipoCuidador;
  final String DesOtros;
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
    this.TipoCuidador,
    this.CodTipoCuidador,
    this.DesOtros,
    this.Estado,
  );
}