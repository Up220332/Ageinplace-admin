/// *****************************************************************************
/// Pantalla que muestra todos los sensores de una vivienda específica
///****************************************************************************
import 'package:ageinplace_admin/BarraLateral/NavBar_admin.dart';
import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';
import 'screen_TodoSensores.dart';

class SensoresViviendaScreen extends StatefulWidget {
  final int codCasa;
  final String role;
  final dynamic vivienda;

  const SensoresViviendaScreen({
    super.key,
    required this.codCasa,
    required this.role,
    this.vivienda,
  });

  @override
  State<SensoresViviendaScreen> createState() => _SensoresViviendaScreenState();
}

class _SensoresViviendaScreenState extends State<SensoresViviendaScreen> {
  List<HabitacionSensorVivienda> sensoresList = [];
  bool isLoading = true;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Sensores de la Vivienda',
      'no_hay': 'No hay sensores en esta vivienda',
      'descripcion': 'Los sensores aparecerán aquí',
      'todos_los_sensores': 'Todos los Sensores',
      'habitacion': 'Habitación',
      'tipo': 'Tipo',
      'estado': 'Estado',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'ver_detalles': 'Ver detalles',
      'error_cargar': 'Error al cargar los sensores',
      'aceptar': 'Aceptar',
      'sin_asignar': 'Sin asignar',
      'fecha_alta': 'Fecha de alta',
      'sensor': 'Sensor',
    },
    'en': {
      'titulo': 'Home Sensors',
      'no_hay': 'No sensors in this home',
      'descripcion': 'Sensors will appear here',
      'todos_los_sensores': 'All Sensors',
      'habitacion': 'Room',
      'tipo': 'Type',
      'estado': 'Status',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'ver_detalles': 'View details',
      'error_cargar': 'Error loading sensors',
      'aceptar': 'Accept',
      'sin_asignar': 'Not assigned',
      'fecha_alta': 'Registration date',
      'sensor': 'Sensor',
    },
  };

  String t(String key, {Map<String, String>? params}) {
    String currentLocale =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    String text =
        translations[currentLocale]?[key] ?? translations['es']![key]!;

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

  String getTranslatedSensorType(String type) {
    String currentLocale =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsTipoSensor[type] ?? type;
    }
    return type;
  }

  String getTranslatedEmisorReceptor(String type) {
    String currentLocale =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsTipoEmisorReceptor[type] ?? type;
    }
    return type;
  }

  @override
  void initState() {
    super.initState();
    _cargarSensores();
  }

  Future<void> _cargarSensores() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Usar la función existente DBGetTodoSensor
      var Dbdata = await DBPostgres().DBGetTodoSensor('null');

      // Procesar los datos para filtrar por vivienda
      List<HabitacionSensorVivienda> sensoresFiltrados = [];

      // Dbdata[0] contiene CasaHabitaciones (información de ubicación)
      // Dbdata[1] contiene Sensores

      for (var sensorData in Dbdata[1]) {
        int codSensor = sensorData[0];
        String idSensor = sensorData[1];
        String desOtros = sensorData[2];
        String emisorReceptor = sensorData[3];
        int codTipoSensor = sensorData[4];
        String tipoSensor = sensorData[5];
        DateTime fechaAlta = sensorData[6];
        DateTime? fechaBaja = sensorData[7];
        String estado = fechaBaja == null ? 'Activo' : 'Inactivo';

        // Buscar si este sensor está asignado a alguna habitación de esta vivienda
        HabitacionSensorVivienda? sensorConUbicacion;

        for (var ubicacionData in Dbdata[0]) {
          if (ubicacionData[14] == codSensor) {
            // CodSensor en la ubicación
            int? codHabitacion = ubicacionData[0];
            String direccion = ubicacionData[1];
            String codPostal = ubicacionData[2];
            String localidad = ubicacionData[3];
            String provincia = ubicacionData[4];
            int? numPlantas = ubicacionData[5];
            String pais = ubicacionData[6];
            String numero = ubicacionData[7];
            String piso = ubicacionData[8];
            String puerta = ubicacionData[9];
            String observaciones = ubicacionData[10];
            int? nPlanta = ubicacionData[11];
            int? codTipoHabitacion = ubicacionData[12];
            String tipoHabitacion = ubicacionData[13];

            // Verificar si esta habitación pertenece a la vivienda que buscamos

            sensorConUbicacion = HabitacionSensorVivienda(
              codSensor: codSensor,
              idSensor: idSensor,
              desOtros: desOtros,
              emisorReceptor: emisorReceptor,
              codTipoSensor: codTipoSensor,
              tipoSensor: tipoSensor,
              fechaAlta: fechaAlta,
              fechaBaja: fechaBaja,
              estado: estado,
              codHabitacion: codHabitacion,
              tipoHabitacion: tipoHabitacion,
              observaciones: observaciones,
              nPlanta: nPlanta,
              direccion: direccion,
              localidad: localidad,
              provincia: provincia,
              pais: pais,
              numero: numero,
              piso: piso,
              puerta: puerta,
            );
            break;
          }
        }

        // Si el sensor tiene ubicación, se agrega
        if (sensorConUbicacion != null) {
          sensoresFiltrados.add(sensorConUbicacion);
        }
      }

      setState(() {
        sensoresList = sensoresFiltrados;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar sensores: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            '${t('titulo')}: ${widget.vivienda.Direccion}, ${widget.vivienda.Numero}, ${widget.vivienda.Piso} ${widget.vivienda.Puerta}, ${widget.vivienda.Localidad}, ${widget.vivienda.Provincia}, ${widget.vivienda.Pais}, ${widget.vivienda.CodPostal}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              tooltip: 'Menú',
            ),
          ),
        ],
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : sensoresList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sensors_off_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t('no_hay'),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t('descripcion'),
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
                padding: const EdgeInsets.all(16),
                itemCount: sensoresList.length,
                itemBuilder: (context, index) {
                  return _buildSensorCard(context, sensoresList[index]);
                },
              ),
      ),
    );
  }

  Widget _buildSensorCard(
    BuildContext context,
    HabitacionSensorVivienda sensor,
  ) {
    final tieneHabitacion = sensor.codHabitacion != null;
    final isActive = sensor.estado == 'Activo';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showSensorDetails(context, sensor);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono del sensor
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isActive
                          ? [colorPrimario.withOpacity(0.8), colorPrimario]
                          : [Colors.grey.withOpacity(0.6), Colors.grey],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getSensorIcon(sensor.tipoSensor),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Información del sensor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sensor.idSensor,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${getTranslatedEmisorReceptor(sensor.emisorReceptor)}: ${getTranslatedSensorType(sensor.tipoSensor)}${sensor.desOtros ?? ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isActive ? t('activo') : t('inactivo'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (tieneHabitacion) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.room,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${sensor.tipoHabitacion} ${sensor.observaciones ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.help_outline,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              t('sin_asignar'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Flecha de detalles
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getSensorIcon(String? tipoSensor) {
    if (tipoSensor == null) return Icons.sensors;

    switch (tipoSensor.toUpperCase()) {
      case 'BLE':
        return Icons.bluetooth;
      case 'IR':
        return Icons.sensors;
      case 'SENSOR DE APERTURA':
        return Icons.door_front_door;
      case 'SM':
        return Icons.smart_toy;
      case 'US':
        return Icons.surround_sound;
      case 'UWD':
        return Icons.water_drop;
      default:
        return Icons.sensors;
    }
  }

  void _showSensorDetails(
    BuildContext context,
    HabitacionSensorVivienda sensor,
  ) {
    final isActive = sensor.estado == 'Activo';
    final tieneHabitacion = sensor.codHabitacion != null;

    showModalBottomSheet(
      context: context,
      builder: (context) {
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

                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isActive
                            ? [colorPrimario.withOpacity(0.8), colorPrimario]
                            : [Colors.grey.withOpacity(0.6), Colors.grey],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getSensorIcon(sensor.tipoSensor),
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  sensor.idSensor,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2B3C),
                  ),
                ),

                const SizedBox(height: 24),

                _buildInfoDetailCard(
                  icon: Icons.devices,
                  label: t('tipo'),
                  value:
                      '${getTranslatedEmisorReceptor(sensor.emisorReceptor)}: ${getTranslatedSensorType(sensor.tipoSensor)}${sensor.desOtros ?? ''}',
                ),

                const SizedBox(height: 12),

                _buildInfoDetailCard(
                  icon: Icons.calendar_today,
                  label: t('fecha_alta'),
                  value: formatDate(sensor.fechaAlta, [dd, '/', mm, '/', yyyy]),
                ),

                const SizedBox(height: 12),

                _buildInfoDetailCard(
                  icon: Icons.info,
                  label: t('estado'),
                  value: isActive ? t('activo') : t('inactivo'),
                  valueColor: isActive ? Colors.green : Colors.red,
                ),

                if (tieneHabitacion) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  Text(
                    t('habitacion'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildInfoDetailCard(
                    icon: Icons.room,
                    label: t('habitacion'),
                    value:
                        '${sensor.tipoHabitacion} ${sensor.observaciones ?? ''}',
                  ),

                  if (sensor.nPlanta != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoDetailCard(
                      icon: Icons.stairs,
                      label: 'Planta',
                      value: '${sensor.nPlanta}ª planta',
                    ),
                  ],

                  const SizedBox(height: 12),

                  _buildInfoDetailCard(
                    icon: Icons.home,
                    label: 'Dirección',
                    value:
                        '${sensor.direccion}, ${sensor.numero}, ${sensor.piso} ${sensor.puerta}, ${sensor.localidad}, ${sensor.provincia}, ${sensor.pais}',
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Text(
                        t('sin_asignar'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildInfoDetailCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? const Color(0xFF1A2B3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Text('Error'),
          ],
        ),
        content: Text(t('error_cargar')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('aceptar'),
              style: TextStyle(
                color: colorPrimario,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelo para los sensores de la vivienda
class HabitacionSensorVivienda {
  final int codSensor;
  final String idSensor;
  final String? desOtros;
  final String emisorReceptor;
  final int codTipoSensor;
  final String tipoSensor;
  final DateTime fechaAlta;
  final DateTime? fechaBaja;
  final String estado;
  final int? codHabitacion;
  final String? tipoHabitacion;
  final String? observaciones;
  final int? nPlanta;
  final String? direccion;
  final String? localidad;
  final String? provincia;
  final String? pais;
  final String? numero;
  final String? piso;
  final String? puerta;

  HabitacionSensorVivienda({
    required this.codSensor,
    required this.idSensor,
    this.desOtros,
    required this.emisorReceptor,
    required this.codTipoSensor,
    required this.tipoSensor,
    required this.fechaAlta,
    this.fechaBaja,
    required this.estado,
    this.codHabitacion,
    this.tipoHabitacion,
    this.observaciones,
    this.nPlanta,
    this.direccion,
    this.localidad,
    this.provincia,
    this.pais,
    this.numero,
    this.piso,
    this.puerta,
  });
}
