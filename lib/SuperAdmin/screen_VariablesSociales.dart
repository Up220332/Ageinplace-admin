/// *****************************************************************************
/// Funcion que devuelve todos las variables sociales que existen
///****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class VariableSocialScreen extends StatefulWidget {
  const VariableSocialScreen({super.key});

  @override
  State<VariableSocialScreen> createState() => _VariableSocialScreen();
}

class _VariableSocialScreen extends State<VariableSocialScreen> {
  List<VariablesSociales> VariableSocialList = [];
  final TextEditingController _VariableSocialController = TextEditingController();

  bool _btnActiveVariableSocial = false;
  late int CodVariableSocial = 1;
  late String _currentLocale;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Variables Sociales',
      'aniadir': 'Añadir variable social',
      'modificar_eliminar': 'Modificar la variable social o eliminarla',
      'variable': 'Variable social',
      'campo_vacio': 'El campo no puede estar vacío',
      'continuar': 'Continuar',
      'modificar': 'Modificar',
      'eliminar': 'Eliminar',
      'error': 'Error',
      'rellene_campo': 'Por favor, rellene el campo',
      'ok': 'OK',
      'no_eliminar': 'No se puede eliminar la variable porque está en uso',
      'ya_existe': 'Ya existe la variable social',
      'aceptar': 'Aceptar',
      'cancelar': 'Cancelar',
      'no_hay': 'No hay variables sociales',
      'modificado': 'Variable modificada correctamente',
      'eliminado': 'Variable eliminada correctamente',
      'aniadido': 'Variable añadida correctamente',
    },
    'en': {
      'titulo': 'Social Variables',
      'aniadir': 'Add social variable',
      'modificar_eliminar': 'Modify or delete the social variable',
      'variable': 'Social variable',
      'campo_vacio': 'The field cannot be empty',
      'continuar': 'Continue',
      'modificar': 'Modify',
      'eliminar': 'Delete',
      'error': 'Error',
      'rellene_campo': 'Please fill in the field',
      'ok': 'OK',
      'no_eliminar': 'The variable cannot be deleted because it is in use',
      'ya_existe': 'The social variable already exists',
      'aceptar': 'Accept',
      'cancelar': 'Cancel',
      'no_hay': 'No social variables',
      'modificado': 'Variable modified successfully',
      'eliminado': 'Variable deleted successfully',
      'aniadido': 'Variable added successfully',
    }
  };

  Map<String, String> translationsVarSocial = {
    "Autónomo": "Autonomous",
    "Dependiente grave": "Severely Dependent",
    "Dependiente leve": "Mildly Dependent",
    "Riesgo aislamiento": "Isolation Risk",
    "Tensiones económicas": "Economic Tensions",
    "Con red social de apoyo": "With Social Support Network",
    "Red social apoyo reducida": "Reduced Social Support Network",
    "Sin red social de apoyo": "Without Social Support Network",
    "Otros": "Others",
    "Eduación: basica":"Education: basic studies",
    "Eduación: NO":"Education: NO",
    "Eduación: alta":"Education: high",
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Función para obtener el nombre traducido de la variable social
  String getTranslatedSocialVar(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsVarSocial[original] ?? original;
    }
    return original;
  }

  Future<String> getVariableSocial() async {
    var Dbdata = await DBPostgres().DBGetVariableSocial();
    setState(() {
      VariableSocialList.clear();
      for (var p in Dbdata) {
        VariableSocialList.add(VariablesSociales(p[0], p[1]));
      }
    });
    VariableSocialList = VariableSocialList.where(
      (variableSocial) => variableSocial.VariableSocial != "Otros",
    ).toList();
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    _currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    getVariableSocial();
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
            _showAddVariableDialog();
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
          child: VariableSocialList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
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
                    itemCount: VariableSocialList.length,
                    itemBuilder: (context, index) {
                      return _buildVariableCard(context, index);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildVariableCard(BuildContext context, int index) {
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
          onTap: () => _showEditDeleteDialog(context, index),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de variable social
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
                      Icons.people,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nombre de la variable
                Expanded(
                  child: Text(
                    getTranslatedSocialVar(VariableSocialList[index].VariableSocial),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Indicador de pulsación larga
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

  void _showAddVariableDialog() {
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
                      controller: _VariableSocialController,
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
                          _btnActiveVariableSocial = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('variable'),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(Icons.people, size: 20, color: colorPrimario),
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
                      onPressed: _btnActiveVariableSocial ? () => ContinuaButton(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnActiveVariableSocial ? colorPrimario : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _btnActiveVariableSocial ? 2 : 0,
                      ),
                      child: Text(
                        t('continuar'),
                        style: TextStyle(
                          color: _btnActiveVariableSocial ? Colors.white : Colors.grey.shade500,
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
    _VariableSocialController.text = VariableSocialList[index].VariableSocial;
    
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
                  controller: _VariableSocialController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {
                      _btnActiveVariableSocial = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: t('variable'),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(Icons.people, size: 20, color: colorPrimario),
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
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_VariableSocialController.text.isNotEmpty) {
                      if (await DBPostgres().DBModificarVariableSocial(
                            VariableSocialList[index].CodVariableSocial,
                            _VariableSocialController.text,
                          ) ==
                          true) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          await getVariableSocial();
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var Dbdata = await DBPostgres().DBEliminarVariableSocial(
                      VariableSocialList[index].CodVariableSocial,
                    );
                    if (Dbdata == 'Correcto') {
                      if (context.mounted) {
                        Navigator.pop(context);
                        await getVariableSocial();
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
    if (_btnActiveVariableSocial == true) {
      var newvariablesocialOk = await DBPostgres().DBNewVariableSocial(
        _VariableSocialController.text,
      );
      if (newvariablesocialOk == true) {
        if (context.mounted) {
          Navigator.of(dialogContext).pop();
          await getVariableSocial();
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
      } else if (newvariablesocialOk.toString().contains('Ya existe la llave')) {
        _showErrorDialog(t('ya_existe'));
      }
    } else {
      _showErrorDialog(t('rellene_campo'));
    }
  }
}

class VariablesSociales {
  final int CodVariableSocial;
  final String VariableSocial;

  VariablesSociales(this.CodVariableSocial, this.VariableSocial);
}