/// *****************************************************************************
/// Funcion que devuelve todos los sensores que existen.
///****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_TodoSensoresInact.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class TodoSensoresScreen extends StatefulWidget {
  const TodoSensoresScreen({super.key});

  @override
  State<TodoSensoresScreen> createState() => _TodoSensoresScreenState();
}

class _TodoSensoresScreenState extends State<TodoSensoresScreen> {
  List<CasaHabitaciones> CasaHabitacionList = [];
  List<Sensor> SensorList = [];
  List<TipoSensor> TipoSensorList = [];
  List<HabitacionSensor> HabitacionSensorList = [];
  final List<String> _TipoEmisorReceptorList = [
    "Emisor",
    "Receptor",
    "Emisor-Receptor",
  ];

  // Mapa de traducciones principal
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Sensores',
      'no_hay': 'No hay sensores registrados',
      'anade': 'Añade sensores usando el botón +',
      'anadir': 'Añadir Sensor',
      'inactivos': 'Sensores Inactivos',
      'ver_info': 'Ver información',
      'modificar': 'Modificar',
      'desactivar': 'Desactivar',
      'desactivar_titulo': '¿Desactivar sensor?',
      'desactivar_confirmacion': '¿Está seguro que desea desactivar el sensor {id}?',
      'cancelar': 'Cancelar',
      'error': 'Error',
      'error_desactivar': 'Error al desactivar el sensor',
      'exito': 'Éxito',
      'aceptar': 'Aceptar',
      'anadir_titulo': 'Añadir Sensor',
      'id_sensor': 'ID del Sensor',
      'campo_obligatorio': 'Campo obligatorio',
      'tipo_tecnologia': 'Tipo de Tecnología',
      'seleccione_tipo': 'Seleccione un tipo',
      'emisor_receptor': 'Emisor/Receptor',
      'seleccione_opcion': 'Seleccione una opción',
      'crear': 'Crear Sensor',
      'modificar_titulo': 'Modificar Sensor',
      'guardar_cambios': 'Guardar Cambios',
      'tipo': 'Tipo',
      'fecha_alta': 'Fecha de alta',
      'estado': 'Estado',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'no_asignado': 'No asignado',
      'ubicacion': 'Ubicación',
      'habitacion': 'Habitación',
      'direccion': 'Dirección',
      'sensor_sin_asignar': 'Este sensor no está asignado a ninguna habitación',
      'otros': 'Otros',
      'especifique_tipo': 'Especifique el tipo',
      'sensor_anadido': 'Sensor añadido correctamente',
      'sensor_ya_existe': 'Ya existe un sensor con ese ID',
    },
    'en': {
      'titulo': 'Sensors',
      'no_hay': 'No sensors registered',
      'anade': 'Add sensors using the + button',
      'anadir': 'Add Sensor',
      'inactivos': 'Inactive Sensors',
      'ver_info': 'View information',
      'modificar': 'Edit',
      'desactivar': 'Deactivate',
      'desactivar_titulo': 'Deactivate sensor?',
      'desactivar_confirmacion': 'Are you sure you want to deactivate the sensor {id}?',
      'cancelar': 'Cancel',
      'error': 'Error',
      'error_desactivar': 'Error deactivating sensor',
      'exito': 'Success',
      'aceptar': 'Accept',
      'anadir_titulo': 'Add Sensor',
      'id_sensor': 'Sensor ID',
      'campo_obligatorio': 'Required field',
      'tipo_tecnologia': 'Technology Type',
      'seleccione_tipo': 'Select a type',
      'emisor_receptor': 'Emitter/Receiver',
      'seleccione_opcion': 'Select an option',
      'crear': 'Create Sensor',
      'modificar_titulo': 'Edit Sensor',
      'guardar_cambios': 'Save Changes',
      'tipo': 'Type',
      'fecha_alta': 'Registration date',
      'estado': 'Status',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'no_asignado': 'Not assigned',
      'ubicacion': 'Location',
      'habitacion': 'Room',
      'direccion': 'Address',
      'sensor_sin_asignar': 'This sensor is not assigned to any room',
      'otros': 'Others',
      'especifique_tipo': 'Specify the type',
      'sensor_anadido': 'Sensor added successfully',
      'sensor_ya_existe': 'A sensor with this ID already exists',
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

  final TextEditingController _DesOtrosTipoSensorController =
      TextEditingController();
  final TextEditingController _EmisorReceptorController =
      TextEditingController();
  final TextEditingController _IdSensorNuevoController =
      TextEditingController();
  final TextEditingController _idSensorController = TextEditingController();

  bool _btnActiveIdSensorNuevo = false;
  bool _btnActiveTipoSensor = false;
  bool _btnActiveEmisoReceptor = false;
  late int CodTipoSensor = 1;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetTodoSensor('null');
    String Estado;
    setState(() {
      for (var p in Dbdata[0]) {
        CasaHabitacionList.add(
          CasaHabitaciones(
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
            p[14],
          ),
        );
      }
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
      
      for (var sensor in SensorList) {
        var CasaHabitacion = CasaHabitacionList.firstWhere(
          (CasaHabitacion) => CasaHabitacion.CodSensor == sensor.CodSensor,
          orElse: () => CasaHabitaciones(
            null,
            t('no_asignado'),
            '',
            '',
            '',
            null,
            '',
            '',
            '',
            '',
            '',
            null,
            null,
            '',
            null,
          ),
        );

        HabitacionSensorList.add(
          HabitacionSensor(
            sensor.CodSensor,
            sensor.IdSensor,
            sensor.DesOtros,
            sensor.EmisorReceptor,
            sensor.CodTipoSensor,
            sensor.TipoSensor,
            sensor.FechaAltaSensor,
            sensor.FechaBajaSensor,
            sensor.Estado,
            CasaHabitacion.CodHabitacion,
            CasaHabitacion.Direccion ?? '',
            CasaHabitacion.CodPostal ?? '',
            CasaHabitacion.Localidad ?? '',
            CasaHabitacion.Provincia ?? '',
            CasaHabitacion.NumPlantas,
            CasaHabitacion.Pais ?? '',
            CasaHabitacion.Numero ?? '',
            CasaHabitacion.Piso ?? '',
            CasaHabitacion.Puerta ?? '',
            CasaHabitacion.Observaciones ?? '',
            CasaHabitacion.NPlanta,
            CasaHabitacion.CodTipoHabitacion,
            CasaHabitacion.TipoHabitacion ?? '',
          ),
        );
      }
    });
    return 'Successfully Fetched data';
  }

  Future<String> getTipoSensor() async {
    var Dbdata = await DBPostgres().DBGetTipoSensor();
    setState(() {
      for (var p in Dbdata) {
        TipoSensorList.add(TipoSensor(p[0], p[1]));
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
    getTipoSensor();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViviendasScreen(tipoUsuario: 'superadmin'),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            t('titulo'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
            child: HabitacionSensorList.isEmpty
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
                          t('anade'),
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: HabitacionSensorList.length,
                    itemBuilder: (context, index) {
                      return _buildSensorCard(context, index);
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
              _showAddSensorDialog(context);
            },
            backgroundColor: colorPrimario,
            label: Text(
              t('anadir'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoSensoresInactScreen(),
              ),
            ),
            backgroundColor: Colors.red,
            label: Text(
              t('inactivos'),
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

  Widget _buildSensorCard(BuildContext context, int index) {
    final sensor = HabitacionSensorList[index];
    final tieneHabitacion = sensor.CodHabitacion != null && sensor.Direccion != t('no_asignado');
    
    return Container(
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
          // Icono del sensor
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      tieneHabitacion ? Icons.home : Icons.home_outlined,
                      size: 14,
                      color: tieneHabitacion ? Colors.green : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        tieneHabitacion
                            ? '${sensor.TipoHabitacion} - ${sensor.Direccion}'
                            : t('no_asignado'),
                        style: TextStyle(
                          fontSize: 13,
                          color: tieneHabitacion ? Colors.green.shade700 : Colors.grey.shade500,
                          fontWeight: tieneHabitacion ? FontWeight.w500 : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                _showEditSensorDialog(context, index);
              } else if (value == 'deactivate') {
                _showDeactivateDialog(context, index);
              } else if (value == 'info') {
                _showInfoBottomSheet(context, index);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info, size: 20, color: colorPrimario),
                    const SizedBox(width: 8),
                    Text(t('ver_info')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: colorPrimario),
                    const SizedBox(width: 8),
                    Text(t('modificar')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'deactivate',
                child: Row(
                  children: [
                    const Icon(Icons.block, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(t('desactivar')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddSensorDialog(BuildContext context) {
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
                      Icon(Icons.add_circle, color: colorPrimario, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        t('anadir_titulo'),
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
                    child: TextFormField(
                      controller: _IdSensorNuevoController,
                      decoration: InputDecoration(
                        labelText: t('id_sensor'),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t('campo_obligatorio');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _btnActiveIdSensorNuevo = value.isNotEmpty;
                        });
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
                    child: DropdownButtonFormField<TipoSensor>(
                      items: TipoSensorList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedSensorType(tipo.TipoSensorTabla),
                        ),
                      )).toList(),
                      onChanged: (TipoSensor? newValue) {
                        setState(() {
                          _btnActiveTipoSensor = true;
                          CodTipoSensor = newValue!.CodTipoSensor;
                          if (newValue.TipoSensorTabla == 'Otros') {
                            _showOtherValuePopup(context);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('tipo_tecnologia'),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return t('seleccione_tipo');
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
                    child: DropdownButtonFormField<String>(
                      items: _TipoEmisorReceptorList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedEmisorReceptor(tipo),
                        ),
                      )).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _btnActiveEmisoReceptor = true;
                          _EmisorReceptorController.text = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('emisor_receptor'),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return t('seleccione_opcion');
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_btnActiveTipoSensor && _btnActiveEmisoReceptor) {
                            AngadirSensorButton(context);
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
                        t('crear'),
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

  void _showEditSensorDialog(BuildContext context, int index) {
    CodTipoSensor = HabitacionSensorList[index].CodTipoSensor;
    _EmisorReceptorController.text = SensorList[index].EmisorReceptor;
    _idSensorController.text = SensorList[index].IdSensor;
    
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
                        t('modificar_titulo'),
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
                    child: TextFormField(
                      controller: _idSensorController,
                      decoration: InputDecoration(
                        labelText: t('id_sensor'),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t('campo_obligatorio');
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
                    child: DropdownButtonFormField<TipoSensor>(
                      value: TipoSensorList.firstWhere(
                        (tipo) => tipo.CodTipoSensor == HabitacionSensorList[index].CodTipoSensor,
                      ),
                      items: TipoSensorList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedSensorType(tipo.TipoSensorTabla),
                        ),
                      )).toList(),
                      onChanged: (TipoSensor? newValue) {
                        setState(() {
                          CodTipoSensor = newValue!.CodTipoSensor;
                          if (newValue.TipoSensorTabla == 'Otros') {
                            _showOtherValuePopup(context);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('tipo_tecnologia'),
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
                    child: DropdownButtonFormField<String>(
                      value: _TipoEmisorReceptorList.firstWhere(
                        (tipo) => tipo == HabitacionSensorList[index].EmisorReceptor,
                      ),
                      items: _TipoEmisorReceptorList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedEmisorReceptor(tipo),
                        ),
                      )).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _EmisorReceptorController.text = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('emisor_receptor'),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (await DBPostgres().DBModificarSensor(
                            SensorList[index].CodSensor,
                            _idSensorController.text,
                            CodTipoSensor,
                            _EmisorReceptorController.text,
                            _DesOtrosTipoSensorController.text,
                          ) == true) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoSensoresScreen(),
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
                        t('guardar_cambios'),
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
            Text(t('desactivar_titulo')),
          ],
        ),
        content: Text(
          t('desactivar_confirmacion', params: {'id': HabitacionSensorList[index].IdSensor}),
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
              bool success;
              if (HabitacionSensorList[index].CodHabitacion != null) {
                success = await DBPostgres().DBActDesactSensorConHabitacion(
                  HabitacionSensorList[index].CodHabitacion,
                  HabitacionSensorList[index].CodSensor,
                  'CURRENT_TIMESTAMP',
                  'CURRENT_TIMESTAMP',
                ) == 'Correcto';
              } else {
                success = await DBPostgres().DBActDesactSensorSinHabitacion(
                  HabitacionSensorList[index].CodSensor,
                  'CURRENT_TIMESTAMP',
                ) == 'Correcto';
              }
              
              if (success) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoSensoresScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
                _showErrorDialog(context, t('error_desactivar'));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(t('desactivar')),
          ),
        ],
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context, int index) {
    final sensor = HabitacionSensorList[index];
    final tieneHabitacion = sensor.CodHabitacion != null && sensor.Direccion != t('no_asignado');
    
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
                        colors: [
                          colorPrimario.withOpacity(0.8),
                          colorPrimario,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sensors,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  sensor.IdSensor,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2B3C),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                _buildInfoCard(
                  icon: Icons.devices,
                  label: t('tipo'),
                  value: '${getTranslatedEmisorReceptor(sensor.EmisorReceptor)}: ${getTranslatedSensorType(sensor.TipoSensor)}${sensor.DesOtros}',
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: t('fecha_alta'),
                  value: formatDate(sensor.FechaAltaSensor, [dd, '/', mm, '/', yyyy]),
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoCard(
                  icon: Icons.info,
                  label: t('estado'),
                  value: sensor.Estado == 'Activo' ? t('activo') : t('inactivo'),
                  valueColor: sensor.Estado == 'Activo' ? Colors.green : Colors.red,
                ),
                
                if (tieneHabitacion) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  Text(
                    t('ubicacion'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.room,
                    label: t('habitacion'),
                    value: '${sensor.TipoHabitacion} ${sensor.Observaciones}',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.home,
                    label: t('direccion'),
                    value: '${sensor.Direccion}, ${sensor.Numero}, ${sensor.Piso} ${sensor.Puerta}, ${sensor.Localidad}, ${sensor.Provincia}, ${sensor.Pais}, ${sensor.CodPostal}',
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
                        t('sensor_sin_asignar'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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

  Widget _buildInfoCard({
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Color(0xFF1A2B3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
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
        content: Text(message),
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Text(t('exito')),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoSensoresScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colorPrimario,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                t('aceptar'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOtherValuePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: colorPrimario),
              const SizedBox(width: 10),
              Text(t('otros')),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: t('especifique_tipo'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _DesOtrosTipoSensorController.text = "($value)";
            },
          ),
          actions: [
            TextButton(
              child: Text(
                t('aceptar'),
                style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> AngadirSensorButton(BuildContext context) async {
    var newsensorOk = await DBPostgres().DBAnagdirSensorNuevo(
      _IdSensorNuevoController.text,
      CodTipoSensor,
      _EmisorReceptorController.text,
      _DesOtrosTipoSensorController.text,
    );
    if (newsensorOk == true) {
      _showSuccessDialog(context, t('sensor_anadido'));
    } else if (newsensorOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, t('sensor_ya_existe'));
    }
  }
}

/// **********************************************************************
/// Clase que muestra la informacion de un sensor y su ubicación
///**********************************************************************
class SensorInfoScreen extends StatelessWidget {
  final HabitacionSensor habitacionSensorList;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  SensorInfoScreen({super.key, required this.habitacionSensorList});

  // Mapa de traducciones para esta pantalla
  final Map<String, Map<String, String>> translations = {
    'es': {
      'habitacion': 'Habitación',
      'direccion': 'Dirección',
      'sensor_sin_asignar': 'Este sensor no está asignado a ninguna habitación',
    },
    'en': {
      'habitacion': 'Room',
      'direccion': 'Address',
      'sensor_sin_asignar': 'This sensor is not assigned to any room',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

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

  String getTranslatedRoomType(String type) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return roomTypeTranslations[type] ?? type;
    }
    return type;
  }

  String getTranslatedCountry(String country) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsPais[country] ?? country;
    }
    return country;
  }

  @override
  Widget build(BuildContext context) {
    final tieneHabitacion = habitacionSensorList.CodHabitacion != null && 
                            habitacionSensorList.Direccion != 'No asignado';
    
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
                child: const Icon(
                  Icons.sensors,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              habitacionSensorList.IdSensor,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B3C),
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (tieneHabitacion) ...[
              _buildInfoCard(
                icon: Icons.room,
                label: t('habitacion'),
                value: '${getTranslatedRoomType(habitacionSensorList.TipoHabitacion)} ${habitacionSensorList.Observaciones}',
              ),
              
              const SizedBox(height: 12),
              
              _buildInfoCard(
                icon: Icons.home,
                label: t('direccion'),
                value: '${habitacionSensorList.Direccion}, ${habitacionSensorList.Numero}, ${habitacionSensorList.Piso} ${habitacionSensorList.Puerta}, ${habitacionSensorList.Localidad}, ${habitacionSensorList.Provincia}, ${getTranslatedCountry(habitacionSensorList.Pais)}, ${habitacionSensorList.CodPostal}',
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    t('sensor_sin_asignar'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
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

class CasaHabitaciones {
  final int? CodHabitacion;
  final String Direccion;
  final String CodPostal;
  final String Localidad;
  final String Provincia;
  final int? NumPlantas;
  final String Pais;
  final String Numero;
  final String Piso;
  final String Puerta;
  final String Observaciones;
  final int? NPlanta;
  final int? CodTipoHabitacion;
  final String TipoHabitacion;
  final int? CodSensor;

  CasaHabitaciones(
    this.CodHabitacion,
    this.Direccion,
    this.CodPostal,
    this.Localidad,
    this.Provincia,
    this.NumPlantas,
    this.Pais,
    this.Numero,
    this.Piso,
    this.Puerta,
    this.Observaciones,
    this.NPlanta,
    this.CodTipoHabitacion,
    this.TipoHabitacion,
    this.CodSensor,
  );
}

class HabitacionSensor {
  final int CodSensor;
  final String IdSensor;
  final String DesOtros;
  final String EmisorReceptor;
  final int CodTipoSensor;
  final String TipoSensor;
  final DateTime FechaAltaSensor;
  final DateTime? FechaBajaSensor;
  final String Estado;
  final int? CodHabitacion;
  final String Direccion;
  final String CodPostal;
  final String Localidad;
  final String Provincia;
  final int? NumPlantas;
  final String Pais;
  final String Numero;
  final String Piso;
  final String Puerta;
  final String Observaciones;
  final int? NPlanta;
  final int? CodTipoHabitacion;
  final String TipoHabitacion;

  HabitacionSensor(
    this.CodSensor,
    this.IdSensor,
    this.DesOtros,
    this.EmisorReceptor,
    this.CodTipoSensor,
    this.TipoSensor,
    this.FechaAltaSensor,
    this.FechaBajaSensor,
    this.Estado,
    this.CodHabitacion,
    this.Direccion,
    this.CodPostal,
    this.Localidad,
    this.Provincia,
    this.NumPlantas,
    this.Pais,
    this.Numero,
    this.Piso,
    this.Puerta,
    this.Observaciones,
    this.NPlanta,
    this.CodTipoHabitacion,
    this.TipoHabitacion,
  );
}

class TipoSensor {
  final int CodTipoSensor;
  final String TipoSensorTabla;

  TipoSensor(this.CodTipoSensor, this.TipoSensorTabla);
}