/// ****************************************************************************
/// Pantalla que permite modificar los datos de un usuario administrador
///***************************************************************************
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../base_de_datos/postgres.dart';
import '../log-in/screen_LogIn.dart';

class ModUserAdminScreen extends StatefulWidget {
  const ModUserAdminScreen({super.key});

  @override
  State<ModUserAdminScreen> createState() => _ModUserAdminScreenSate();
}

class _ModUserAdminScreenSate extends State<ModUserAdminScreen> {
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
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0716BB),
        centerTitle: true,
        title: const Text(
          'Modificar Datos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Align(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /**************************************************************
                      Introducir Nombre
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 30, 20, 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 20, 0),
                        child: TextFormField(
                          controller: _NameController,
                          //Seleccionar si se ve la contraseña
                          obscureText: false,
                          //Autovalidar ineraccion
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //Comporbar que el texto no esta vacío
                          validator: (NameController) {
                            if (NameController == null ||
                                NameController.isEmpty) {
                              _btnActiveName = false;
                              return 'El campo no puede estar vacío';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _btnActiveName = value.isNotEmpty ? true : false;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Nombre*',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0716BB),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 231, 0, 0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /**************************************************************
                      Introducir Primer Apellido
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 20, 0),
                        child: TextFormField(
                          controller: _Surname1Controller,
                          //Seleccionar si se ve la contraseña
                          obscureText: false,
                          //Autovalidar ineraccion
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //Comporbar que el texto no esta vacío
                          validator: (Surname1Controller) {
                            if (Surname1Controller == null ||
                                Surname1Controller.isEmpty) {
                              _btnActiveSurname1 = false;
                              return 'El campo no puede estar vacío';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _btnActiveSurname1 =
                                  value.isNotEmpty ? true : false;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Primer Apellido*',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0716BB),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 231, 0, 0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /**************************************************************
                      Introducir Segundo Apellido
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 20, 0),
                        child: TextFormField(
                          controller: _Surname2Controller,
                          //Seleccionar si se ve la contraseña
                          obscureText: false,
                          //Comporbar que el texto no esta vacío
                          validator: (Surname2Controller) {
                            if (Surname2Controller == null ||
                                Surname2Controller.isEmpty) {
                              return 'El campo no puede estar vacío';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Segundo Apellido',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0716BB),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /**************************************************************
                      Introducir E-Mail
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 20, 0),
                        child: TextFormField(
                          controller: _EmailController,
                          //Seleccionar si se ve la contraseña
                          obscureText: false,
                          //Autovalidar ineraccion
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //Comporbar que el texto no esta vacío
                          validator: (EmailController) {
                            if (EmailController == null ||
                                EmailController.isEmpty) {
                              _btnActiveEmail = false;
                              return 'El campo e-mail no puede estar vacío';
                            } else if (!EmailController.contains("@")) {
                              _btnActiveEmail = false;
                              return 'Introduzca un e-mail valido';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _btnActiveEmail = value.isNotEmpty ? true : false;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico *',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0716BB),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 231, 0, 0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /**************************************************************
                      Introducir Numero de telefono
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: Container(
                      width: double.infinity,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 20, 0),
                        child: IntlPhoneField(
                          invalidNumberMessage: 'Número de teléfono invalido',
                          controller: _PhoneNumberController,
                          validator: (PhoneNumberController) {
                            if (PhoneNumberController == null) {
                              _btnActivePhoneNumber = false;
                              return 'El campo no puede estar vacío';
                            }

                            return null;
                          },
                          searchText: 'Buscar',
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: 'Teléfono *',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0716BB),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 231, 0, 0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          initialCountryCode: 'ES',
                          onChanged: (phone) {
                            if (phone.number.isEmpty) {
                              _btnActivePhoneNumber = false;
                            } else {
                              _btnActivePhoneNumber = true;
                              PhoneNumber = phone.number;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  /**************************************************************
                      Introducir ORGANIZACION
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 20, 0),
                        child: TextFormField(
                          controller: _OrganitationController,
                          //Seleccionar si se ve la contraseña
                          obscureText: false,
                          //Autovalidar ineraccion
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //Comporbar que el texto no esta vacío
                          validator: (OrganitationController) {
                            if (OrganitationController == null ||
                                OrganitationController.isEmpty) {
                              return 'El campo organización no puede estar vacío';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _btnActiveOrganitation =
                                  value.isNotEmpty ? true : false;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Organización',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 11, 8, 8),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0716BB),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /**************************************************************
                   * Boton continuar
                   ***************************************************************/
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        /********************************************************
                         * Comprobar que todos los campos estan rellenos
                         ********************************************************/
                        onPressed: () {
                          if (_btnActiveName == true &&
                              _btnActiveSurname1 == true &&
                              _btnActiveEmail == true &&
                              _btnActiveDateBirth == true &&
                              _btnActivePhoneNumber == true) {
                            ContinuaButton();
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(
                                    'Rellene todos los campos obligatorios',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Aceptar',
                                        style: TextStyle(
                                          color: Color(0xFF0716BB),
                                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0716BB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Continuar',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViviendasScreen()),
      );*/
    } else if (moduseradminOk.detail.contains('Ya existe la llave')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error', style: TextStyle(color: Colors.red)),
            content: Text('El correo electrónico ya está registrado'),
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
      firstDate: DateTime(DateTime.now().year - 200),
      lastDate: DateTime(DateTime.now().year + 1),
      builder:
          (context, child) => Theme(
            data: ThemeData().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 32, 98, 241),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
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
        builder:
            (context) => AlertDialog(
              title: const Text('Menor de 18 años'),
              content: const Text('Debe ser mayor de 18 años'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
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
