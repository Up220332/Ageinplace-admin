/// *****************************************************************************
/// Funcion que muestra todas las viviendas inactivas con diseño profesional
///****************************************************************************
library;

import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

class ViviendasInactScreen extends StatefulWidget {
  const ViviendasInactScreen({super.key});

  @override
  State<ViviendasInactScreen> createState() => _ViviendasInactScreenSate();
}

class _ViviendasInactScreenSate extends State<ViviendasInactScreen> {
  List<Vivienda> ViviendaList = [];
  bool isLoading = true;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  Future<void> getData() async {
    setState(() => isLoading = true);
    var Dbdata = await DBPostgres().DBGetVivienda('not null');
    
    setState(() {
      ViviendaList.clear();
      for (var p in Dbdata) {
        ViviendaList.add(
          Vivienda(
            p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], 'Inactivo',
          ),
        );
      }
      isLoading = false;
    });
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
      appBar: AppBar(
        backgroundColor: colorPrimario,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LocaleData.viviendasInactivas.getString(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: colorPrimario))
              : ViviendaList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: ViviendaList.length,
                      itemBuilder: (context, index) => _buildInactiveCard(context, index),
                    ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.house_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            LocaleData.viviendasNoHay.getString(context),
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveCard(BuildContext context, int index) {
    final vivienda = ViviendaList[index];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showActivateDialog(context, index),
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.withOpacity(0.7), Colors.red.shade800],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Icon(Icons.house_rounded, color: Colors.white, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vivienda.Direccion,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2B3C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${vivienda.Localidad}, ${vivienda.Provincia}',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                      LocaleData.viviendasInactivo.getString(context),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(vivienda.F_ALTA, [dd, '/', mm, '/', yyyy]),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green.shade600),
            const SizedBox(width: 10),
            Text(LocaleData.viviendasActivar.getString(context)),
          ],
        ),
        content: Text("${LocaleData.viviendasSeguroActivar.getString(context)} ${ViviendaList[index].Direccion}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.viviendasCancelar.getString(context),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              var Dbdata = await DBPostgres().DBActDesActVivienda(
                ViviendaList[index].CodCasa,
                null,
                'CURRENT_TIMESTAMP', 'CURRENT_TIMESTAMP', 'CURRENT_TIMESTAMP',
                'CURRENT_TIMESTAMP', 'CURRENT_TIMESTAMP',
              );
              if (Dbdata == 'Correcto') {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViviendasScreen(tipoUsuario: 'superadmin'),
                    ),
                  );
                }
              } else {
                if (mounted) Navigator.pop(context);
                _showErrorSnackBar();
              }
            },
            child: Text(
              LocaleData.viviendasConfirmarActivar.getString(context), 
              style: const TextStyle(color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleData.viviendasError.getString(context)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
  final int? NumPlantas;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Estado;

  Vivienda(this.CodCasa, this.Direccion, this.Numero, this.Piso, this.Puerta, this.CodPostal, this.Localidad, this.Provincia, this.Pais, this.NumPlantas, this.F_ALTA, this.F_BAJA, this.Estado);
}