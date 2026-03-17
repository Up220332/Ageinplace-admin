import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../base_de_datos/postgres.dart';
import '../SuperAdmin/screen_administradores.dart';

class ModAdminScreen extends StatefulWidget {
  final Admin admin;

  const ModAdminScreen({super.key, required this.admin});

  @override
  State<ModAdminScreen> createState() => _ModAdminScreenState();
}

class _ModAdminScreenState extends State<ModAdminScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _Surname1Controller = TextEditingController();
  final TextEditingController _Surname2Controller = TextEditingController();
  final TextEditingController _DateBirthController = TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _OrganitationController = TextEditingController();
  
  late String PhoneNumber = '';
  bool _btnActiveName = true;
  bool _btnActiveSurname1 = true;
  bool _btnActivePhoneNumber = true;
  bool _btnActiveEmail = true;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Modificar Administrador',
      'header': 'Modifique los datos del administrador',
      'info_personal': 'INFORMACIÓN PERSONAL',
      'nombre': 'Nombre',
      'primer_apellido': 'Primer Apellido',
      'segundo_apellido': 'Segundo Apellido',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'info_contacto': 'INFORMACIÓN DE CONTACTO',
      'email': 'Correo electrónico',
      'email_invalido': 'Email inválido',
      'telefono': 'Teléfono',
      'telefono_invalido': 'Número de teléfono inválido',
      'buscar': 'Buscar',
      'organizacion': 'Organización',
      'guardar': 'Guardar Cambios',
      'campo_obligatorio': 'Campo obligatorio',
      'obligatorio': 'Obligatorio',
      'exito': 'Éxito',
      'modificado': 'Administrador modificado correctamente',
      'error': 'Error',
      'aceptar': 'Aceptar',
      'email_registrado': 'El correo electrónico ya está registrado',
      'error_modificar': 'Error al modificar el administrador',
    },
    'en': {
      'titulo': 'Edit Administrator',
      'header': 'Modify the administrator data',
      'info_personal': 'PERSONAL INFORMATION',
      'nombre': 'Name',
      'primer_apellido': 'First Surname',
      'segundo_apellido': 'Second Surname',
      'fecha_nacimiento': 'Birth date',
      'info_contacto': 'CONTACT INFORMATION',
      'email': 'Email',
      'email_invalido': 'Invalid email',
      'telefono': 'Phone',
      'telefono_invalido': 'Invalid phone number',
      'buscar': 'Search',
      'organizacion': 'Organization',
      'guardar': 'Save Changes',
      'campo_obligatorio': 'Required field',
      'obligatorio': 'Required',
      'exito': 'Success',
      'modificado': 'Administrator modified successfully',
      'error': 'Error',
      'aceptar': 'Accept',
      'email_registrado': 'Email is already registered',
      'error_modificar': 'Error modifying administrator',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  @override
  void initState() {
    super.initState();
    _NameController.text = widget.admin.Nombre;
    _Surname1Controller.text = widget.admin.Apellido1;
    _Surname2Controller.text = widget.admin.Apellido2;
    _DateBirthController.text = widget.admin.FechaNacimiento;
    _PhoneNumberController.text = widget.admin.Telefono;
    _EmailController.text = widget.admin.Email;
    _OrganitationController.text = widget.admin.Organizacion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorPrimario,
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
                  // Header informativo
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
                          Icons.admin_panel_settings,
                          color: colorPrimario,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t('header'),
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

                  // Información personal
                  _buildSectionTitle(t('info_personal'), Icons.person),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _NameController,
                    label: t('nombre'),
                    icon: Icons.badge,
                    required: true,
                    onChanged: (value) => setState(() => _btnActiveName = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _btnActiveName = false;
                        return t('campo_obligatorio');
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _Surname1Controller,
                          label: t('primer_apellido'),
                          icon: Icons.family_restroom,
                          required: true,
                          onChanged: (value) => setState(() => _btnActiveSurname1 = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _btnActiveSurname1 = false;
                              return t('obligatorio');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _Surname2Controller,
                          label: t('segundo_apellido'),
                          icon: Icons.family_restroom,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Fecha de nacimiento (solo lectura, no modificable)
                  _buildReadOnlyDateField(),

                  const SizedBox(height: 24),

                  // Información de contacto
                  _buildSectionTitle(t('info_contacto'), Icons.contact_mail),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _EmailController,
                    label: t('email'),
                    icon: Icons.email,
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() => _btnActiveEmail = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _btnActiveEmail = false;
                        return t('campo_obligatorio');
                      } else if (!value.contains('@')) {
                        _btnActiveEmail = false;
                        return t('email_invalido');
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildPhoneField(),

                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _OrganitationController,
                    label: t('organizacion'),
                    icon: Icons.business,
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 32),

                  // Botón de guardar
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_btnActiveName && _btnActiveSurname1 && 
                              _btnActiveEmail && _btnActivePhoneNumber) {
                            ContinuaButton();
                          }
                        }
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        t('guardar'),
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
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildReadOnlyDateField() {
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
        controller: _DateBirthController,
        readOnly: true,
        enabled: false,
        decoration: InputDecoration(
          labelText: t('fecha_nacimiento'),
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(Icons.cake, size: 20, color: colorPrimario.withOpacity(0.5)),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
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
      child: IntlPhoneField(
        controller: _PhoneNumberController,
        invalidNumberMessage: t('telefono_invalido'),
        validator: (phone) {
          if (phone == null || phone.number.isEmpty) {
            _btnActivePhoneNumber = false;
            return t('campo_obligatorio');
          }
          return null;
        },
        searchText: t('buscar'),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          labelText: '${t('telefono')} *',
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
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
        initialCountryCode: 'ES',
        onChanged: (phone) {
          setState(() {
            if (phone.number.isNotEmpty) {
              _btnActivePhoneNumber = true;
              PhoneNumber = phone.number;
            } else {
              _btnActivePhoneNumber = false;
            }
          });
        },
      ),
    );
  }

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
            Text(t('exito')),
          ],
        ),
        content: Text(t('modificado')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminitradoresScreen(),
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
                t('aceptar'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            Text(t('error')),
          ],
        ),
        content: Text(message),
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

  Future<void> ContinuaButton() async {
    var newadminOk = await DBPostgres().DBModAdmin(
      widget.admin.CodUsuario,
      _NameController.text,
      _Surname1Controller.text,
      _Surname2Controller.text,
      PhoneNumber,
      _EmailController.text,
      _OrganitationController.text,
    );
    if (newadminOk == true) {
      _showSuccessDialog();
    } else if (newadminOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(t('email_registrado'));
    } else {
      _showErrorDialog(t('error_modificar'));
    }
  }
}