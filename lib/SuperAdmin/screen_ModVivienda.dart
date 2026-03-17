import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../SuperAdmin/screen_viviendas.dart';
import '../../base_de_datos/postgres.dart';
import '../localization/locales.dart';

var COD_CASA;

class ModViviendaScreen extends StatefulWidget {
  final Vivienda vivienda;

  const ModViviendaScreen({super.key, required this.vivienda});

  @override
  State<ModViviendaScreen> createState() => _ModViviendaScreenSate();
}

class _ModViviendaScreenSate extends State<ModViviendaScreen> {
  final TextEditingController _DireccionController = TextEditingController();
  final TextEditingController _NumeroController = TextEditingController();
  final TextEditingController _PisoController = TextEditingController();
  final TextEditingController _PuertaController = TextEditingController();
  final TextEditingController _CodPostalController = TextEditingController();
  final TextEditingController _LocalidadController = TextEditingController();
  final TextEditingController _ProvinciaController = TextEditingController();
  final TextEditingController _PaisController = TextEditingController();
  final TextEditingController _NumHabitantesController =
      TextEditingController();
  final TextEditingController _NumPlantasController = TextEditingController();
  final TextEditingController _NumHabitacionesController =
      TextEditingController();
  final TextEditingController _LongitudController = TextEditingController();
  final TextEditingController _LatitudController = TextEditingController();
  
  bool _btnActiveDireccion = true;
  bool _btnActiveNumero = true;
  bool _btnActivePuerta = true;
  bool _btnActivePiso = true;
  bool _btnActivePais = true;
  bool _btnActiveCodPostal = true;
  bool _btnActiveLocalidad = true;
  bool _btnActiveProvincia = true;
  bool _btnActivePlantas = true;
  bool _btnActiveLatitud = true;
  bool _btnActiveLongitud = true;
  
  final _formKey = GlobalKey<FormState>();
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  /// ****************************************************************************
  /// Función que inicia las variables de los cotroladores con los datos del vivienda
  ///***************************************************************************
  @override
  void initState() {
    super.initState();
    _DireccionController.text = widget.vivienda.Direccion;
    _NumeroController.text = widget.vivienda.Numero;
    _PisoController.text = widget.vivienda.Piso;
    _PuertaController.text = widget.vivienda.Puerta;
    _CodPostalController.text = widget.vivienda.CodPostal;
    _LocalidadController.text = widget.vivienda.Localidad;
    _ProvinciaController.text = widget.vivienda.Provincia;
    _PaisController.text = widget.vivienda.Pais;
    _NumPlantasController.text = widget.vivienda.NumPlantas.toString();
    _LatitudController.text = widget.vivienda.Latitud.toString();
    _LongitudController.text = widget.vivienda.Longitud.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorPrimario,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          LocaleData.modViviendaTitulo.getString(context),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Información de ubicación
                  _buildSectionTitle(
                    LocaleData.modViviendaUbicacion.getString(context), 
                    Icons.location_on
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _DireccionController,
                    label: LocaleData.modViviendaDireccion.getString(context),
                    icon: Icons.streetview,
                    required: true,
                    onChanged: (value) => setState(() => _btnActiveDireccion = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _btnActiveDireccion = false;
                        return LocaleData.campoObligatorio.getString(context);
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _NumeroController,
                          label: LocaleData.modViviendaNumero.getString(context),
                          icon: Icons.door_front_door,
                          required: true,
                          onChanged: (value) => setState(() => _btnActiveNumero = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveNumero = false;
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _PisoController,
                          label: LocaleData.modViviendaPiso.getString(context),
                          icon: Icons.stairs,
                          onChanged: (value) => setState(() => _btnActivePiso = value.isNotEmpty),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _PuertaController,
                          label: LocaleData.modViviendaPuerta.getString(context),
                          icon: Icons.door_back_door,
                          onChanged: (value) => setState(() => _btnActivePuerta = value.isNotEmpty),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Información geográfica
                  _buildSectionTitle(
                    LocaleData.modViviendaLocalizacion.getString(context), 
                    Icons.map
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _LocalidadController,
                          label: LocaleData.modViviendaLocalidad.getString(context),
                          icon: Icons.location_city,
                          required: true,
                          onChanged: (value) => setState(() => _btnActiveLocalidad = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveLocalidad = false;
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _ProvinciaController,
                          label: LocaleData.modViviendaProvincia.getString(context),
                          icon: Icons.map,
                          required: true,
                          onChanged: (value) => setState(() => _btnActiveProvincia = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveProvincia = false;
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _PaisController,
                          label: LocaleData.modViviendaPais.getString(context),
                          icon: Icons.public,
                          required: true,
                          onChanged: (value) => setState(() => _btnActivePais = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActivePais = false;
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _CodPostalController,
                          label: LocaleData.modViviendaCodigoPostal.getString(context),
                          icon: Icons.markunread_mailbox,
                          required: true,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() => _btnActiveCodPostal = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveCodPostal = false;
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Información adicional
                  _buildSectionTitle(
                    LocaleData.modViviendaAdicional.getString(context), 
                    Icons.info
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _NumPlantasController,
                          label: LocaleData.modViviendaNumeroPlantas.getString(context),
                          icon: Icons.layers,
                          required: true,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() => _btnActivePlantas = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActivePlantas = false;
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _LatitudController,
                          label: LocaleData.modViviendaLatitud.getString(context),
                          icon: Icons.location_searching,
                          required: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) => setState(() => _btnActiveLatitud = value.isNotEmpty),
                          validator: (value) {
                            RegExp regExp = RegExp(r'^-?\d*\.?\d+$');
                            if (value == null || value.isEmpty) {
                              _btnActiveLatitud = false;
                              return LocaleData.campoObligatorio.getString(context);
                            } else if (!regExp.hasMatch(value)) {
                              _btnActiveLatitud = false;
                              return LocaleData.soloNumerosPunto.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _LongitudController,
                          label: LocaleData.modViviendaLongitud.getString(context),
                          icon: Icons.location_searching,
                          required: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) => setState(() => _btnActiveLongitud = value.isNotEmpty),
                          validator: (value) {
                            RegExp regExp = RegExp(r'^-?\d*\.?\d+$');
                            if (value == null || value.isEmpty) {
                              _btnActiveLongitud = false;
                              return LocaleData.campoObligatorio.getString(context);
                            } else if (!regExp.hasMatch(value)) {
                              _btnActiveLongitud = false;
                              return LocaleData.soloNumerosPunto.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botón de guardar
                  _buildSaveButton(context),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // NUEVO: Título de sección
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorPrimario),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // NUEVO: Campo de texto mejorado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
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
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(icon, size: 20, color: colorPrimario),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  // NUEVO: Botón de guardar mejorado
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_btnActivePlantas && _btnActivePais && _btnActiveProvincia && 
                _btnActiveLocalidad && _btnActiveCodPostal && _btnActiveNumero && 
                _btnActiveDireccion && _btnActiveLatitud && _btnActiveLongitud) {
              
              COD_CASA = await DBPostgres().DBModCasa(
                widget.vivienda.CodCasa,
                _DireccionController.text,
                _NumeroController.text,
                _PisoController.text,
                _PuertaController.text,
                _CodPostalController.text,
                _LocalidadController.text,
                _ProvinciaController.text,
                _PaisController.text,
                int.tryParse(_NumPlantasController.text),
                double.tryParse(_LatitudController.text),
                double.tryParse(_LongitudController.text),
              );
              
              if (COD_CASA == 'Se ha modificado correctamente') {
                _showSuccessDialog(context);
              } else if (COD_CASA == 'duplicate') {
                _showErrorDialog(context, LocaleData.modViviendaDuplicada.getString(context));
              }
            }
          } else {
            _showErrorDialog(context, LocaleData.modViviendaCompletarCampos.getString(context));
          }
        },
        icon: const Icon(Icons.save, color: Colors.white),
        label: Text(
          LocaleData.modViviendaGuardar.getString(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimario,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  // NUEVO: Diálogo de éxito
  void _showSuccessDialog(BuildContext context) {
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
            Text(LocaleData.modViviendaExito.getString(context)),
          ],
        ),
        content: Text(LocaleData.modViviendaModificada.getString(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ViviendasScreen(tipoUsuario: 'superadmin'),
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
                LocaleData.modViviendaAceptar.getString(context),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NUEVO: Diálogo de error
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
            Text(LocaleData.modViviendaError.getString(context)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.modViviendaAceptar.getString(context),
              style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}