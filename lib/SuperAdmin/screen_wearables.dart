import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../SuperAdmin/screen_PacientesVivienda.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

/// ****************************************************************************
/// Funcion que devueleve los wearables de un paciente y permite añadir nuevos
/// wearables
///*****************************************************************************
class WearablesScreen extends StatefulWidget {
  final String role;
  late Paciente paciente;
  late Vivienda vivienda;

  WearablesScreen({
    super.key,
    required this.paciente,
    required this.vivienda,
    required this.role,
  });

  @override
  State<WearablesScreen> createState() => _WearablesScreenSate();
}

class _WearablesScreenSate extends State<WearablesScreen> {
  List<Wearable> WearableList = [];
  List<Wearable> WearableDispList = [];
  List<TipoWearable> TipoWearableList = [];

  final TextEditingController _DesOtrosTipoWearableController =
      TextEditingController();
  final TextEditingController _EmisorReceptorController =
      TextEditingController();
  final TextEditingController _IdWearableNuevoController =
      TextEditingController();
  final TextEditingController _IdWearableExistenteController =
      TextEditingController();
  final TextEditingController _idWearableController = TextEditingController();

  bool _btnActiveIdWearableNuevo = false;
  bool _btnActiveIdWearableExistente = false;
  bool _btnActiveTipoWearable = false;
  late int CodTipoWearable = 1;
  late int CodWearable = 1;
  late int CodPacienteWearableExist = 1;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  Wearable noneWearable = Wearable(
    0,
    "Ninguno",
    0,
    "",
    "",
    DateTime.now(),
    null,
    "none",
    0,
    "none",
  );

  Future<String> getData() async {
    String Estado;
    var Dbdata = await DBPostgres().DBGetWearable(
      widget.paciente.CodUsuario,
      'ACTIVO',
    );
    setState(() {
      for (var p in Dbdata) {
        if (p[5] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        WearableList.add(
          Wearable(
            p[0],
            p[1],
            p[2],
            p[3],
            p[4],
            p[5],
            p[6],
            p[7],
            p[8],
            Estado,
          ),
        );
      }
    });
    return 'Successfully Fetched data';
  }

  /*****************************************************************************
      Funcion que devuelve todos los Wearable disponibles, en caso de que haya dos
      Weables con el mismo id, se muestra el que ya ha estado asignado al paciente
   *****************************************************************************/

  Future<String> getWearableDisp() async {
    var Dbdata = await DBPostgres().DBGetWearablesDisp();
    String Estado;
    List<Wearable> wearableList = [];
    Map<String, Wearable> uniqueWearablesMap = {};

    for (var p in Dbdata) {
      if (p[5] == null) {
        Estado = 'Activo';
      } else {
        Estado = 'Inactivo';
      }
      print(Estado);
      wearableList.add(
        Wearable(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], Estado),
      );
    }
    for (Wearable wearable in wearableList) {
      if (!uniqueWearablesMap.containsKey(wearable.IdWearable)) {
        uniqueWearablesMap[wearable.IdWearable] = wearable;
      } else if (wearable.CodUsuario == widget.paciente.CodUsuario) {
        uniqueWearablesMap[wearable.IdWearable] = wearable;
      }
    }

    WearableDispList = uniqueWearablesMap.values.toList();
    WearableDispList.add(noneWearable);

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
    getWearableDisp();
    getTipoWearable();
  }

  Map<String, String> wearableTypeTranslations = {
    'Banda': 'Band',
    'Colgante': 'Pendant',
    'Llavero': 'Keychain',
    'Reloj': 'Watch',
    'Textil': 'Textile',
    'Otros': 'Others',
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => PacienteScreen(
                  paciente: widget.paciente,
                  vivienda: widget.vivienda,
                  role: widget.role,
                ),
          ),
        );
        return false;
      },
      child: Scaffold(
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
          title: Text(
            LocaleData.wearablesTitulo.getString(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
            child: WearableList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.watch_off_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.wearablesNoHay.getString(context),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.wearablesAnade.getString(context),
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () {
          getWearableDisp();
          _showAddWearableDialog(context);
        },
        label: Text(
          LocaleData.wearablesAnadir.getString(context),
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

  Widget _buildWearableCard(BuildContext context, int index) {
    final wearable = WearableList[index];
    
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
                        (wearableTypeTranslations[wearable.TipoWeareable] ??
                                wearable.TipoWeareable) +
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
                _showEditWearableDialog(context, index);
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
                    Text(LocaleData.wearablesModificar.getString(context)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'deactivate',
                child: Row(
                  children: [
                    const Icon(Icons.block, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(LocaleData.wearablesDesactivar.getString(context)),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_circle, color: colorPrimario, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      LocaleData.wearablesAnadirTitulo.getString(context),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                Text(
                  LocaleData.wearablesExistente.getString(context),
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
                  child: DropdownButtonFormField(
                    items: WearableDispList.map((wearable) => DropdownMenuItem(
                      value: wearable,
                      child: Text(wearable.IdWearable),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _btnActiveIdWearableExistente = true;
                          CodWearable = value.CodWearable;
                          _IdWearableExistenteController.text = value.IdWearable;
                          CodPacienteWearableExist = value.CodUsuario!;
                          if (value.IdWearable == "Ninguno") {
                            _btnActiveIdWearableExistente = false;
                          }
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: LocaleData.wearablesSeleccionar.getString(context),
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  LocaleData.wearablesONuevo.getString(context),
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
                    controller: _IdWearableNuevoController,
                    decoration: InputDecoration(
                      labelText: LocaleData.wearablesId.getString(context),
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
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
                  child: DropdownButtonFormField(
                    items: TipoWearableList.map((tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(
                        wearableTypeTranslations[tipo.TipoWearableTabla] ??
                            tipo.TipoWearableTabla,
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
                      labelText: LocaleData.wearablesTipo.getString(context),
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
                    onPressed: () => _handleAddWearable(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimario,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      LocaleData.wearablesContinuar.getString(context),
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
        );
      },
    );
  }

  void _showEditWearableDialog(BuildContext context, int index) {
    _idWearableController.text = WearableList[index].IdWearable;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, color: colorPrimario, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      LocaleData.wearablesModificarTitulo.getString(context),
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
                      labelText: LocaleData.wearablesId.getString(context),
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  child: DropdownButtonFormField(
                    value: TipoWearableList.firstWhere(
                      (tipoSensor) => tipoSensor.CodTipoWearable ==
                          WearableList[index].CodTipoWearable,
                    ),
                    items: TipoWearableList.map((tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(
                        wearableTypeTranslations[tipo.TipoWearableTabla] ??
                            tipo.TipoWearableTabla,
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
                      labelText: LocaleData.wearablesTipo.getString(context),
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
                      if (_idWearableController.text.isNotEmpty) {
                        if (await DBPostgres().DBModificarWearable(
                          WearableList[index].CodWearable,
                          _idWearableController.text,
                          CodTipoWearable,
                          _DesOtrosTipoWearableController.text,
                        ) == true) {
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WearablesScreen(
                                  paciente: widget.paciente,
                                  vivienda: widget.vivienda,
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        _showErrorDialog(context, LocaleData.wearablesRellenarCampos.getString(context));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimario,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      LocaleData.wearablesGuardarCambios.getString(context),
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
            Text(LocaleData.wearablesDesactivarTitulo.getString(context)),
          ],
        ),
        content: Text(
          LocaleData.wearablesConfirmarDesactivar.getString(context).replaceAll(
            '{id}', WearableList[index].IdWearable
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.wearablesCancelar.getString(context),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var Dbdata = await DBPostgres().DBActDesactWearablePaciente(
                widget.paciente.CodUsuario,
                WearableList[index].CodWearable,
                'INACTIVO',
              );
              if (Dbdata == 'Correcto') {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WearablesScreen(
                        paciente: widget.paciente,
                        vivienda: widget.vivienda,
                        role: widget.role,
                      ),
                    ),
                  );
                }
              } else {
                Navigator.pop(context);
                _showErrorDialog(context, LocaleData.wearablesErrorDesactivar.getString(context));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(LocaleData.wearablesDesactivar.getString(context)),
          ),
        ],
      ),
    );
  }

  void _handleAddWearable(BuildContext context) {
    if (_btnActiveIdWearableExistente && _btnActiveIdWearableNuevo) {
      _showErrorDialog(context, LocaleData.wearablesSeleccionarUnaOp.getString(context));
    } else if (_btnActiveIdWearableExistente && !_btnActiveIdWearableNuevo) {
      if (CodPacienteWearableExist == widget.paciente.CodUsuario) {
        AngadirWearableExistenteButton(context);
      } else {
        AngadirWearableDispButton(context);
      }
    } else if (!_btnActiveIdWearableExistente && _btnActiveIdWearableNuevo) {
      if (_btnActiveTipoWearable) {
        AngadirWearableButton(context);
      } else {
        _showErrorDialog(context, LocaleData.wearablesSeleccionarTipo.getString(context));
      }
    } else {
      _showErrorDialog(context, LocaleData.wearablesSeleccionarOpcion.getString(context));
    }
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
            Text(LocaleData.wearablesError.getString(context)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.wearablesAceptar.getString(context),
              style: TextStyle(color: colorPrimario),
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
            Text(LocaleData.wearablesExito.getString(context)),
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
                  builder: (context) => WearablesScreen(
                    paciente: widget.paciente,
                    vivienda: widget.vivienda,
                    role: widget.role,
                  ),
                ),
              );
            },
            child: Text(
              LocaleData.wearablesAceptar.getString(context),
              style: TextStyle(color: colorPrimario),
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
              Text(LocaleData.wearablesOtros.getString(context)),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: LocaleData.wearablesEspecifiqueTipo.getString(context),
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
                LocaleData.wearablesAceptar.getString(context),
                style: TextStyle(color: colorPrimario),
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
    var newwearableOk = await DBPostgres().DBAnagdirWearable(
      _IdWearableNuevoController.text,
      widget.paciente.CodUsuario,
      CodTipoWearable,
      _DesOtrosTipoWearableController.text,
    );
    if (newwearableOk == true) {
      _showSuccessDialog(context, LocaleData.wearablesAnadido.getString(context));
    } else if (newwearableOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, LocaleData.wearablesYaExiste.getString(context));
    }
  }

  Future<void> AngadirWearableExistenteButton(BuildContext context) async {
    var newwearableOk = await DBPostgres().DBAnagdirWearableExistente(
      CodWearable,
      widget.paciente.CodUsuario,
    );
    if (newwearableOk == true) {
      _showSuccessDialog(context, LocaleData.wearablesAnadido.getString(context));
    } else if (newwearableOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, LocaleData.wearablesYaAsignado.getString(context));
    }
  }

  Future<void> AngadirWearableDispButton(BuildContext context) async {
    var newwearableOk = await DBPostgres().DBAnagdirWearableDisp(
      CodWearable,
      widget.paciente.CodUsuario,
    );
    if (newwearableOk == true) {
      _showSuccessDialog(context, LocaleData.wearablesAnadido.getString(context));
    } else if (newwearableOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, LocaleData.wearablesYaAsignado.getString(context));
    }
  }
}

class Wearable {
  final int CodWearable;
  final String IdWearable;
  final int? CodUsuario;
  final String CodPacienteWearable;
  final String TipoWeareable;
  final DateTime? F_ALTA;
  final DateTime? F_BAJA;
  final String DesOtros;
  final int CodTipoWearable;
  final String Estado;

  Wearable(
    this.CodWearable,
    this.IdWearable,
    this.CodUsuario,
    this.CodPacienteWearable,
    this.TipoWeareable,
    this.F_ALTA,
    this.F_BAJA,
    this.DesOtros,
    this.CodTipoWearable,
    this.Estado,
  );
}

class TipoWearable {
  final int CodTipoWearable;
  final String TipoWearableTabla;

  TipoWearable(this.CodTipoWearable, this.TipoWearableTabla);
}