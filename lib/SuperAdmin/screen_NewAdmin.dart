/// *****************************************************************************
/// Pantalla que permite crear un nuevo administrador
///*****************************************************************************
library;

import 'dart:math';

import 'package:ageinplace_admin/SuperAdmin/screen_administradores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../E-MailSender/E-MailSend.dart';
import '../../base_de_datos/postgres.dart';
import '../localization/locales.dart';

class NewAdminScreen extends StatefulWidget {
  const NewAdminScreen({super.key});

  @override
  State<NewAdminScreen> createState() => _NewAdminScreenSate();
}

class _NewAdminScreenSate extends State<NewAdminScreen> {
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
  late bool PasswordVisibility = false;
  
  bool _btnActiveName = false;
  bool _btnActiveSurname1 = false;
  bool _btnActiveDateBirth = false;
  bool _btnActivePhoneNumber = false;
  bool _btnActiveEmail = false;
  bool _btnActiveOrganitation = false;
  
  final _formKey = GlobalKey<FormState>();
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

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
        title: Text(
          LocaleData.newAdminTitulo.getString(context),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
                            LocaleData.newAdminHeader.getString(context),
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
                  _buildSectionTitle(
                    LocaleData.newAdminInfoPersonal.getString(context), 
                    Icons.person
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _NameController,
                    label: LocaleData.newAdminNombre.getString(context),
                    icon: Icons.badge,
                    required: true,
                    onChanged: (value) => setState(() => _btnActiveName = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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
                          controller: _Surname1Controller,
                          label: LocaleData.newAdminPrimerApellido.getString(context),
                          icon: Icons.family_restroom,
                          required: true,
                          onChanged: (value) => setState(() => _btnActiveSurname1 = value.isNotEmpty),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleData.campoObligatorio.getString(context);
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _Surname2Controller,
                          label: LocaleData.newAdminSegundoApellido.getString(context),
                          icon: Icons.family_restroom,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Fecha de nacimiento (campo especial)
                  _buildDateField(context),

                  const SizedBox(height: 24),

                  // Información de contacto
                  _buildSectionTitle(
                    LocaleData.newAdminInfoContacto.getString(context), 
                    Icons.contact_mail
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _EmailController,
                    label: LocaleData.newAdminEmail.getString(context),
                    icon: Icons.email,
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() => _btnActiveEmail = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleData.campoObligatorio.getString(context);
                      } else if (!value.contains('@')) {
                        return LocaleData.newAdminEmailInvalido.getString(context);
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildPhoneField(context),

                  const SizedBox(height: 24),

                  // Información adicional
                  _buildSectionTitle(
                    LocaleData.newAdminInfoAdicional.getString(context), 
                    Icons.business
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _OrganitationController,
                    label: LocaleData.newAdminOrganizacion.getString(context),
                    icon: Icons.business,
                    required: true,
                    onChanged: (value) => setState(() => _btnActiveOrganitation = value.isNotEmpty),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleData.campoObligatorio.getString(context);
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Botón de continuar
                  _buildContinueButton(context),

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

  Widget _buildDateField(BuildContext context) {
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
        onTap: () => SelectDateBirth(context),
        decoration: InputDecoration(
          labelText: LocaleData.newAdminFechaNacimiento.getString(context),
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
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
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
        invalidNumberMessage: LocaleData.newAdminTelefonoInvalido.getString(context),
        validator: (phone) {
          if (phone == null || phone.number.isEmpty) {
            return LocaleData.campoObligatorio.getString(context);
          }
          return null;
        },
        searchText: LocaleData.newAdminBuscar.getString(context),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          labelText: '${LocaleData.newAdminTelefono.getString(context)} *',
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

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_btnActiveName && _btnActiveSurname1 && 
                _btnActiveEmail && _btnActivePhoneNumber) {
              ContinuaButton(context);
            }
          } else {
            _showErrorDialog(context, LocaleData.newAdminCompletarCampos.getString(context));
          }
        },
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        label: Text(
          LocaleData.newAdminContinuar.getString(context),
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
            Text(LocaleData.newAdminError.getString(context)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.newAdminAceptar.getString(context),
              style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String email) {
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
            Text(LocaleData.newAdminExito.getString(context)),
          ],
        ),
        content: Text(
          LocaleData.newAdminCorreoEnviado.getString(context).replaceAll(
            '{email}', email
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminitradoresScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colorPrimario,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                LocaleData.newAdminAceptar.getString(context),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ********************************************************************
  /// Función que escribe en la base de datos el nuevo usuario generando
  /// una contraseña aleatoria y enviándola por correo electrónico
  ///*******************************************************************
  Future<void> ContinuaButton(BuildContext context) async {
    var Password = getRandomString(15);
    var newadminOk = await DBPostgres().DBNewAdmin(
      _NameController.text,
      _Surname1Controller.text,
      _Surname2Controller.text,
      PhoneNumber,
      _EmailController.text,
      _OrganitationController.text,
      Password,
    );
    
    if (newadminOk == true) {
      SendRegistConfirm(_EmailController.text, Password);
      _showSuccessDialog(context, _EmailController.text);
    } else if (newadminOk.toString().contains('Ya existe la llave') || 
               newadminOk.toString().contains('duplicate key')) {
      _showErrorDialog(context, LocaleData.newAdminEmailRegistrado.getString(context));
    } else {
      _showErrorDialog(context, LocaleData.newAdminErrorCrear.getString(context));
    }
  }

  /// ***************************************************************************
  /// Función para generar una contraseña aleatoria
  ///***************************************************************************
  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );

  /// *****************************************************************************
  /// Función para seleccionar la fecha de nacimiento
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
        child: child ?? const Text(''),
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
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 10),
              Text(LocaleData.newAdminMenorEdad.getString(context)),
            ],
          ),
          content: Text(LocaleData.newAdminMenorEdadMsg.getString(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                LocaleData.newAdminCerrar.getString(context),
                style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
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