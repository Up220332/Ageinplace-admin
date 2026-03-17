/// *****************************************************************************
/// Funcion que muestra todas las viviendas inactivas
///****************************************************************************
library;

import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../base_de_datos/postgres.dart';

class ViviendasInactScreen extends StatefulWidget {
  const ViviendasInactScreen({super.key});

  @override
  State<ViviendasInactScreen> createState() => _ViviendasInactScreenSate();
}

class _ViviendasInactScreenSate extends State<ViviendasInactScreen> {
  List<Vivienda> ViviendaList = [];

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

  String translateCountryInAddress(
    String address,
    Map<String, String> translationsPais,
  ) {
    for (String country in translationsPais.keys) {
      if (address.contains(country)) {
        return address.replaceAll(
          country,
          translationsPais[country] ?? country,
        );
      }
    }
    return address; // Devuelve la dirección sin cambios si no se encuentra el país
  }

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetVivienda('not null');
    String Estado;
    setState(() {
      for (var p in Dbdata) {
        if (p[11] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        ViviendaList.add(
          Vivienda(
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
            Estado,
          ),
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
    ViviendaList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));
    return Scaffold(
      floatingActionButton: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Viviendas Inactivas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
              padding: const EdgeInsets.fromLTRB(30, 15, 40, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: ListView.builder(
                  itemCount: ViviendaList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('¿Desea activar la vivienda?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                var Dbdata = await DBPostgres()
                                    .DBActDesActVivienda(
                                      ViviendaList[index].CodCasa,
                                      null,
                                      'CURRENT_TIMESTAMP',
                                      'CURRENT_TIMESTAMP',
                                      'CURRENT_TIMESTAMP',
                                      'CURRENT_TIMESTAMP',
                                      'CURRENT_TIMESTAMP',
                                    );
                                if (Dbdata == 'Correcto') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViviendasScreen(
                                        tipoUsuario: 'superadmin',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'Algo salió mal al activar la vivienda',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Color(0xFF0716BB),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Color(0xFF0716BB)),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Color(0xFF0716BB)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 6.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  translateCountryInAddress(
                                    ViviendaList[index].Direccion,
                                    translationsPais,
                                  ),
                                  // ViviendaList[index].Direccion,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${ViviendaList[index].Localidad}, ${ViviendaList[index].Provincia}, ${translationsPais[ViviendaList[index].Pais] ?? ViviendaList[index].Pais}',
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  formatDate(ViviendaList[index].F_ALTA, [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                  ]),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
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
}

class Vivienda {
  final int CodCasa;
  final String Direccion;
  final String Numero;
  final String Piso;
  final String Puerta;
  final String CodPostal;
  final String Localidad;
  final String Provincia;
  final String Pais;
  final int NumPlantas;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Estado;

  Vivienda(
    this.CodCasa,
    this.Direccion,
    this.Numero,
    this.Piso,
    this.Puerta,
    this.CodPostal,
    this.Localidad,
    this.Provincia,
    this.Pais,
    this.NumPlantas,
    this.F_ALTA,
    this.F_BAJA,
    this.Estado,
  );
}
