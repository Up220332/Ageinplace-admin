/// ****************************************************************************
/// Funcion que devueleve todos los wearables y permite gestionarlos
///*****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_TodoWearablesInact.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class TodoWearablesScreen extends StatefulWidget {
  const TodoWearablesScreen({super.key});

  @override
  State<TodoWearablesScreen> createState() => _TodoWearablesScreenState();
}

class _TodoWearablesScreenState extends State<TodoWearablesScreen> {
  List<Wearables> WearableList = [];
  List<Wearables> WearableDispList = [];
  List<Pacientes> PacientesList = [];
  List<TipoWearable> TipoWearableList = [];
  List<PacienteWearable> PacienteWearablesList = [];

  final TextEditingController _DesOtrosTipoWearableController =
      TextEditingController();
  final TextEditingController _IdWearableNuevoController =
      TextEditingController();
  final TextEditingController _idWearableController = TextEditingController();

  bool _btnActiveIdWearableNuevo = false;
  bool _btnActiveTipoWearable = false;
  late int CodTipoWearable = 1;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Wearables',
      'no_hay': 'No hay wearables registrados',
      'anade': 'Añade wearables usando el botón +',
      'anadir': 'Añadir Wearable',
      'inactivos': 'Wearables Inactivos',
      'ver_info': 'Ver información',
      'modificar': 'Modificar',
      'desactivar': 'Desactivar',
      'desactivar_titulo': '¿Desactivar wearable?',
      'desactivar_confirmacion': '¿Está seguro que desea desactivar el wearable {id}?',
      'cancelar': 'Cancelar',
      'error': 'Error',
      'error_desactivar': 'Error al desactivar el wearable',
      'exito': 'Éxito',
      'aceptar': 'Aceptar',
      'anadir_titulo': 'Añadir Wearable',
      'id_wearable': 'ID del Wearable',
      'campo_obligatorio': 'Campo obligatorio',
      'tipo_wearable': 'Tipo de Wearable',
      'seleccione_tipo': 'Seleccione un tipo',
      'crear': 'Crear Wearable',
      'modificar_titulo': 'Modificar Wearable',
      'guardar_cambios': 'Guardar Cambios',
      'tipo': 'Tipo',
      'fecha_alta': 'Fecha de alta',
      'estado': 'Estado',
      'activo': 'Activo',
      'inactivo': 'Inactivo',
      'no_asignado': 'No asignado',
      'paciente_asignado': 'Paciente Asignado',
      'nombre': 'Nombre',
      'email': 'Email',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'otros': 'Otros',
      'especifique_tipo': 'Especifique el tipo',
      'wearable_anadido': 'Wearable añadido correctamente',
      'wearable_ya_existe': 'El wearable ya existe',
      'wearable_sin_asignar': 'Wearable sin asignar',
      'wearable_sin_asignar_msg': 'Este wearable no está asignado a ningún paciente',
    },
    'en': {
      'titulo': 'Wearables',
      'no_hay': 'No wearables registered',
      'anade': 'Add wearables using the + button',
      'anadir': 'Add Wearable',
      'inactivos': 'Inactive Wearables',
      'ver_info': 'View information',
      'modificar': 'Edit',
      'desactivar': 'Deactivate',
      'desactivar_titulo': 'Deactivate wearable?',
      'desactivar_confirmacion': 'Are you sure you want to deactivate the wearable {id}?',
      'cancelar': 'Cancel',
      'error': 'Error',
      'error_desactivar': 'Error deactivating wearable',
      'exito': 'Success',
      'aceptar': 'Accept',
      'anadir_titulo': 'Add Wearable',
      'id_wearable': 'Wearable ID',
      'campo_obligatorio': 'Required field',
      'tipo_wearable': 'Wearable Type',
      'seleccione_tipo': 'Select a type',
      'crear': 'Create Wearable',
      'modificar_titulo': 'Edit Wearable',
      'guardar_cambios': 'Save Changes',
      'tipo': 'Type',
      'fecha_alta': 'Registration date',
      'estado': 'Status',
      'activo': 'Active',
      'inactivo': 'Inactive',
      'no_asignado': 'Not assigned',
      'paciente_asignado': 'Assigned Patient',
      'nombre': 'Name',
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'otros': 'Others',
      'especifique_tipo': 'Specify the type',
      'wearable_anadido': 'Wearable added successfully',
      'wearable_ya_existe': 'The wearable already exists',
      'wearable_sin_asignar': 'Unassigned Wearable',
      'wearable_sin_asignar_msg': 'This wearable is not assigned to any patient',
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

  Map<String, String> wearableTypeTranslations = {
    'Banda': 'Band',
    'Colgante': 'Pendant',
    'Llavero': 'Keychain',
    'Reloj': 'Watch',
    'Textil': 'Textile',
    'Otros': 'Others',
  };

  // Función para obtener el nombre traducido del tipo de wearable
  String getTranslatedWearableType(String type) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return wearableTypeTranslations[type] ?? type;
    }
    return type;
  }

  Future<String> getData() async {
    String Estado;
    var Dbdata = await DBPostgres().DBGetTodoWarable('null');
    setState(() {
      for (var p in Dbdata[0]) {
        PacientesList.add(
          Pacientes(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]),
        );
      }
      for (var p in Dbdata[1]) {
        if (p[5] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        WearableList.add(
          Wearables(p[0], p[1], p[2], p[3], p[4], p[5], p[6], Estado),
        );
      }
    });

    for (var wearable in WearableList) {
      var paciente = PacientesList.firstWhere(
        (paciente) => paciente.CodWearable == wearable.CodWearable,
        orElse: () => Pacientes(
          null,
          t('no_asignado'),
          '',
          '',
          '',
          '',
          '',
          '',
          null,
        ),
      );

      PacienteWearablesList.add(
        PacienteWearable(
          wearable.CodWearable,
          wearable.IdWearable,
          wearable.DesOtros,
          wearable.CodTipoWearable,
          wearable.TipoWeareable,
          wearable.FechaAltaWearable,
          wearable.FechaBajaWearable,
          wearable.Estado,
          paciente.CodPaciente,
          paciente.Nombre ?? '',
          paciente.Apellido1 ?? '',
          paciente.Apellido2 ?? '',
          paciente.FechaNacimiento ?? '',
          paciente.Telefono ?? '',
          paciente.Mail ?? '',
          paciente.Organizacion ?? '',
        ),
      );
    }
    return 'Successfully Fetched data';
  }

  Future<String> getTipoWearable() async {
    var Dbdata = await DBPostgres().DBGetTipoWearable();
    setState(() {
      for (var p in Dbdata) {
        TipoWearableList.add(TipoWearable(p[0], p[1]));
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
    getTipoWearable();
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
            child: PacienteWearablesList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.watch_off_outlined, size: 80, color: Colors.grey.shade400),
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
                    itemCount: PacienteWearablesList.length,
                    itemBuilder: (context, index) {
                      return _buildWearableCard(context, index);
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
              _showAddWearableDialog(context);
            },
            label: Text(
              t('anadir'),
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoWearablesInactScreen(),
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

  Widget _buildWearableCard(BuildContext context, int index) {
    final wearable = PacienteWearablesList[index];
    final tienePaciente = wearable.CodPaciente != null && wearable.Nombre != t('no_asignado');
    
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
          // Icono del wearable
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
              Icons.watch,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          
          // Información del wearable
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wearable.IdWearable,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.devices, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        (getTranslatedWearableType(wearable.TipoWeareable)) +
                            wearable.DesOtros,
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
                      tienePaciente ? Icons.person : Icons.person_outline,
                      size: 14,
                      color: tienePaciente ? Colors.green : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        tienePaciente
                            ? '${wearable.Nombre} ${wearable.Apellido1}'
                            : t('no_asignado'),
                        style: TextStyle(
                          fontSize: 13,
                          color: tienePaciente ? Colors.green.shade700 : Colors.grey.shade500,
                          fontWeight: tienePaciente ? FontWeight.w500 : FontWeight.normal,
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
                _showEditWearableDialog(context, index);
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

  void _showAddWearableDialog(BuildContext context) {
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
                      controller: _IdWearableNuevoController,
                      decoration: InputDecoration(
                        labelText: t('id_wearable'),
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
                          _btnActiveIdWearableNuevo = value.isNotEmpty;
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
                    child: DropdownButtonFormField<TipoWearable>(
                      items: TipoWearableList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedWearableType(tipo.TipoWearableTabla),
                        ),
                      )).toList(),
                      onChanged: (TipoWearable? newValue) {
                        setState(() {
                          _btnActiveTipoWearable = true;
                          CodTipoWearable = newValue!.CodTipoWearable;
                          if (newValue.TipoWearableTabla == 'Otros') {
                            _showOtherValuePopup(context);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('tipo_wearable'),
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
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_btnActiveTipoWearable) {
                            AngadirWearableButton(context);
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

  void _showEditWearableDialog(BuildContext context, int index) {
    _idWearableController.text = PacienteWearablesList[index].IdWearable;
    CodTipoWearable = PacienteWearablesList[index].CodTipoWearable;
    
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
                      controller: _idWearableController,
                      decoration: InputDecoration(
                        labelText: t('id_wearable'),
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
                    child: DropdownButtonFormField<TipoWearable>(
                      value: TipoWearableList.firstWhere(
                        (tipo) => tipo.CodTipoWearable == PacienteWearablesList[index].CodTipoWearable,
                      ),
                      items: TipoWearableList.map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(
                          getTranslatedWearableType(tipo.TipoWearableTabla),
                        ),
                      )).toList(),
                      onChanged: (TipoWearable? newValue) {
                        setState(() {
                          CodTipoWearable = newValue!.CodTipoWearable;
                          if (newValue.TipoWearableTabla == 'Otros') {
                            _showOtherValuePopup(context);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('tipo_wearable'),
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
                          if (await DBPostgres().DBModificarWearable(
                            WearableList[index].CodWearable,
                            _idWearableController.text,
                            CodTipoWearable,
                            _DesOtrosTipoWearableController.text,
                          ) == true) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoWearablesScreen(),
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
          t('desactivar_confirmacion', params: {'id': PacienteWearablesList[index].IdWearable}),
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
              if (PacienteWearablesList[index].CodPaciente != null) {
                success = await DBPostgres().DBActDesActWearableConPaciente(
                  PacienteWearablesList[index].CodPaciente,
                  PacienteWearablesList[index].CodWearable,
                  'CURRENT_TIMESTAMP',
                  'CURRENT_TIMESTAMP',
                ) == 'Correcto';
              } else {
                success = await DBPostgres().DBActDesActWearableSinPaciente(
                  PacienteWearablesList[index].CodWearable,
                  'CURRENT_TIMESTAMP',
                ) == 'Correcto';
              }
              
              if (success) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoWearablesScreen(),
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
    final wearable = PacienteWearablesList[index];
    final tienePaciente = wearable.CodPaciente != null && wearable.Nombre != t('no_asignado');
    
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
                      Icons.watch,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  wearable.IdWearable,
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
                  value: (getTranslatedWearableType(wearable.TipoWeareable)) +
                      wearable.DesOtros,
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: t('fecha_alta'),
                  value: formatDate(wearable.FechaAltaWearable, [dd, '/', mm, '/', yyyy]),
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoCard(
                  icon: Icons.info,
                  label: t('estado'),
                  value: wearable.Estado == 'Activo' ? t('activo') : t('inactivo'),
                  valueColor: wearable.Estado == 'Activo' ? Colors.green : Colors.red,
                ),
                
                if (tienePaciente) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  Text(
                    t('paciente_asignado'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.person,
                    label: t('nombre'),
                    value: '${wearable.Nombre} ${wearable.Apellido1} ${wearable.Apellido2}',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.email,
                    label: t('email'),
                    value: wearable.Mail,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.phone,
                    label: t('telefono'),
                    value: wearable.Telefono,
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
                  builder: (context) => TodoWearablesScreen(),
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
              _DesOtrosTipoWearableController.text = "($value)";
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

  Future<void> AngadirWearableButton(BuildContext context) async {
    var newwearableOk = await DBPostgres().DBAnagdirWearableNuevo(
      _IdWearableNuevoController.text,
      CodTipoWearable,
      _DesOtrosTipoWearableController.text,
    );
    if (newwearableOk == true) {
      _showSuccessDialog(context, t('wearable_anadido'));
    } else if (newwearableOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, t('wearable_ya_existe'));
    }
  }
}

/// **********************************************************************
/// Clase que muestra la informacion de un paciente y los wearables que
/// tiene asociados
///**********************************************************************
class WearableInfoScreen extends StatelessWidget {
  final PacienteWearable PacienteWearableList;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  WearableInfoScreen({super.key, required this.PacienteWearableList});

  // Mapa de traducciones para esta pantalla
  final Map<String, Map<String, String>> translations = {
    'es': {
      'email': 'Correo electrónico',
      'telefono': 'Teléfono',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'wearable_sin_asignar': 'Wearable sin asignar',
      'wearable_sin_asignar_msg': 'Este wearable no está asignado a ningún paciente',
    },
    'en': {
      'email': 'Email',
      'telefono': 'Phone',
      'fecha_nacimiento': 'Birth date',
      'wearable_sin_asignar': 'Unassigned Wearable',
      'wearable_sin_asignar_msg': 'This wearable is not assigned to any patient',
    }
  };

  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Map<String, String> wearableTypeTranslations = {
    'Banda': 'Band',
    'Colgante': 'Pendant',
    'Llavero': 'Keychain',
    'Reloj': 'Watch',
    'Textil': 'Textile',
    'Otros': 'Others',
  };

  String getTranslatedWearableType(String type) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return wearableTypeTranslations[type] ?? type;
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    final tienePaciente = PacienteWearableList.CodPaciente != null && 
                          PacienteWearableList.Nombre != 'No asignado';
    
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
            
            if (tienePaciente) ...[
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
                      '${PacienteWearableList.Nombre[0]}${PacienteWearableList.Apellido1[0]}',
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
              
              Text(
                '${PacienteWearableList.Nombre} ${PacienteWearableList.Apellido1} ${PacienteWearableList.Apellido2}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2B3C),
                ),
              ),
              
              const SizedBox(height: 24),
              
              _buildInfoCard(
                icon: Icons.email,
                label: t('email'),
                value: PacienteWearableList.Mail,
              ),
              
              const SizedBox(height: 12),
              
              _buildInfoCard(
                icon: Icons.phone,
                label: t('telefono'),
                value: PacienteWearableList.Telefono,
              ),
              
              const SizedBox(height: 12),
              
              _buildInfoCard(
                icon: Icons.cake,
                label: t('fecha_nacimiento'),
                value: PacienteWearableList.FechaNacimiento,
              ),
            ] else ...[
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.5),
                        Colors.grey,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.watch_off,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                t('wearable_sin_asignar'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2B3C),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    t('wearable_sin_asignar_msg'),
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

class Wearables {
  final int CodWearable;
  final String IdWearable;
  final String DesOtros;
  final int CodTipoWearable;
  final String TipoWeareable;
  final DateTime FechaAltaWearable;
  final DateTime? FechaBajaWearable;
  final String Estado;

  Wearables(
    this.CodWearable,
    this.IdWearable,
    this.DesOtros,
    this.CodTipoWearable,
    this.TipoWeareable,
    this.FechaAltaWearable,
    this.FechaBajaWearable,
    this.Estado,
  );
}

class Pacientes {
  final int? CodPaciente;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Mail;
  final String Organizacion;
  final int? CodWearable;

  Pacientes(
    this.CodPaciente,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Mail,
    this.Organizacion,
    this.CodWearable,
  );
}

class PacienteWearable {
  final int CodWearable;
  final String IdWearable;
  final String DesOtros;
  final int CodTipoWearable;
  final String TipoWeareable;
  final DateTime FechaAltaWearable;
  final DateTime? FechaBajaWearable;
  final String Estado;
  final int? CodPaciente;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Mail;
  final String Organizacion;

  PacienteWearable(
    this.CodWearable,
    this.IdWearable,
    this.DesOtros,
    this.CodTipoWearable,
    this.TipoWeareable,
    this.FechaAltaWearable,
    this.FechaBajaWearable,
    this.Estado,
    this.CodPaciente,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Mail,
    this.Organizacion,
  );
}

class TipoWearable {
  final int CodTipoWearable;
  final String TipoWearableTabla;

  TipoWearable(this.CodTipoWearable, this.TipoWearableTabla);
}