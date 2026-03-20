/// ****************************************************************************
/// Pantalla que permite modificar los datos de un usuario administrador
///***************************************************************************
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../base_de_datos/postgres.dart';
import '../log-in/screen_LogIn.dart';

class ModUserAdminScreen extends StatefulWidget {
  const ModUserAdminScreen({super.key});

  @override
  State<ModUserAdminScreen> createState() => _ModUserAdminScreenState();
}

class _ModUserAdminScreenState extends State<ModUserAdminScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _Surname1Controller = TextEditingController();
  final TextEditingController _Surname2Controller = TextEditingController();
  final TextEditingController _DateBirthController = TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _OrganitationController = TextEditingController();
  late String PhoneNumber = '';
  late bool PasswordVisibility = true;
  bool _btnActiveName = true;
  bool _btnActiveSurname1 = true;
  bool _btnActiveDateBirth = true;
  bool _btnActivePhoneNumber = true;
  bool _btnActiveEmail = true;
  final bool _btnActivePassword = true;
  bool _btnActiveOrganitation = true;
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Modificar Datos',
      'header': 'Modifique sus datos personales',
      'info_personal': 'INFORMACIÓN PERSONAL',
      'nombre': 'Nombre',
      'nombre_requerido': 'El nombre es obligatorio',
      'primer_apellido': 'Primer Apellido',
      'primer_apellido_requerido': 'El primer apellido es obligatorio',
      'segundo_apellido': 'Segundo Apellido',
      'fecha_nacimiento': 'Fecha de nacimiento',
      'seleccionar_fecha': 'Seleccionar fecha',
      'info_contacto': 'INFORMACIÓN DE CONTACTO',
      'email': 'Correo electrónico',
      'email_requerido': 'El correo electrónico es obligatorio',
      'email_invalido': 'Email inválido',
      'email_registrado': 'El correo electrónico ya está registrado',
      'telefono': 'Teléfono',
      'telefono_requerido': 'El teléfono es obligatorio',
      'telefono_invalido': 'Número de teléfono inválido',
      'buscar': 'Buscar',
      'organizacion': 'Organización',
      'organizacion_requerida': 'La organización es obligatoria',
      'guardar': 'Guardar Cambios',
      'cancelar': 'Cancelar',
      'campo_obligatorio': 'Campo obligatorio',
      'obligatorio': 'Obligatorio',
      'exito': 'Éxito',
      'modificado': 'Datos modificados correctamente',
      'error': 'Error',
      'error_modificar': 'Error al modificar los datos',
      'aceptar': 'Aceptar',
      'campos_obligatorios': 'Por favor, complete todos los campos obligatorios',
      'menor_edad': 'Menor de 18 años',
      'menor_edad_mensaje': 'Debe ser mayor de 18 años',
      'cerrar': 'Cerrar',
    },
    'en': {
      'titulo': 'Edit Profile',
      'header': 'Modify your personal information',
      'info_personal': 'PERSONAL INFORMATION',
      'nombre': 'Name',
      'nombre_requerido': 'Name is required',
      'primer_apellido': 'First Surname',
      'primer_apellido_requerido': 'First surname is required',
      'segundo_apellido': 'Second Surname',
      'fecha_nacimiento': 'Birth date',
      'seleccionar_fecha': 'Select date',
      'info_contacto': 'CONTACT INFORMATION',
      'email': 'Email',
      'email_requerido': 'Email is required',
      'email_invalido': 'Invalid email',
      'email_registrado': 'Email is already registered',
      'telefono': 'Phone',
      'telefono_requerido': 'Phone is required',
      'telefono_invalido': 'Invalid phone number',
      'buscar': 'Search',
      'organizacion': 'Organization',
      'organizacion_requerida': 'Organization is required',
      'guardar': 'Save Changes',
      'cancelar': 'Cancel',
      'campo_obligatorio': 'Required field',
      'obligatorio': 'Required',
      'exito': 'Success',
      'modificado': 'Data modified successfully',
      'error': 'Error',
      'error_modificar': 'Error modifying data',
      'aceptar': 'Accept',
      'campos_obligatorios': 'Please fill all required fields',
      'menor_edad': 'Underage',
      'menor_edad_mensaje': 'You must be over 18 years old',
      'cerrar': 'Close',
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
    _NameController.text = usuario[0].Nombre;
    _Surname1Controller.text = usuario[0].Apellido1;
    _Surname2Controller.text = usuario[0].Apellido2;
    _DateBirthController.text = usuario[0].FechaNacimiento;
    _PhoneNumberController.text = usuario[0].Telefono;
    _EmailController.text = usuario[0].Email;
    _OrganitationController.text = usuario[0].Organizacion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
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
                        return t('nombre_requerido');
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
                              return t('primer_apellido_requerido');
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

                  // Fecha de nacimiento (con selector)
                  _buildDateField(),

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
                        return t('email_requerido');
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
                    required: true,
                    onChanged: (value) => setState(() => _btnActiveOrganitation = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _btnActiveOrganitation = false;
                        return t('organizacion_requerida');
                      }
                      return null;
                    },
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
                              _btnActiveEmail && _btnActivePhoneNumber && 
                              _btnActiveOrganitation && _btnActiveDateBirth) {
                            ContinuaButton();
                          } else {
                            _showErrorDialog(t('campos_obligatorios'));
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

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => SelectDateBirth(context),
      child: Container(
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              _btnActiveDateBirth = false;
              return t('campo_obligatorio');
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: '${t('fecha_nacimiento')} *',
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            prefixIcon: Icon(Icons.cake, size: 20, color: colorPrimario),
            suffixIcon: Icon(Icons.calendar_today, size: 18, color: colorPrimario),
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
            return t('telefono_requerido');
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
              Navigator.pop(context); // Volver a la pantalla anterior
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

  /// ********************************************************************
  /// Fucnion que escribe en la base de datos el nuevo usuario generando
  /// una contraseña aleatoria y enviandola por correo electronico
  ///*******************************************************************
  Future<void> ContinuaButton() async {
    var moduseradminOk = await DBPostgres().DBModUserAdmin(
      usuario[0].CodUsuario,
      _NameController.text,
      _Surname1Controller.text,
      _Surname2Controller.text,
      PhoneNumber,
      _EmailController.text,
      _OrganitationController.text,
    );
    
    if (moduseradminOk == true) {
      _showSuccessDialog();
    } else if (moduseradminOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(t('email_registrado'));
    } else {
      _showErrorDialog(t('error_modificar'));
    }
  }

  /// ***************************************************************************
  /// Funcion para generar una contraseña aleatoria
  ///***************************************************************************
  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );

  /// *****************************************************************************
  /// Funcion para seleccionar la fecha de nacimiento
  ///*****************************************************************************
  Future<void> SelectDateBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: colorPrimario,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );

    if (newDate == null) {
      return;
    }

    final age = DateTime.now().difference(newDate).inDays ~/ 365;
    if (age < 18) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 10),
              Text(t('menor_edad')),
            ],
          ),
          content: Text(t('menor_edad_mensaje')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                t('cerrar'),
                style: TextStyle(color: colorPrimario),
              ),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _btnActiveDateBirth = true;
        _DateBirthController.text = DateFormat('dd/MM/yyyy').format(newDate);
      });
    }
  }
}