/// *****************************************************************************
/// Funcion que devuelve los tipos de wearables que existen y permite crear nuevos
/// tipos o modificarlos
///****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class TipoWearableScreen extends StatefulWidget {
  const TipoWearableScreen({super.key});

  @override
  State<TipoWearableScreen> createState() => _TipoWearableScreen();
}

class _TipoWearableScreen extends State<TipoWearableScreen> {
  List<TipoWearable> TipoWearableList = [];
  final List<String> _TipoEmisorReceptorList = ["Emisor", "Receptor"];
  final TextEditingController _TipoWearableController = TextEditingController();

  Map<String, String> translationsTipoEmisorReceptor = {
    "Emisor": "Emitter",
    "Receptor": "Receiver",
    "Emisor-Receptor": "Emitter-Receiver",
  };

  bool _btnActiveTipoWearable = false;
  late int CodTipoWearable = 1;
  late String _currentLocale;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Tipos de Wearables',
      'aniadir': 'Añadir tipo de wearable',
      'modificar_eliminar': 'Modificar tipo de wearable o eliminarlo',
      'wearable': 'Tipo de wearable',
      'campo_vacio': 'El campo no puede estar vacío',
      'continuar': 'Continuar',
      'modificar': 'Modificar',
      'eliminar': 'Eliminar',
      'error': 'Error',
      'rellene_campo': 'Por favor, rellene el campo',
      'ok': 'OK',
      'no_eliminar': 'No se puede eliminar el tipo de wearable porque está en uso',
      'ya_existe': 'Ya existe el tipo de wearable',
      'aceptar': 'Aceptar',
      'cancelar': 'Cancelar',
      'no_hay': 'No hay tipos de wearable',
      'modificado': 'Tipo de wearable modificado correctamente',
      'eliminado': 'Tipo de wearable eliminado correctamente',
      'aniadido': 'Tipo de wearable añadido correctamente',
    },
    'en': {
      'titulo': 'Wearable Types',
      'aniadir': 'Add wearable type',
      'modificar_eliminar': 'Modify or delete wearable type',
      'wearable': 'Wearable type',
      'campo_vacio': 'The field cannot be empty',
      'continuar': 'Continue',
      'modificar': 'Modify',
      'eliminar': 'Delete',
      'error': 'Error',
      'rellene_campo': 'Please fill in the field',
      'ok': 'OK',
      'no_eliminar': 'The wearable type cannot be deleted because it is in use',
      'ya_existe': 'The wearable type already exists',
      'aceptar': 'Accept',
      'cancelar': 'Cancel',
      'no_hay': 'No wearable types',
      'modificado': 'Wearable type modified successfully',
      'eliminado': 'Wearable type deleted successfully',
      'aniadido': 'Wearable type added successfully',
    }
  };

  Map<String, String> wearableTypeTranslations = {
    'Banda': 'Band',
    'Colgante': 'Pendant',
    'Llavero': 'Keychain',
    'Reloj': 'Watch',
    'Textil': 'Textile',
    'Otros': 'Others',
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Función para obtener el nombre traducido del tipo de wearable
  String getTranslatedWearableType(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return wearableTypeTranslations[original] ?? original;
    }
    return original;
  }

  Future<String> getTipoWearable() async {
    var Dbdata = await DBPostgres().DBGetTipoWearable();
    setState(() {
      TipoWearableList.clear();
      for (var p in Dbdata) {
        TipoWearableList.add(TipoWearable(p[0], p[1]));
      }
    });
    TipoWearableList = TipoWearableList.where(
      (tipoWearable) => tipoWearable.TipoWearableTabla != "Otros",
    ).toList();
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    _currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    getTipoWearable();
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
            _showAddTipoWearableDialog();
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
          child: TipoWearableList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.watch_outlined, size: 80, color: Colors.grey.shade400),
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
                    itemCount: TipoWearableList.length,
                    itemBuilder: (context, index) {
                      return _buildTipoWearableCard(context, index);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTipoWearableCard(BuildContext context, int index) {
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
                // Icono de tipo de wearable
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
                      Icons.watch,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nombre del tipo de wearable
                Expanded(
                  child: Text(
                    getTranslatedWearableType(TipoWearableList[index].TipoWearableTabla),
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

  void _showAddTipoWearableDialog() {
    _TipoWearableController.clear();
    
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
                      controller: _TipoWearableController,
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
                          _btnActiveTipoWearable = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('wearable'),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(Icons.watch, size: 20, color: colorPrimario),
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
                      onPressed: _btnActiveTipoWearable ? () => ContinuaButton(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnActiveTipoWearable ? colorPrimario : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _btnActiveTipoWearable ? 2 : 0,
                      ),
                      child: Text(
                        t('continuar'),
                        style: TextStyle(
                          color: _btnActiveTipoWearable ? Colors.white : Colors.grey.shade500,
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
    _TipoWearableController.text = TipoWearableList[index].TipoWearableTabla;
    
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
                  controller: _TipoWearableController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {
                      _btnActiveTipoWearable = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: t('wearable'),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(Icons.watch, size: 20, color: colorPrimario),
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
                    if (_TipoWearableController.text.isNotEmpty) {
                      if (await DBPostgres().DBModificarTipoWearable(
                            TipoWearableList[index].CodTipoWearable,
                            _TipoWearableController.text,
                          ) ==
                          true) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          await getTipoWearable();
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
                    var Dbdata = await DBPostgres().DBEliminarTipoWearable(
                      TipoWearableList[index].CodTipoWearable,
                    );
                    if (Dbdata == 'Correcto') {
                      if (context.mounted) {
                        Navigator.pop(context);
                        await getTipoWearable();
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
    if (_btnActiveTipoWearable == true) {
      var newtipowearableOk = await DBPostgres().DBNewTipoWearable(
        _TipoWearableController.text,
      );
      if (newtipowearableOk == true) {
        if (context.mounted) {
          Navigator.of(dialogContext).pop();
          await getTipoWearable();
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
      } else if (newtipowearableOk.toString().contains('Ya existe la llave')) {
        _showErrorDialog(t('ya_existe'));
      }
    } else {
      _showErrorDialog(t('rellene_campo'));
    }
  }
}

class TipoWearable {
  final int CodTipoWearable;
  final String TipoWearableTabla;

  TipoWearable(this.CodTipoWearable, this.TipoWearableTabla);
}