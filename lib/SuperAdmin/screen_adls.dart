import 'dart:core';

import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../base_de_datos/postgres.dart';

class ADLsScreen extends StatefulWidget {
  const ADLsScreen({super.key});

  @override
  _ADLsScreenState createState() => _ADLsScreenState();
}

class _ADLsScreenState extends State<ADLsScreen> {
  late var selectedAlarma;
  late int selectedCodAlarma;
  final bool _btnActiveRadioPuntoProhibido = false;
  List<AlarmaParametros> filteredParametros = [];
  List<Map<String, dynamic>> listaParametros = [];
  bool showParametrosDropdown = false;

  late double selectedLatitude;
  late double selectedLongitude;
  final double _radioEnMetros = 0;
  List<String> parametros = [];
  late int codAlarmaParametro = 0;
  late int codAlarmaParametroLatitud = 0;
  late int codAlarmaParametroLongitud = 0;
  List<AlarmaParametros> ADLParametrosList = [];
  List<AlarmaParametros> ParametrosList = [];
  List<Alarmas> ADLList = [];
  List<AlarmasPaciente> AlarmasPacienteList = [];
  List<AlarmasParametrosValor> AlarmasPacienteParametroList = [];
  List<AlarmasParametrosValor> ParametrosValorList = [];
  Map<String, String> ADLTranslations = {
    'DORMIR': 'SLEEP',
    'DESAYUNAR': 'BREAKFAST',
    'COMER': 'LUNCH',
    'CENAR': 'DINNER',
    'OCIO': 'LEISURE',
    'ASEO': 'TOILETING',
  };
  final TextEditingController _durationController = TextEditingController();
  final _mapController = MapController();

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetADLsParametros();
    setState(() {
      for (var p in Dbdata[0]) {
        ADLParametrosList.add(
          AlarmaParametros(
            p[0],
            p[1],
            p[2],
            p[3],
            p[4],
            p[5],
            p[6],
            p[7],
            p[8],
          ),
        );
      }
      for (var p in Dbdata[1]) {
        ADLList.add(Alarmas(p[0], p[1], p[2], p[3]));
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tipo de Habitaciones',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      endDrawer: NavBarSuperAdmin(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
            ),
            height: MediaQuery.of(context).size.height * 0.9,
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 40, 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: ListView.builder(
                  itemCount: ADLList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        mostrarModificarDuracionADL(context, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 6.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (ADLTranslations[ADLList[index].Alarma] ??
                                      ADLList[index].Alarma),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mostrarModificarDuracionADL(BuildContext context, int index) {
    // Controlador para la observación (si solo necesitas modificar la observación)
    final TextEditingController observacionesController =
        TextEditingController();
    observacionesController.text =
        ADLList[index].ObservacionesAlarma; // Asignar el valor actual
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Editar el tiempo mínimo que debe considerarse como inicio de actividad',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Modificar mínimo ${ADLTranslations[ADLList[index].Alarma] ?? ADLList[index].Alarma} time:',
              ),
              TextFormField(
                controller: observacionesController,
                decoration: InputDecoration(labelText: 'Tiempo mínimo'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF0716BB)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Guardar',
                style: TextStyle(color: Color(0xFF0716BB)),
              ),
              onPressed: () async {
                // Obtener el nuevo valor de las observaciones
                String nuevasObservaciones = observacionesController.text;

                // Llamar a la función que actualiza en la base de datos
                bool success1 = await DBPostgres().DBUpdateObservaciones(
                  ADLList[index]
                      .Alarma, // Utilizar el identificador de la alarma
                  nuevasObservaciones,
                );
                // Comprobar si la actualización fue exitosa
                if (success1) {
                  setState(() {
                    ADLList[index].ObservacionesAlarma =
                        nuevasObservaciones; // Actualizar el estado local
                  });
                  Navigator.of(context).pop(); // Cerrar el diálogo
                } else {
                  // Manejar el error si la actualización falló
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Error',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Text(
                          'No ha sido posible actualizar el tiempo mínimo',
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Color(0xFF0716BB)),
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
                bool success2 = await DBPostgres().actualizarDuracion(
                  ADLList[index]
                      .Alarma, // Utilizar el identificador de la alarma
                  nuevasObservaciones,
                );
                if (success2) {
                  setState(() {
                    ADLList[index].ObservacionesAlarma =
                        nuevasObservaciones; // Actualizar el estado local
                  });
                  Navigator.of(context).pop(); // Cerrar el diálogo
                } else {
                  // Manejar el error si la actualización falló
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Error',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Text(
                          'No se pudo actualizar las observaciones.',
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Aceptar',
                              style: TextStyle(color: Color(0xFF0716BB)),
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
              },
            ),
          ],
        );
      },
    );
  }
}

class Alarmas {
  final int CodAlarma;
  final String Alarma;
  final String Descripcion;
  String ObservacionesAlarma;

  Alarmas(this.CodAlarma, this.Alarma, this.Descripcion, this.ObservacionesAlarma);
}

class AlarmaParametros {
  final int CodAlarmaParametro;
  final String Parametro;
  final String TipoParametro;
  final int CodAlarma;
  final int? Valor;
  final String? Unidades;
  final int? ValorMax;
  final int? ValorMin;
  final String? ObservacionesParametro;

  AlarmaParametros(
    this.CodAlarmaParametro,
    this.Parametro,
    this.TipoParametro,
    this.CodAlarma,
    this.Valor,
    this.Unidades,
    this.ValorMax,
    this.ValorMin,
    this.ObservacionesParametro,
  );
}

class AlarmasPaciente {
  final int CodAlarmaPaciente;
  final int CodAlarma;
  final int CodPaciente;
  final String Fecha;

  AlarmasPaciente(
    this.CodAlarmaPaciente,
    this.CodAlarma,
    this.CodPaciente,
    this.Fecha,
  );
}

class AlarmasParametrosValor {
  final int CodAlarmaParametroValor;
  final int CodAlarmaParametro;
  final int CodAlarmaPaciente;
  final String Valor;

  AlarmasParametrosValor(
    this.CodAlarmaParametroValor,
    this.CodAlarmaParametro,
    this.CodAlarmaPaciente,
    this.Valor,
  );
}