import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../SuperAdmin/screen_habitaciones.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

/// *****************************************************************************
/// Funcion que devuelve las habitaciones inactivas de una vivienda
///****************************************************************************
class HabitacionesInactScreen extends StatefulWidget {
  final String role;
  final Vivienda vivienda;

  const HabitacionesInactScreen({
    super.key,
    required this.vivienda,
    required this.role,
  });

  @override
  State<HabitacionesInactScreen> createState() =>
      _HabitacionesInactScreenSate();
}

class _HabitacionesInactScreenSate extends State<HabitacionesInactScreen> {
  List<Habitacion> HabitacionList = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

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

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetHabitacion(
      widget.vivienda.CodCasa,
      ' not null',
    );
    String Estado;
    setState(() {
      for (var p in Dbdata) {
        if (p[4] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        HabitacionList.add(
          Habitacion(p[0], p[1], p[2], p[3], p[4], p[5], p[6], Estado),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitacionesScreen(
              vivienda: widget.vivienda,
              CodCasa: widget.vivienda.CodCasa,
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
            LocaleData.habitacionesInactivasTitulo.getString(context),
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
            child: HabitacionList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hotel_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.habitacionesInactivasNoHay.getString(context),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.habitacionesInactivasDescripcion.getString(context),
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

  Widget _buildHabitacionCard(BuildContext context, int index) {
    final habitacion = HabitacionList[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showActivateDialog(context, index);
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
              // Icono de la habitación (en rojo para inactivas)
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
              
              // Fecha y estado
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      LocaleData.habitacionesInactiva.getString(context),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (habitacion.F_BAJA != null)
                    Text(
                      '${LocaleData.habitacionesFechaBaja.getString(context)}: ${formatDate(habitacion.F_BAJA!, [dd, '/', mm, '/', yyyy])}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
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

  void _showActivateDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 10),
            Text(LocaleData.habitacionesActivarTitulo.getString(context)),
          ],
        ),
        content: Text(
          LocaleData.habitacionesConfirmarActivar.getString(context).replaceAll(
            '{tipo}', 
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
              if (await DBPostgres().DBActDesActHabitacion(
                widget.vivienda.CodCasa,
                HabitacionList[index].CodHabitacion,
                null,
                'CURRENT_TIMESTAMP',
              ) == 'Correcto') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitacionesScreen(
                      CodCasa: widget.vivienda.CodCasa,
                      vivienda: widget.vivienda,
                      role: widget.role,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
                _showErrorDialog(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              LocaleData.habitacionesActivar.getString(context),
              style: const TextStyle(color: Colors.white),
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
        content: Text(LocaleData.habitacionesErrorActivar.getString(context)),
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

class Habitacion {
  final int CodHabitacion;
  final int CodCasa;
  final int NumPlanta;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Observaciones;
  final String TipoHabitacion;
  final String Estado;

  Habitacion(
    this.CodHabitacion,
    this.CodCasa,
    this.NumPlanta,
    this.F_ALTA,
    this.F_BAJA,
    this.Observaciones,
    this.TipoHabitacion,
    this.Estado,
  );
}