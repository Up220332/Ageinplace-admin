/// *****************************************************************************
/// Funcion que devuelve los tipos de habitacion que existen y permite crear nuevos
/// tipos o modificarlos
///****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class TipoHabitacionScreen extends StatefulWidget {
  const TipoHabitacionScreen({super.key});

  @override
  State<TipoHabitacionScreen> createState() => _TipoHabitacionScreen();
}

class _TipoHabitacionScreen extends State<TipoHabitacionScreen> {
  List<TipodeHabitacion> TipoHabitacionList = [];
  final TextEditingController _TipoHabitacionController = TextEditingController();

  bool _btnActiveTipoHabitacion = false;
  late int CodTipoHabitacion = 1;
  late String _currentLocale;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Tipos de Habitaciones',
      'aniadir': 'Añadir tipo de habitación',
      'modificar_eliminar': 'Modificar tipo de habitación o eliminarlo',
      'habitacion': 'Tipo de habitación',
      'campo_vacio': 'El campo no puede estar vacío',
      'continuar': 'Continuar',
      'modificar': 'Modificar',
      'eliminar': 'Eliminar',
      'error': 'Error',
      'rellene_campo': 'Por favor, rellene el campo',
      'ok': 'OK',
      'no_eliminar': 'No se puede eliminar el tipo de habitación porque está en uso',
      'ya_existe': 'Ya existe el tipo de habitación',
      'aceptar': 'Aceptar',
      'cancelar': 'Cancelar',
      'no_hay': 'No hay tipos de habitación',
      'modificado': 'Tipo de habitación modificado correctamente',
      'eliminado': 'Tipo de habitación eliminado correctamente',
      'aniadido': 'Tipo de habitación añadido correctamente',
    },
    'en': {
      'titulo': 'Room Types',
      'aniadir': 'Add room type',
      'modificar_eliminar': 'Modify or delete room type',
      'habitacion': 'Room type',
      'campo_vacio': 'The field cannot be empty',
      'continuar': 'Continue',
      'modificar': 'Modify',
      'eliminar': 'Delete',
      'error': 'Error',
      'rellene_campo': 'Please fill in the field',
      'ok': 'OK',
      'no_eliminar': 'The room type cannot be deleted because it is in use',
      'ya_existe': 'The room type already exists',
      'aceptar': 'Accept',
      'cancelar': 'Cancel',
      'no_hay': 'No room types',
      'modificado': 'Room type modified successfully',
      'eliminado': 'Room type deleted successfully',
      'aniadido': 'Room type added successfully',
    }
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
    'Patio': 'Yard',
    'Salón': 'Living Room',
    'Sótano': 'Basement',
    'Trastero': 'Storage Room',
    'Otros': 'Others',
    'Zona no Sensorizada': 'Non-Sensorized Area',
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Función para obtener el nombre traducido del tipo de habitación
  String getTranslatedRoomType(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return roomTypeTranslations[original] ?? original;
    }
    return original;
  }

  Future<String> getTipoHabitacion() async {
    var Dbdata = await DBPostgres().DBGetTipoHabitacion();
    setState(() {
      TipoHabitacionList.clear();
      for (var p in Dbdata) {
        TipoHabitacionList.add(TipodeHabitacion(p[0], p[1]));
      }
    });
    TipoHabitacionList = TipoHabitacionList.where(
      (tipoHabitacion) => tipoHabitacion.TipoHabitacionTabla != "Otros",
    ).toList();
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    _currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    getTipoHabitacion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String newLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (_currentLocale != newLocale) {
      setState(() {
        _currentLocale = newLocale;
      });
    }
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
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "btn1",
          onPressed: () {
            _showAddTipoHabitacionDialog();
          },
          label: Text(
            t('aniadir'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: colorPrimario,
        ),
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
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: TipoHabitacionList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.meeting_room_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        t('no_hay'),
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: TipoHabitacionList.length,
                    itemBuilder: (context, index) {
                      return _buildTipoHabitacionCard(context, index);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTipoHabitacionCard(BuildContext context, int index) {
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
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _showEditDeleteDialog(context, index), // Cambiado a onTap
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de tipo de habitación
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorPrimario.withOpacity(0.8),
                        colorPrimario,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.meeting_room,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nombre del tipo de habitación
                Expanded(
                  child: Text(
                    getTranslatedRoomType(TipoHabitacionList[index].TipoHabitacionTabla),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Indicador de edición
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorPrimario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: colorPrimario,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTipoHabitacionDialog() {
    _TipoHabitacionController.clear();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: colorPrimario),
                  const SizedBox(width: 10),
                  Text(t('aniadir')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _TipoHabitacionController,
                      obscureText: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t('campo_vacio');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setStateDialog(() {
                          _btnActiveTipoHabitacion = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('habitacion'),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(Icons.meeting_room, size: 20, color: colorPrimario),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colorPrimario, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _btnActiveTipoHabitacion ? () => ContinuaButton(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnActiveTipoHabitacion ? colorPrimario : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _btnActiveTipoHabitacion ? 2 : 0,
                      ),
                      child: Text(
                        t('continuar'),
                        style: TextStyle(
                          color: _btnActiveTipoHabitacion ? Colors.white : Colors.grey.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDeleteDialog(BuildContext context, int index) {
    _TipoHabitacionController.text = TipoHabitacionList[index].TipoHabitacionTabla;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: colorPrimario),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  t('modificar_eliminar'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto para modificar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _TipoHabitacionController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {
                      _btnActiveTipoHabitacion = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: t('habitacion'),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(Icons.meeting_room, size: 20, color: colorPrimario),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colorPrimario, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Botón MODIFICAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_TipoHabitacionController.text.isNotEmpty) {
                      if (await DBPostgres().DBModificarTipoHabitacion(
                            TipoHabitacionList[index].CodTipoHabitacion,
                            _TipoHabitacionController.text,
                          ) ==
                          true) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          await getTipoHabitacion();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t('modificado')),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    } else {
                      _showErrorDialog(t('rellene_campo'));
                    }
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    t('modificar'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimario,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Botón ELIMINAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var Dbdata = await DBPostgres().DBEliminarTipoHabitacion(
                      TipoHabitacionList[index].CodTipoHabitacion,
                    );
                    if (Dbdata == 'Correcto') {
                      if (context.mounted) {
                        Navigator.pop(context);
                        await getTipoHabitacion();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t('eliminado')),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(context);
                      _showErrorDialog(t('no_eliminar'));
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    t('eliminar'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
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
        );
      },
    );
  }

  Future<void> ContinuaButton(BuildContext dialogContext) async {
    if (_btnActiveTipoHabitacion == true) {
      var newtipohabitacionOk = await DBPostgres().DBNewTipoHabitacion(
        _TipoHabitacionController.text,
      );
      if (newtipohabitacionOk == true) {
        if (context.mounted) {
          Navigator.of(dialogContext).pop();
          await getTipoHabitacion();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('aniadido')),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else if (newtipohabitacionOk.toString().contains('Ya existe la llave')) {
        _showErrorDialog(t('ya_existe'));
      }
    } else {
      _showErrorDialog(t('rellene_campo'));
    }
  }
}

class TipodeHabitacion {
  final int CodTipoHabitacion;
  final String TipoHabitacionTabla;

  TipodeHabitacion(this.CodTipoHabitacion, this.TipoHabitacionTabla);
}