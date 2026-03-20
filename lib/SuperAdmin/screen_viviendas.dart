/// *****************************************************************************
/// Funcion que muestra todas las viviendas al pulsar encima de la vivienda
/// observamos la informacion de la vivienda y podemos modificarla.
///****************************************************************************
library;

import 'package:ageinplace_admin/SuperAdmin/screen_NewVivienda.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jap_icons/medical_icons_icons.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../BarraLateral/NavBar_admin.dart';
import '../BarraLateral/NavBar_super_admin.dart';
import '../SuperAdmin/screen_PacientesVivienda.dart';
import '../SuperAdmin/screen_habitaciones.dart';
import '../SuperAdmin/screen_viviendasIncat.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';
import 'screen_CuidadoresVivienda.dart';
import 'screen_ModVivienda.dart';

class ViviendasScreen extends StatefulWidget {
  final String tipoUsuario;

  const ViviendasScreen({super.key, required this.tipoUsuario});

  @override
  State<ViviendasScreen> createState() => _ViviendasScreenSate();
}

class _ViviendasScreenSate extends State<ViviendasScreen> {
  List<Vivienda> ViviendaList = [];

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetVivienda('null');
    String Estado;
    setState(() {
      for (var p in Dbdata) {
        if (p[11] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        ViviendaList.add(
          Vivienda(
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
            p[13],
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
    ViviendaList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: colorPrimario),
                    const SizedBox(width: 10),
                    Text(LocaleData.viviendasSalirApp.getString(context)),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      LocaleData.viviendasNo.getString(context),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimario,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      LocaleData.viviendasSi.getString(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButtons(context),
        appBar: AppBar(
          backgroundColor: colorPrimario,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            LocaleData.viviendasTitulo.getString(context),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        endDrawer: widget.tipoUsuario == 'superadmin'
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
            child: ViviendaList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.house_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.viviendasNoHay.getString(context),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.viviendasAnade.getString(context),
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
                    itemCount: ViviendaList.length,
                    itemBuilder: (context, index) {
                      return _buildViviendaCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NewViviendaScreen(role: widget.tipoUsuario),
              ),
            ),
            label: Text(
              LocaleData.viviendasAnadir.getString(context),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViviendasInactScreen()),
              );
            },
            backgroundColor: Colors.red,
            label: Text(
              LocaleData.viviendasInactivas.getString(context),
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

  // NUEVO: Tarjeta de vivienda moderna
  Widget _buildViviendaCard(BuildContext context, int index) {
    final vivienda = ViviendaList[index];
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          var NumHabitacion = await DBPostgres().DBGetNumHabitaciones(
            vivienda.CodCasa,
          );
          var NumCuidadores = await DBPostgres().DBGetNumCuidadores(
            vivienda.CodCasa,
          );
          var NumPacientes = await DBPostgres().DBGetNumPacientes(
            vivienda.CodCasa,
          );
          var NumSensores = await DBPostgres().DBGetNumSensoresVivienda(
            vivienda.CodCasa,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViviendaScreen(
                vivienda: vivienda,
                NumHabitacion: NumHabitacion,
                NumCuidadores: NumCuidadores,
                NumPacientes: NumPacientes,
                NumSensores: NumSensores,
                role: widget.tipoUsuario,
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
              // Icono de la vivienda con gradiente
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrimario.withOpacity(0.8), colorPrimario],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.house_sharp,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Información de la vivienda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vivienda.Direccion,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${vivienda.Localidad}, ${vivienda.Provincia}',
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
                          Icons.public,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vivienda.Pais,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: vivienda.Estado == 'Activo'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vivienda.Estado == 'Activo'
                          ? LocaleData.viviendasActivo.getString(context)
                          : LocaleData.viviendasInactivo.getString(context),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: vivienda.Estado == 'Activo'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(vivienda.F_ALTA, [dd, '/', mm, '/', yyyy]),
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
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 10),
            Text(LocaleData.viviendasDesactivarTitulo.getString(context)),
          ],
        ),
        content: Text(
          LocaleData.viviendasConfirmarDesactivar
              .getString(context)
              .replaceAll('{direccion}', ViviendaList[index].Direccion),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.viviendasCancelar.getString(context),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var Dbdata = await DBPostgres().DBActDesActVivienda(
                ViviendaList[index].CodCasa,
                'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP',
              );
              if (Dbdata == 'Correcto') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViviendasScreen(tipoUsuario: widget.tipoUsuario),
                  ),
                );
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
              LocaleData.viviendasDesactivar.getString(context),
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Text(LocaleData.viviendasError.getString(context)),
          ],
        ),
        content: Text(LocaleData.viviendasErrorDesactivar.getString(context),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.viviendasOk.getString(context),
              style: TextStyle(color: colorPrimario),
            ),
          ),
        ],
      ),
    );
  }
}

/// *****************************************************************************
/// Funcion que muestra los datos de la vivienda y nos permite acceder a las
/// habitaciones, cuidadores y pacientes (VERSIÓN MEJORADA)
///****************************************************************************
class ViviendaScreen extends StatelessWidget {
  final String role;
  final Vivienda vivienda;
  final NumHabitacion;
  final NumCuidadores;
  final NumPacientes;
  final NumSensores;

  ViviendaScreen({
    super.key,
    required this.vivienda,
    required this.NumHabitacion,
    required this.NumCuidadores,
    required this.NumPacientes,
    required this.NumSensores,
    required this.role,
  });

  Map<String, String> translationsPais = {
    'España': 'Spain',
    'México': 'Mexico',
    'Argentina': 'Argentina',
    'Colombia': 'Colombia',
    'Perú': 'Peru',
    'Venezuela': 'Venezuela',
    'Chile': 'Chile',
    'Guatemala': 'Guatemala',
    'Cuba': 'Cuba',
    'Bolivia': 'Bolivia',
    'República Dominicana': 'Dominican Republic',
    'Honduras': 'Honduras',
    'Paraguay': 'Paraguay',
    'El Salvador': 'El Salvador',
    'Nicaragua': 'Nicaragua',
    'Costa Rica': 'Costa Rica',
    'Puerto Rico': 'Puerto Rico',
    'Panamá': 'Panama',
    'Uruguay': 'Uruguay',
    'Ecuador': 'Ecuador',
    'Estados Unidos': 'United States',
    'Brasil': 'Brazil',
    'Canadá': 'Canada',
    'Reino Unido': 'United Kingdom',
    'Francia': 'France',
    'Alemania': 'Germany',
    'Italia': 'Italy',
    'Japón': 'Japan',
    'China': 'China',
    'Rusia': 'Russia',
    'India': 'India',
    'Irlanda': 'Ireland',
    'Australia': 'Australia',
  };

  @override
  Widget build(BuildContext context) {
    final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViviendasScreen(tipoUsuario: role),
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
            LocaleData.viviendasDetalle.getString(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        endDrawer: role == 'superadmin' ? NavBarSuperAdmin() : NavBarAdmin(),
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
                  _buildHeaderCard(context, colorPrimario),
                  const SizedBox(height: 16),
                  _buildModernCard(
                    title: LocaleData.viviendasInformacion.getString(context),
                    icon: Icons.home,
                    child: _buildTwoColumnInfo(context),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatButton(
                          LocaleData.viviendasHabitaciones.getString(context),
                          NumHabitacion.toString(),
                          Icons.hotel,
                          colorPrimario,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HabitacionesScreen(
                                CodCasa: vivienda.CodCasa,
                                vivienda: vivienda,
                                role: role,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatButton(
                          LocaleData.viviendasCuidadores.getString(context),
                          NumCuidadores.toString(),
                          Icons.person,
                          Colors.green,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CuidadoresViviendaScreen(
                                CodCasa: vivienda.CodCasa,
                                vivienda: vivienda,
                                role: role,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatButton(
                          LocaleData.viviendasPacientes.getString(context),
                          NumPacientes.toString(),
                          Icons.elderly,
                          Colors.orange,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PacientesViviendaScreen(
                                vivienda: vivienda,
                                role: role,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          LocaleData.viviendasSensores.getString(context),
                          NumSensores.toString(),
                          Icons.sensors,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Botón de Modificar Vivienda
                  _buildActionButton(
                    LocaleData.viviendasModificar.getString(context),
                    Icons.edit,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ModViviendaScreen(vivienda: vivienda),
                        ),
                      );
                    },
                    color: Color.fromARGB(255, 25, 144, 234),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Color colorPrimario) {
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
          // Línea decorativa superior
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

          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                vivienda.Direccion,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A2B3C),
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              Text(
                '${vivienda.Localidad}, ${vivienda.Provincia}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF5D6D7E),
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
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
                  LocaleData.viviendasInformacionCompleta.getString(context),
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

  Widget _buildStatButton(
    String title,
    String value,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blueGrey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Método para construir la información en dos columnas
  Widget _buildTwoColumnInfo(BuildContext context) {
    final List<Map<String, dynamic>> leftColumnInfo = [
      {
        'icon': Icons.location_on,
        'label': LocaleData.viviendasDireccion.getString(context),
        'value': '${vivienda.Direccion} ${vivienda.Numero}',
      },
      {
        'icon': Icons.door_front_door,
        'label': LocaleData.viviendasPortalPuerta.getString(context),
        'value': vivienda.Numero,
      },
      {
        'icon': Icons.stairs,
        'label': LocaleData.viviendasPiso.getString(context),
        'value': vivienda.Piso,
      },
      {
        'icon': Icons.location_city,
        'label': LocaleData.viviendasLocalidad.getString(context),
        'value': vivienda.Localidad,
      },
      {
        'icon': Icons.map,
        'label': LocaleData.viviendasProvincia.getString(context),
        'value': vivienda.Provincia,
      },
    ];

    final List<Map<String, dynamic>> rightColumnInfo = [
      {
        'icon': Icons.public,
        'label': LocaleData.viviendasPais.getString(context),
        'value': vivienda.Pais,
      },
      {
        'icon': Icons.markunread_mailbox,
        'label': LocaleData.viviendasCodigoPostal.getString(context),
        'value': vivienda.CodPostal,
      },
      {
        'icon': Icons.location_searching,
        'label': LocaleData.viviendasCoordenadas.getString(context),
        'value':
            '${vivienda.Latitud?.toStringAsFixed(4) ?? 'N/A'}, ${vivienda.Longitud?.toStringAsFixed(4) ?? 'N/A'}',
      },
      {
        'icon': Icons.layers,
        'label': LocaleData.viviendasPlantas.getString(context),
        'value': '${vivienda.NumPlantas ?? 'N/A'}',
      },
      {
        'icon': Icons.calendar_today,
        'label': LocaleData.viviendasFechaAlta.getString(context),
        'value': formatDate(vivienda.F_ALTA, [dd, '/', mm, '/', yyyy]),
      },
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftColumnInfo
                .map(
                  (info) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCompactInfoRow(
                      info['icon'],
                      info['label'],
                      info['value'],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: rightColumnInfo
                .map(
                  (info) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCompactInfoRow(
                      info['icon'],
                      info['label'],
                      info['value'],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // Versión compacta de la fila de información
  Widget _buildCompactInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey[300]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey[400],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tarjeta moderna con sombra suave
  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Widget child,
    Color iconColor = const Color.fromARGB(255, 25, 144, 234),
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
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

  // Botón de acción
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

class Vivienda {
  final int CodCasa;
  final String Direccion;
  final String Numero;
  final String Piso;
  final String Puerta;
  final String CodPostal;
  final String Localidad;
  final String Provincia;
  final String Pais;
  final int? NumPlantas;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final num? Longitud;
  final num? Latitud;
  final String Estado;

  Vivienda(
    this.CodCasa,
    this.Direccion,
    this.Numero,
    this.Piso,
    this.Puerta,
    this.CodPostal,
    this.Localidad,
    this.Provincia,
    this.Pais,
    this.NumPlantas,
    this.F_ALTA,
    this.F_BAJA,
    this.Longitud,
    this.Latitud,
    this.Estado,
  );
}
