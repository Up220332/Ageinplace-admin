/// *****************************************************************************
/// Funcion que devuelve los tipos de cuidador que existen y permite crear nuevos
/// tipos o modificarlos
///****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

class TipoCuidadorScreen extends StatefulWidget {
  const TipoCuidadorScreen({super.key});

  @override
  State<TipoCuidadorScreen> createState() => _TipoCuidadorScreen();
}

class _TipoCuidadorScreen extends State<TipoCuidadorScreen> {
  List<TipodeCuidador> TipoCuidadorList = [];
  final TextEditingController _TipoCuidadorController = TextEditingController();
  final TextEditingController _TipoCuidadorListController = TextEditingController();

  final List<String> _TipoCuidadorList = [
    "Cuidador Formal",
    "Cuidador Informal",
  ];

  late String _currentLocale;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Tipo de Cuidadores',
      'aniadir': 'Añadir tipo de cuidador',
      'modificar_eliminar': 'Modificar tipo de cuidador o eliminarlo',
      'tipo_cuidador': 'Tipo de cuidador',
      'campo_vacio': 'El campo no puede estar vacío',
      'continuar': 'Continuar',
      'modificar': 'Modificar',
      'eliminar': 'Eliminar',
      'error': 'Error',
      'rellene_campo': 'Por favor, rellene el campo',
      'ok': 'OK',
      'no_eliminar': 'No se puede eliminar el tipo de cuidador porque está en uso',
      'ya_existe': 'Ya existe el tipo de cuidador',
      'aceptar': 'Aceptar',
      'cancelar': 'Cancelar',
      'no_hay': 'No hay tipos de cuidador',
      'modificado': 'Tipo de cuidador modificado correctamente',
      'eliminado': 'Tipo de cuidador eliminado correctamente',
      'aniadido': 'Tipo de cuidador añadido correctamente',
      'selecciona_tipo': 'Selecciona un tipo',
    },
    'en': {
      'titulo': 'Caregiver Types',
      'aniadir': 'Add caregiver type',
      'modificar_eliminar': 'Modify or delete caregiver type',
      'tipo_cuidador': 'Caregiver type',
      'campo_vacio': 'The field cannot be empty',
      'continuar': 'Continue',
      'modificar': 'Modify',
      'eliminar': 'Delete',
      'error': 'Error',
      'rellene_campo': 'Please fill in the field',
      'ok': 'OK',
      'no_eliminar': 'The caregiver type cannot be deleted because it is in use',
      'ya_existe': 'The caregiver type already exists',
      'aceptar': 'Accept',
      'cancelar': 'Cancel',
      'no_hay': 'No caregiver types',
      'modificado': 'Caregiver type modified successfully',
      'eliminado': 'Caregiver type deleted successfully',
      'aniadido': 'Caregiver type added successfully',
      'selecciona_tipo': 'Select a type',
    }
  };

  Map<String, String> translationsFormalInformal = {
    "Cuidador Formal": "Formal Caregiver",
    "Cuidador Informal": "Informal Caregiver",
  };

  Map<String, String> translationsTipoCuidador = {
    "Cuidador Formal": "Formal Caregiver",
    "Responsable Sanitario": "Healthcare Professional",
    "Cónyugue (Cuidador Informal)": "Spouse (Informal Caregiver)",
    "Hermano/a (Cuidador Informal)": "Brother/Sister (Informal Caregiver)",
    "Hijo/a (Cuidador Informal)": "Son/Daughter (Informal Caregiver)",
    "Madre (Cuidador Informal)": "Mother (Informal Caregiver)",
    "Padre (Cuidador Informal)": "Father (Informal Caregiver)",
    "Otros": "Others",
  };

  bool _btnActiveTipoCuidador = false;
  late int CodTipoCuidador = 1;

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  // Función para obtener el nombre traducido del tipo de cuidador
  String getTranslatedTipoCuidador(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsTipoCuidador[original] ?? original;
    }
    return original;
  }

  Future<String> getTipoCuidador() async {
    var Dbdata = await DBPostgres().DBGetTipoCuidador();
    setState(() {
      TipoCuidadorList.clear();
      for (var p in Dbdata) {
        TipoCuidadorList.add(TipodeCuidador(p[0], p[1]));
      }
    });
    TipoCuidadorList = TipoCuidadorList.where(
      (tipoCuidador) => tipoCuidador.TipoCuidadorTabla != "Otros",
    ).toList();
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    _currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    getTipoCuidador();
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
            _showAddTipoCuidadorDialog();
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
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
          child: TipoCuidadorList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, size: 80, color: Colors.grey.shade400),
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
                    itemCount: TipoCuidadorList.length,
                    itemBuilder: (context, index) {
                      return _buildTipoCuidadorCard(context, index);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTipoCuidadorCard(BuildContext context, int index) {
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
                // Icono de tipo de cuidador
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
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nombre del tipo de cuidador
                Expanded(
                  child: Text(
                    getTranslatedTipoCuidador(TipoCuidadorList[index].TipoCuidadorTabla),
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

  void _showAddTipoCuidadorDialog() {
    _TipoCuidadorController.clear();
    _TipoCuidadorListController.clear();
    
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
                      controller: _TipoCuidadorController,
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
                          _btnActiveTipoCuidador = value.isNotEmpty && 
                              _TipoCuidadorListController.text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('tipo_cuidador'),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(Icons.person_outline, size: 20, color: colorPrimario),
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
                  const SizedBox(height: 12),
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
                    child: DropdownButtonFormField<String>(
                      items: _TipoCuidadorList.map(
                        (TipoCuidadorList) => DropdownMenuItem(
                          value: TipoCuidadorList,
                          child: Text(
                            getTranslatedTipoCuidador(TipoCuidadorList),
                          ),
                        ),
                      ).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          _TipoCuidadorListController.text = ' (${newValue!})';
                          _btnActiveTipoCuidador = _TipoCuidadorController.text.isNotEmpty && 
                              _TipoCuidadorListController.text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: t('selecciona_tipo'),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: Icon(Icons.category_outlined, size: 20, color: colorPrimario),
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
                      onPressed: _btnActiveTipoCuidador ? () => ContinuaButton(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnActiveTipoCuidador ? colorPrimario : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _btnActiveTipoCuidador ? 2 : 0,
                      ),
                      child: Text(
                        t('continuar'),
                        style: TextStyle(
                          color: _btnActiveTipoCuidador ? Colors.white : Colors.grey.shade500,
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
    _TipoCuidadorController.text = TipoCuidadorList[index].TipoCuidadorTabla;
    
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
                  controller: _TipoCuidadorController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {
                      _btnActiveTipoCuidador = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: t('tipo_cuidador'),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(Icons.person_outline, size: 20, color: colorPrimario),
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
                    if (_TipoCuidadorController.text.isNotEmpty) {
                      if (await DBPostgres().DBModificarTipoCuidador(
                            TipoCuidadorList[index].CodTipoCuidador,
                            _TipoCuidadorController.text,
                          ) ==
                          true) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          await getTipoCuidador();
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
                    var Dbdata = await DBPostgres().DBEliminarTipoCuidador(
                      TipoCuidadorList[index].CodTipoCuidador,
                    );
                    if (Dbdata == 'Correcto') {
                      if (context.mounted) {
                        Navigator.pop(context);
                        await getTipoCuidador();
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
    if (_btnActiveTipoCuidador == true) {
      var newtipocuidadorOk = await DBPostgres().DBNewTipoCuidador(
        _TipoCuidadorController.text + _TipoCuidadorListController.text,
      );
      if (newtipocuidadorOk == true) {
        if (context.mounted) {
          Navigator.of(dialogContext).pop();
          await getTipoCuidador();
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
      } else if (newtipocuidadorOk.toString().contains('Ya existe la llave')) {
        _showErrorDialog(t('ya_existe'));
      }
    } else {
      _showErrorDialog(t('rellene_campo'));
    }
  }
}

class TipodeCuidador {
  final int CodTipoCuidador;
  final String TipoCuidadorTabla;

  TipodeCuidador(this.CodTipoCuidador, this.TipoCuidadorTabla);
}