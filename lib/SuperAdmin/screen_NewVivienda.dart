import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:flutter/material.dart';

import '../../base_de_datos/postgres.dart';

var COD_CASA;

/// ******************************************************************************
/// Pantalla donde se introducen los datos de la vivienda
///*****************************************************************************
class NewViviendaScreen extends StatefulWidget {
  final String role;

  const NewViviendaScreen({super.key, required this.role});

  @override
  State<NewViviendaScreen> createState() => _NewViviendaScreenSate();
}

class _NewViviendaScreenSate extends State<NewViviendaScreen> {
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

  bool _btnActiveDireccion = false;
  bool _btnActiveNumero = false;
  bool _btnActivePuerta = false;
  bool _btnActivePiso = false;
  bool _btnActiveCodPostal = false;
  bool _btnActiveLocalidad = false;
  bool _btnActivePais = false;
  bool _btnActiveProvincia = false;
  bool _btnActivePlantas = false;
  bool _btnActiveLatitud = false;
  bool _btnActiveLongitud = false;

  final _formKey = GlobalKey<FormState>();
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

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
        title: const Text(
          'Nueva Vivienda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
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
                  // Texto informativo mejorado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorPrimario.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorPrimario.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorPrimario,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Complete los campos obligatorios (*) para registrar una nueva vivienda',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Información de ubicación
                  _buildSectionTitle('UBICACIÓN', Icons.location_on),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _DireccionController,
                    label: 'Dirección',
                    icon: Icons.streetview,
                    required: true,
                    onChanged: (value) => setState(
                      () => _btnActiveDireccion = value.isNotEmpty,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _btnActiveDireccion = false;
                        return 'Campo obligatorio';
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
                          label: 'Número',
                          icon: Icons.door_front_door,
                          required: true,
                          onChanged: (value) => setState(
                            () => _btnActiveNumero = value.isNotEmpty,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveNumero = false;
                              return 'Obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _PisoController,
                          label: 'Piso',
                          icon: Icons.stairs,
                          onChanged: (value) => setState(
                            () => _btnActivePiso = value.isNotEmpty,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _PuertaController,
                          label: 'Puerta',
                          icon: Icons.door_back_door,
                          onChanged: (value) => setState(
                            () => _btnActivePuerta = value.isNotEmpty,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Información geográfica
                  _buildSectionTitle('LOCALIZACIÓN', Icons.map),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _LocalidadController,
                          label: 'Localidad',
                          icon: Icons.location_city,
                          required: true,
                          onChanged: (value) => setState(
                            () => _btnActiveLocalidad = value.isNotEmpty,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveLocalidad = false;
                              return 'Obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _ProvinciaController,
                          label: 'Provincia',
                          icon: Icons.map,
                          required: true,
                          onChanged: (value) => setState(
                            () => _btnActiveProvincia = value.isNotEmpty,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveProvincia = false;
                              return 'Obligatorio';
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
                          label: 'País',
                          icon: Icons.public,
                          required: true,
                          onChanged: (value) => setState(
                            () => _btnActivePais = value.isNotEmpty,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActivePais = false;
                              return 'Obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _CodPostalController,
                          label: 'Código Postal',
                          icon: Icons.markunread_mailbox,
                          required: true,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(
                            () => _btnActiveCodPostal = value.isNotEmpty,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveCodPostal = false;
                              return 'Obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Información adicional
                  _buildSectionTitle('INFORMACIÓN ADICIONAL', Icons.info),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _NumPlantasController,
                          label: 'Número de Plantas',
                          icon: Icons.layers,
                          required: true,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(
                            () => _btnActivePlantas = value.isNotEmpty,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActivePlantas = false;
                              return 'Obligatorio';
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
                          label: 'Latitud',
                          icon: Icons.location_searching,
                          required: true,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) => setState(
                            () => _btnActiveLatitud = value.isNotEmpty,
                          ),
                          validator: (value) {
                            RegExp regExp = RegExp(r'^-?\d*\.?\d+$');
                            if (value == null || value.isEmpty) {
                              _btnActiveLatitud = false;
                              return 'Obligatorio';
                            } else if (!regExp.hasMatch(value)) {
                              _btnActiveLatitud = false;
                              return 'Solo números y punto';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _LongitudController,
                          label: 'Longitud',
                          icon: Icons.location_searching,
                          required: true,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) => setState(
                            () => _btnActiveLongitud = value.isNotEmpty,
                          ),
                          validator: (value) {
                            RegExp regExp = RegExp(r'^-?\d*\.?\d+$');
                            if (value == null || value.isEmpty) {
                              _btnActiveLongitud = false;
                              return 'Obligatorio';
                            } else if (!regExp.hasMatch(value)) {
                              _btnActiveLongitud = false;
                              return 'Solo números y punto';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Botón de guardar
                  _buildSaveButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Título de sección
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

  // Campo de texto mejorado
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
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

  // Botón de guardar mejorado
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_btnActivePlantas &&
                _btnActivePais &&
                _btnActiveProvincia &&
                _btnActiveLocalidad &&
                _btnActiveCodPostal &&
                _btnActiveNumero &&
                _btnActiveDireccion &&
                _btnActiveLatitud &&
                _btnActiveLongitud) {
              COD_CASA = await DBPostgres().DBNewCasa(
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
              if (COD_CASA == 'Se ha insertado correctamente') {
                _showSuccessDialog();
              } else if (COD_CASA == 'duplicate') {
                _showErrorDialog(
                  'Ya existe una vivienda con esa dirección',
                );
              }
            }
          } else {
            _showErrorDialog('Por favor, complete todos los campos obligatorios');
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Crear Vivienda',
          style: TextStyle(
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

  // Diálogo de éxito
  void _showSuccessDialog() {
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
            const Text('¡Éxito!'),
          ],
        ),
        content: const Text('La vivienda se ha creado correctamente'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ViviendasScreen(
                    tipoUsuario: widget.role,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colorPrimario,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Diálogo de error
  void _showErrorDialog(String message) {
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
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Aceptar',
              style: TextStyle(
                color: colorPrimario,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}