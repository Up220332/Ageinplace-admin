import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_sensor.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:marquee/marquee.dart';

import '../BarraLateral/NavBar_admin.dart';
import '../SuperAdmin/screen_NewHabitacion.dart';
import '../SuperAdmin/screen_habitacioneInact.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

/// *****************************************************************************
/// Funcion que devuelve las habitaciones de una vivienda
///****************************************************************************
class HabitacionesScreen extends StatefulWidget {
  final String role;
  final CodCasa;
  Vivienda vivienda;

  HabitacionesScreen({
    super.key,
    required this.CodCasa,
    required this.vivienda,
    required this.role,
  });

  @override
  State<HabitacionesScreen> createState() => _HabitacionesScreenSate();
}

class _HabitacionesScreenSate extends State<HabitacionesScreen> {
  List<Habitacion> HabitacionList = [];
  late int CodTipoHabitacion = 1;
  List<TipodeHabitacion> TipodeHabitacionList = [];
  final TextEditingController _NumPlantaController = TextEditingController();
  final TextEditingController _ObservacionesHabitacionController =
      TextEditingController();
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetHabitacion(widget.CodCasa, 'null');
    String Estado;
    setState(() {
      for (var p in Dbdata) {
        if (p[4] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        HabitacionList.add(
          Habitacion(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], Estado),
        );
      }
    });
    return 'Successfully Fetched data';
  }

  Future<String> getTipoHabitacion() async {
    var Dbdata = await DBPostgres().DBGetTipoHabitacion();
    setState(() {
      for (var p in Dbdata) {
        TipodeHabitacionList.add(TipodeHabitacion(p[0], p[1]));
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
    getTipoHabitacion();
  }

  // Mapa de traducciones para tipos de habitación
  Map<String, String> roomTypeTranslations = {
    'Baño': 'Bathroom',
    'Buhardilla': 'Attic',
    'Cocina': 'Kitchen',
    'Comedor': 'Dining Room',
    'Despacho': 'Office',
    'Dormitorio': 'Bedroom',
    'Entrada': 'Entrance',
    'Estudio': 'Study',
    'Garaje': 'Garage',
    'Habitación': 'Room',
    'Hall': 'Hall',
    'Laboratorio': 'Laboratory',
    'Pasillo': 'Hallway',
    'Patio': 'Patio',
    'Salón': 'Living Room',
    'Sótano': 'Basement',
    'Trastero': 'Storage Room',
    'Otros': 'Others',
    'Zona no Sensorizada': 'Non-Sensorized Area',
  };

  // Función para obtener el nombre traducido de la habitación
  String getTranslatedRoomType(String roomType, BuildContext context) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return roomTypeTranslations[roomType] ?? roomType;
    }
    return roomType; // En español, devolvemos el original
  }

  String getOrdinalSuffix(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    HabitacionList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    
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
        floatingActionButton: _buildFloatingActionButtons(context),
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
                text: '${LocaleData.habitacionesDe.getString(context)}: ${widget.vivienda.Direccion}, ${widget.vivienda.Localidad}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
            child: HabitacionList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hotel_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.habitacionesNoHay.getString(context),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.habitacionesAnade.getString(context),
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: HabitacionList.length,
                    itemBuilder: (context, index) {
                      return _buildHabitacionCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewHabitacionScreen(
                    CodCasa: widget.CodCasa,
                    vivienda: widget.vivienda,
                    role: widget.role,
                  ),
                ),
              );
            },
            label: Text(
              LocaleData.habitacionesAnadir.getString(context),
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
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitacionesInactScreen(
                    vivienda: widget.vivienda,
                    role: widget.role,
                  ),
                ),
              );
            },
            backgroundColor: Colors.red,
            label: Text(
              LocaleData.habitacionesInactivas.getString(context),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.white,
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

  Widget _buildHabitacionCard(BuildContext context, int index) {
    final habitacion = HabitacionList[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SensoresScreen(
                habitacion: habitacion,
                vivienda: widget.vivienda,
                role: widget.role,
              ),
            ),
          );
        },
        onLongPress: () => _showEditDialog(context, index),
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
              // Icono de la habitación
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
                child: const Icon(
                  Icons.hotel,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              
              // Información de la habitación
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranslatedRoomType(habitacion.TipoHabitacion, context), // <-- TRADUCIDO
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habitacion.Observaciones,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.stairs, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          '${LocaleData.habitacionesPlanta.getString(context)} ${habitacion.NumPlanta}',
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
              
              // Menú de opciones
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(context, index);
                  } else if (value == 'deactivate') {
                    _showDeactivateDialog(context, index);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20, color: colorPrimario),
                        const SizedBox(width: 8),
                        Text(LocaleData.habitacionesModificar.getString(context)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'deactivate',
                    child: Row(
                      children: [
                        const Icon(Icons.block, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(LocaleData.habitacionesDesactivar.getString(context)),
                      ],
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

  void _showEditDialog(BuildContext context, int index) {
    CodTipoHabitacion = HabitacionList[index].CodTipoHabitacion;
    _ObservacionesHabitacionController.text = HabitacionList[index].Observaciones;
    _NumPlantaController.text = HabitacionList[index].NumPlanta.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit, color: colorPrimario, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        LocaleData.habitacionesModificarTitulo.getString(context),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonFormField<TipodeHabitacion>(
                      value: TipodeHabitacionList.firstWhere(
                        (tipo) => tipo.CodTipoHabitacion == HabitacionList[index].CodTipoHabitacion,
                      ),
                      items: TipodeHabitacionList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedRoomType(tipo.TipoHabitacionTabla, context), // <-- TRADUCIDO
                        ),
                      )).toList(),
                      onChanged: (TipodeHabitacion? newValue) {
                        setState(() {
                          CodTipoHabitacion = newValue!.CodTipoHabitacion;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: LocaleData.habitacionesTipo.getString(context),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextFormField(
                      controller: _ObservacionesHabitacionController,
                      decoration: InputDecoration(
                        labelText: LocaleData.habitacionesDescripcion.getString(context),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleData.campoObligatorio.getString(context);
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextFormField(
                      controller: _NumPlantaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: LocaleData.habitacionesNumeroPlanta.getString(context),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleData.campoObligatorio.getString(context);
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return LocaleData.soloNumeros.getString(context);
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (await DBPostgres().DBModificarHabitacion(
                            HabitacionList[index].CodHabitacion,
                            _ObservacionesHabitacionController.text,
                            int.parse(_NumPlantaController.text),
                            CodTipoHabitacion,
                          ) == true) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitacionesScreen(
                                  CodCasa: widget.CodCasa,
                                  vivienda: widget.vivienda,
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        LocaleData.habitacionesGuardarCambios.getString(context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeactivateDialog(BuildContext context, int index) {
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
            Text(LocaleData.habitacionesDesactivarTitulo.getString(context)),
          ],
        ),
        content: Text(
          LocaleData.habitacionesConfirmarDesactivar.getString(
            context,
          ).replaceAll('{tipo}', 
            getTranslatedRoomType(HabitacionList[index].TipoHabitacion, context) // <-- TRADUCIDO
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.habitacionesCancelar.getString(context),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var Dbdata = await DBPostgres().DBActDesActHabitacion(
                widget.vivienda.CodCasa,
                HabitacionList[index].CodHabitacion,
                'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP',
              );
              if (Dbdata == 'Correcto') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitacionesScreen(
                      CodCasa: widget.CodCasa,
                      vivienda: widget.vivienda,
                      role: widget.role,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
                _showErrorDialog(LocaleData.habitacionesErrorDesactivar.getString(context));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(LocaleData.habitacionesDesactivar.getString(context)),
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
            Text(LocaleData.habitacionesError.getString(context)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.habitacionesAceptar.getString(context),
              style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class TipodeHabitacion {
  final int CodTipoHabitacion;
  final String TipoHabitacionTabla;

  TipodeHabitacion(this.CodTipoHabitacion, this.TipoHabitacionTabla);
}

class Habitacion {
  final int CodHabitacion;
  final int CodCasa;
  final int NumPlanta;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Observaciones;
  final String TipoHabitacion;
  final int CodTipoHabitacion;
  final String Estado;

  Habitacion(
    this.CodHabitacion,
    this.CodCasa,
    this.NumPlanta,
    this.F_ALTA,
    this.F_BAJA,
    this.Observaciones,
    this.TipoHabitacion,
    this.CodTipoHabitacion,
    this.Estado,
  );
}