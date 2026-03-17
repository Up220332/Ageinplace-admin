/// *****************************************************************************
/// Funcion que devuelve todos los sensores inactivos
///****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_TodoSensores.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class TodoSensoresInactScreen extends StatefulWidget {
  const TodoSensoresInactScreen({super.key});

  @override
  State<TodoSensoresInactScreen> createState() =>
      _TodoSensoresInactScreenState();
}

class _TodoSensoresInactScreenState extends State<TodoSensoresInactScreen> {
  List<Sensor> SensorList = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Sensores Inactivos',
      'no_hay': 'No hay sensores inactivos',
      'descripcion': 'Los sensores desactivados aparecerán aquí',
      'inactivo': 'Inactivo',
      'fecha_baja': 'Baja',
      'reactivar_titulo': '¿Reactivar sensor?',
      'reactivar_confirmacion': '¿Está seguro que desea reactivar el sensor {id}?',
      'cancelar': 'Cancelar',
      'reactivar': 'Reactivar',
      'error': 'Error',
      'error_reactivar': 'Error al reactivar el sensor',
      'aceptar': 'Aceptar',
    },
    'en': {
      'titulo': 'Inactive Sensors',
      'no_hay': 'No inactive sensors',
      'descripcion': 'Deactivated sensors will appear here',
      'inactivo': 'Inactive',
      'fecha_baja': 'Deactivation date',
      'reactivar_titulo': 'Reactivate sensor?',
      'reactivar_confirmacion': 'Are you sure you want to reactivate the sensor {id}?',
      'cancelar': 'Cancel',
      'reactivar': 'Reactivate',
      'error': 'Error',
      'error_reactivar': 'Error reactivating sensor',
      'aceptar': 'Accept',
    }
  };

  // Función para obtener texto traducido
  String t(String key, {Map<String, String>? params}) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    String text = translations[currentLocale]?[key] ?? translations['es']![key]!;
    
    if (params != null) {
      params.forEach((key, value) {
        text = text.replaceAll('{$key}', value);
      });
    }
    return text;
  }

  Map<String, String> translationsTipoEmisorReceptor = {
    "Emisor": "Emitter",
    "Receptor": "Receiver",
    "Emisor-Receptor": "Emitter-Receiver",
  };

  Map<String, String> translationsTipoSensor = {
    "BLE": "BLE",
    "IR": "IR",
    "SENSOR DE APERTURA": "OPENING SENSOR",
    "SM": "SM",
    "US": "US",
    "UWD": "UWD",
    "Otros": "Others",
  };

  // Función para obtener el nombre traducido del tipo de sensor
  String getTranslatedSensorType(String type) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsTipoSensor[type] ?? type;
    }
    return type;
  }

  // Función para obtener el nombre traducido del tipo emisor/receptor
  String getTranslatedEmisorReceptor(String type) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsTipoEmisorReceptor[type] ?? type;
    }
    return type;
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetTodoSensor('not null');
    String Estado;
    setState(() {
      for (var p in Dbdata[1]) {
        if (p[7] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        SensorList.add(
          Sensor(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], Estado),
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
    return WillPopScope(
      onWillPop: () async {
        return true;
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
        endDrawer: NavBarSuperAdmin(),
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
            child: SensorList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sensors_off_outlined, size: 80, color: Colors.grey.shade400),
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
                    itemCount: SensorList.length,
                    itemBuilder: (context, index) {
                      return _buildSensorCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSensorCard(BuildContext context, int index) {
    final sensor = SensorList[index];
    
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
              // Icono del sensor (en rojo para inactivos)
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
                  Icons.sensors,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              
              // Información del sensor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sensor.IdSensor,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${getTranslatedEmisorReceptor(sensor.EmisorReceptor)}: ${getTranslatedSensorType(sensor.TipoSensor)}${sensor.DesOtros}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Fecha y estado INACTIVO
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
                      t('inactivo'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (sensor.FechaBajaSensor != null)
                    Text(
                      '${t('fecha_baja')}: ${formatDate(sensor.FechaBajaSensor!, [dd, '/', mm, '/', yyyy])}',
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
            Text(t('reactivar_titulo')),
          ],
        ),
        content: Text(
          t('reactivar_confirmacion', params: {'id': SensorList[index].IdSensor}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('cancelar'),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var Dbdata = await DBPostgres().DBActDesactSensorSinHabitacion(
                SensorList[index].CodSensor,
                null,
              );
              if (Dbdata == 'Correcto') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoSensoresScreen(),
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
              t('reactivar'),
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
            Text(t('error')),
          ],
        ),
        content: Text(t('error_reactivar')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('aceptar'),
              style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class Sensor {
  final int CodSensor;
  final String IdSensor;
  final String DesOtros;
  final String EmisorReceptor;
  final int CodTipoSensor;
  final String TipoSensor;
  final DateTime FechaAltaSensor;
  final DateTime? FechaBajaSensor;
  final String Estado;

  Sensor(
    this.CodSensor,
    this.IdSensor,
    this.DesOtros,
    this.EmisorReceptor,
    this.CodTipoSensor,
    this.TipoSensor,
    this.FechaAltaSensor,
    this.FechaBajaSensor,
    this.Estado,
  );
}