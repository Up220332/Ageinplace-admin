/// ****************************************************************************
/// Funcion que devuelve los wearables inactivos y permite reactivarlos
///*****************************************************************************
library;

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../SuperAdmin/screen_TodoWearables.dart';
import '../base_de_datos/postgres.dart';

class TodoWearablesInactScreen extends StatefulWidget {
  const TodoWearablesInactScreen({super.key});

  @override
  State<TodoWearablesInactScreen> createState() =>
      _TodoWearablesInactScreenState();
}

class _TodoWearablesInactScreenState extends State<TodoWearablesInactScreen> {
  List<Wearables> WearableList = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Wearables Inactivos',
      'no_hay': 'No hay wearables inactivos',
      'descripcion': 'Los wearables desactivados aparecerán aquí',
      'inactivo': 'Inactivo',
      'fecha_baja': 'Baja',
      'reactivar_titulo': '¿Reactivar wearable?',
      'reactivar_confirmacion': '¿Está seguro que desea reactivar el wearable {id}?',
      'cancelar': 'Cancelar',
      'reactivar': 'Reactivar',
      'error': 'Error',
      'error_reactivar': 'Error al reactivar el wearable',
      'aceptar': 'Aceptar',
    },
    'en': {
      'titulo': 'Inactive Wearables',
      'no_hay': 'No inactive wearables',
      'descripcion': 'Deactivated wearables will appear here',
      'inactivo': 'Inactive',
      'fecha_baja': 'Deactivation date',
      'reactivar_titulo': 'Reactivate wearable?',
      'reactivar_confirmacion': 'Are you sure you want to reactivate the wearable {id}?',
      'cancelar': 'Cancel',
      'reactivar': 'Reactivate',
      'error': 'Error',
      'error_reactivar': 'Error reactivating wearable',
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
    var Dbdata = await DBPostgres().DBGetTodoWarable('not null');
    setState(() {
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
            child: WearableList.isEmpty
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
                          t('descripcion'),
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: WearableList.length,
                    itemBuilder: (context, index) {
                      return _buildWearableCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildWearableCard(BuildContext context, int index) {
    final wearable = WearableList[index];
    
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
              // Icono del wearable (en rojo para inactivos)
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
                    Text(
                      (getTranslatedWearableType(wearable.TipoWeareable)) +
                          wearable.DesOtros,
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
                  if (wearable.FechaBajaWearable != null)
                    Text(
                      '${t('fecha_baja')}: ${formatDate(wearable.FechaBajaWearable!, [dd, '/', mm, '/', yyyy])}',
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
          t('reactivar_confirmacion', params: {'id': WearableList[index].IdWearable}),
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
              var Dbdata = await DBPostgres().DBActDesActWearableSinPaciente(
                WearableList[index].CodWearable,
                null,
              );
              if (Dbdata == 'Correcto') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoWearablesScreen(),
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

class Wearables {
  final int CodWearable;
  final String IdWearable;
  final String DesOtros;
  final int? CodTipoWearable;
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