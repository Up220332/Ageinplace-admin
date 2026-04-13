import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:marquee/marquee.dart';
import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';

import '../SuperAdmin/screen_habitaciones.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../base_de_datos/postgres.dart';

class SensoresScreen extends StatefulWidget {
  final String role;
  final Habitacion habitacion;
  final Vivienda vivienda;

  const SensoresScreen({
    super.key,
    required this.habitacion,
    required this.vivienda,
    required this.role,
  });

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  List<Sensor> SensorList = [];
  List<Sensor> SensorDispList = [];
  List<TipoSensor> TipoSensorList = [];
  final List<String> _TipoEmisorReceptorList = [
    "Emisor",
    "Receptor",
    "Emisor-Receptor",
  ];
  
  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'sensores_de': 'Sensores de',
      'no_hay': 'No hay sensores en esta habitación',
      'anade': 'Añade sensores usando el botón +',
      'anadir': 'Añadir Sensor',
      'anadir_titulo': 'Añadir Sensor',
      'modificar': 'Modificar',
      'desactivar': 'Desactivar',
      'desactivar_titulo': '¿Desactivar sensor?',
      'desactivar_confirmacion': '¿Está seguro que desea desactivar el sensor {id}?',
      'cancelar': 'Cancelar',
      'error': 'Error',
      'error_desactivar': 'Error al desactivar el sensor',
      'exito': 'Éxito',
      'aceptar': 'Aceptar',
      'sensor_existente': 'Sensor Existente',
      'seleccionar_sensor': 'Seleccionar sensor',
      'o_nuevo_sensor': 'O Nuevo Sensor',
      'id_sensor': 'ID del Sensor',
      'tipo_tecnologia': 'Tipo de Tecnología',
      'emisor_receptor': 'Emisor/Receptor',
      'continuar': 'Continuar',
      'modificar_titulo': 'Modificar Sensor',
      'guardar_cambios': 'Guardar Cambios',
      'campo_obligatorio': 'Campo obligatorio',
      'seleccione_opcion': 'Seleccione solo una opción',
      'complete_campos': 'Complete todos los campos para el nuevo sensor',
      'seleccione_opcion_general': 'Seleccione un sensor existente o cree uno nuevo',
      'otros': 'Otros',
      'especifique_tipo': 'Especifique el tipo',
      'sensor_anadido': 'Sensor añadido correctamente',
      'sensor_ya_existe': 'Ya existe un sensor con ese ID',
      'sensor_ya_asignado': 'Este sensor ya está asignado a otra habitación',
    },
    'en': {
      'sensores_de': 'Sensors of',
      'no_hay': 'No sensors in this room',
      'anade': 'Add sensors using the + button',
      'anadir': 'Add Sensor',
      'anadir_titulo': 'Add Sensor',
      'modificar': 'Edit',
      'desactivar': 'Deactivate',
      'desactivar_titulo': 'Deactivate sensor?',
      'desactivar_confirmacion': 'Are you sure you want to deactivate the sensor {id}?',
      'cancelar': 'Cancel',
      'error': 'Error',
      'error_desactivar': 'Error deactivating sensor',
      'exito': 'Success',
      'aceptar': 'Accept',
      'sensor_existente': 'Existing Sensor',
      'seleccionar_sensor': 'Select sensor',
      'o_nuevo_sensor': 'Or New Sensor',
      'id_sensor': 'Sensor ID',
      'tipo_tecnologia': 'Technology Type',
      'emisor_receptor': 'Emitter/Receiver',
      'continuar': 'Continue',
      'modificar_titulo': 'Edit Sensor',
      'guardar_cambios': 'Save Changes',
      'campo_obligatorio': 'Required field',
      'seleccione_opcion': 'Select only one option',
      'complete_campos': 'Complete all fields for the new sensor',
      'seleccione_opcion_general': 'Select an existing sensor or create a new one',
      'otros': 'Others',
      'especifique_tipo': 'Specify the type',
      'sensor_anadido': 'Sensor added successfully',
      'sensor_ya_existe': 'A sensor with this ID already exists',
      'sensor_ya_asignado': 'This sensor is already assigned to another room',
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
  final TextEditingController _IdSensorExistenteController =
      TextEditingController();
  final TextEditingController _idSensorController = TextEditingController();

  bool _btnActiveIdSensorNuevo = false;
  bool _btnActiveIdSensorExistente = false;
  bool _btnActiveTipoSensor = false;
  bool _btnActiveEmisoReceptor = false;
  late int CodTipoSensor = 1;
  late int CodSensor = 1;
  late int CodHabitacionSensorExist = 1;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  Sensor noneSensor = Sensor(
    0,
    "Ninguno",
    0,
    "",
    DateTime.now(),
    null,
    "none",
    0,
    "none",
    "none",
  );

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetSensor(
      widget.habitacion.CodHabitacion,
    );
    String Estado;
    setState(() {
      for (var p in Dbdata) {
        if (p[5] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        SensorList.add(
          Sensor(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], Estado),
        );
      }
    });
    return 'Successfully Fetched data';
  }

  Future<String> getSensorDisp() async {
    var Dbdata = await DBPostgres().DBGetSensorDisp();
    List<Sensor> sensorList = [];
    Map<String, Sensor> uniqueSensorsMap = {};
    for (var p in Dbdata) {
      String Estado;
      if (p[5] == null) {
        Estado = 'Activo';
      } else {
        Estado = 'Inactivo';
      }
      sensorList.add(
        Sensor(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], Estado),
      );
    }

    for (Sensor sensor in sensorList) {
      if (!uniqueSensorsMap.containsKey(sensor.IdSensor)) {
        uniqueSensorsMap[sensor.IdSensor] = sensor;
      } else if (sensor.CodHabitacion == widget.habitacion.CodHabitacion) {
        uniqueSensorsMap[sensor.IdSensor] = sensor;
      }
    }

    SensorDispList = uniqueSensorsMap.values.toList();
    SensorDispList.add(noneSensor);

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
    getSensorDisp();
    getTipoSensor();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HabitacionesScreen(
              CodCasa: widget.vivienda.CodCasa,
              vivienda: widget.vivienda,
              role: widget.role,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        endDrawer: const NavBarSuperAdmin(), // Drawer lateral derecho
        floatingActionButton: _buildFloatingActionButton(context),
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
          // Botón para abrir el endDrawer
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
          title: Center(
            child: SizedBox(
              height: 50,
              child: Marquee(
                text: '${t('sensores_de')}: ${widget.habitacion.TipoHabitacion} ${widget.habitacion.Observaciones}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 100.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
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
                          t('anade'),
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () {
          getSensorDisp();
          _showAddSensorDialog(context);
        },
        label: Text(
          t('anadir'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: colorPrimario,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSensorCard(BuildContext context, int index) {
    final sensor = SensorList[index];
    
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
                  '${getTranslatedEmisorReceptor(sensor.EmisorReceptor)}, ${getTranslatedSensorType(sensor.TipoSensor)}${sensor.DesOtros}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Botón de opciones
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
              }
            },
            itemBuilder: (BuildContext context) => [
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
                  
                  Text(
                    t('sensor_existente'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonFormField<Sensor>(
                      items: SensorDispList.map((sensor) => DropdownMenuItem(
                        value: sensor,
                        child: Text(sensor.IdSensor),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _btnActiveIdSensorExistente = true;
                            CodSensor = value.CodSensor;
                            _IdSensorExistenteController.text = value.IdSensor;
                            CodHabitacionSensorExist = value.CodHabitacion!;
                            if (value.IdSensor == 'Ninguno') {
                              _btnActiveIdSensorExistente = false;
                            }
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: t('seleccionar_sensor'),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    t('o_nuevo_sensor'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
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
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleAddSensor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        t('continuar'),
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
                        (tipo) => tipo.CodTipoSensor == SensorList[index].CodTipoSensor,
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
                        (tipo) => tipo == SensorList[index].EmisorReceptor,
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
                                builder: (context) => SensoresScreen(
                                  habitacion: widget.habitacion,
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
          t('desactivar_confirmacion', params: {'id': SensorList[index].IdSensor}),
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
              var Dbdata = await DBPostgres().DBActDesactSensorHabitacion(
                widget.habitacion.CodHabitacion,
                SensorList[index].CodSensor,
              );
              if (Dbdata == 'Correcto') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SensoresScreen(
                      habitacion: widget.habitacion,
                      vivienda: widget.vivienda,
                      role: widget.role,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
                _showErrorDialog(t('error_desactivar'));
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

  void _handleAddSensor() {
    if (_btnActiveIdSensorExistente && _btnActiveIdSensorNuevo) {
      _showErrorDialog(t('seleccione_opcion'));
    } else if (_btnActiveIdSensorExistente && !_btnActiveIdSensorNuevo) {
      if (CodHabitacionSensorExist == widget.habitacion.CodHabitacion) {
        AngadirSensorExistenteButton();
      } else {
        AngadirSensorDispButton();
      }
    } else if (!_btnActiveIdSensorExistente && _btnActiveIdSensorNuevo) {
      if (_btnActiveEmisoReceptor && _btnActiveTipoSensor) {
        AngadirSensorButton();
      } else {
        _showErrorDialog(t('complete_campos'));
      }
    } else {
      _showErrorDialog(t('seleccione_opcion_general'));
    }
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

  void _showSuccessDialog(String message) {
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
                  builder: (context) => SensoresScreen(
                    habitacion: widget.habitacion,
                    vivienda: widget.vivienda,
                    role: widget.role,
                  ),
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

  Future<void> AngadirSensorButton() async {
    var newsensorOk = await DBPostgres().DBAnagdirSensor(
      _IdSensorNuevoController.text,
      widget.habitacion.CodHabitacion,
      CodTipoSensor,
      _EmisorReceptorController.text,
      _DesOtrosTipoSensorController.text,
    );
    if (newsensorOk == true) {
      _showSuccessDialog(t('sensor_anadido'));
    } else if (newsensorOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(t('sensor_ya_existe'));
    }
  }

  Future<void> AngadirSensorExistenteButton() async {
    var newsensorOk = await DBPostgres().DBAnagdirSensorExistente(
      CodSensor,
      widget.habitacion.CodHabitacion,
    );
    if (newsensorOk == true) {
      _showSuccessDialog(t('sensor_anadido'));
    } else if (newsensorOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(t('sensor_ya_asignado'));
    }
  }

  Future<void> AngadirSensorDispButton() async {
    var newsensorOk = await DBPostgres().DBAnagdirSensorDisp(
      CodSensor,
      widget.habitacion.CodHabitacion,
    );
    if (newsensorOk == true) {
      _showSuccessDialog(t('sensor_anadido'));
    } else if (newsensorOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(t('sensor_ya_asignado'));
    }
  }
}

class Sensor {
  final int CodSensor;
  final String IdSensor;
  final int? CodHabitacion;
  final String EmisorReceptor;
  final DateTime? F_Alta;
  final DateTime? F_Baja;
  final String TipoSensor;
  final int CodTipoSensor;
  final String DesOtros;
  final String Estado;

  Sensor(
    this.CodSensor,
    this.IdSensor,
    this.CodHabitacion,
    this.EmisorReceptor,
    this.F_Alta,
    this.F_Baja,
    this.TipoSensor,
    this.CodTipoSensor,
    this.DesOtros,
    this.Estado,
  );
}

class TipoSensor {
  final int CodTipoSensor;
  final String TipoSensorTabla;

  TipoSensor(this.CodTipoSensor, this.TipoSensorTabla);
}