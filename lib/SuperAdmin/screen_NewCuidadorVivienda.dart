/// *****************************************************************************
/// Funcion que añade cuidadores nuevos a una vivienda
///****************************************************************************
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../E-MailSender/E-MailSend.dart';
import '../../base_de_datos/postgres.dart';
import '../localization/locales.dart';
import '../SuperAdmin/screen_CuidadoresVivienda.dart';
import '../SuperAdmin/screen_viviendas.dart';

class NewCuidadorViviendaScreen extends StatefulWidget {
  final Vivienda vivienda;
  final String role;

  const NewCuidadorViviendaScreen({
    super.key,
    required this.vivienda,
    required this.role,
  });

  @override
  State<NewCuidadorViviendaScreen> createState() =>
      _NewCuidadorViviendaScreenSate();
}

class _NewCuidadorViviendaScreenSate extends State<NewCuidadorViviendaScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _Surname1Controller = TextEditingController();
  final TextEditingController _Surname2Controller = TextEditingController();
  final TextEditingController _DateBirthController = TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _OrganitationController = TextEditingController();
  final TextEditingController _DesOtrosTipoCuidadorController =
      TextEditingController();
  
  late String PhoneNumber = '';
  bool _btnActiveName = false;
  bool _btnActiveSurname1 = false;
  bool _btnActiveDateBirth = false;
  bool _btnActiveEmail = false;
  bool _btnActiveOrganitation = false;
  
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  List<TipodeCuidador> TipoCuidadorList = [];
  int CodTipoCuidador = 0;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  // Mapa de traducciones para tipos de cuidador (COMPLETO con todos los tipos)
  Map<String, String> caregiverTypeTranslations = {
    'Cuidador Formal': 'Formal caregiver',
    'Responsable Sanitario': 'Healthcare responsible',
    'Familiar': 'Family member',
    'Vecino': 'Neighbor',
    'Amigo': 'Friend',
    'Voluntario': 'Volunteer',
    'Otros': 'Others',
    'Cónyuge (Cuidador Informal)': 'Spouse (Informal caregiver)',
    'Hermano/a (Cuidador Informal)': 'Sibling (Informal caregiver)',
    'Hijo/a (Cuidador Informal)': 'Child (Informal caregiver)',
    'Madre (Cuidador Informal)': 'Mother (Informal caregiver)',
    'Padre (Cuidador Informal)': 'Father (Informal caregiver)',
  };

  // Función para obtener el nombre traducido del tipo de cuidador
  String getTranslatedCaregiverType(String type) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return caregiverTypeTranslations[type] ?? type;
    }
    return type;
  }

  Future<String> getTipoCuidador() async {
    var Dbdata = await DBPostgres().DBGetTipoCuidador();
    setState(() {
      for (var p in Dbdata) {
        TipoCuidadorList.add(TipodeCuidador(p[0], p[1]));
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getTipoCuidador();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CuidadoresViviendaScreen(
              CodCasa: widget.vivienda.CodCasa,
              vivienda: widget.vivienda,
              role: widget.role,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: colorPrimario,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          title: Text(
            LocaleData.newCuidadorTitulo.getString(context),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
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
                            Icons.person_add,
                            color: colorPrimario,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              LocaleData.newCuidadorHeader.getString(context),
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
                      LocaleData.newCuidadorInfoPersonal.getString(context), 
                      Icons.person
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _NameController,
                      label: LocaleData.newCuidadorNombre.getString(context),
                      icon: Icons.badge,
                      required: true,
                      onChanged: (value) => setState(() => _btnActiveName = value.isNotEmpty),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _btnActiveName = false;
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
                            label: LocaleData.newCuidadorPrimerApellido.getString(context),
                            icon: Icons.family_restroom,
                            required: true,
                            onChanged: (value) => setState(() => _btnActiveSurname1 = value.isNotEmpty),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                _btnActiveSurname1 = false;
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
                            label: LocaleData.newCuidadorSegundoApellido.getString(context),
                            icon: Icons.family_restroom,
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Fecha de nacimiento
                    _buildDateField(context),

                    const SizedBox(height: 24),

                    // Información de contacto
                    _buildSectionTitle(
                      LocaleData.newCuidadorInfoContacto.getString(context), 
                      Icons.contact_mail
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _EmailController,
                      label: LocaleData.newCuidadorEmail.getString(context),
                      icon: Icons.email,
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(() => _btnActiveEmail = value.isNotEmpty),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _btnActiveEmail = false;
                          return LocaleData.campoObligatorio.getString(context);
                        } else if (!value.contains('@')) {
                          _btnActiveEmail = false;
                          return LocaleData.newCuidadorEmailInvalido.getString(context);
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildPhoneField(context),

                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _OrganitationController,
                      label: LocaleData.newCuidadorOrganizacion.getString(context),
                      icon: Icons.business,
                      onChanged: (value) => setState(() => _btnActiveOrganitation = value.isNotEmpty),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _btnActiveOrganitation = false;
                          return LocaleData.campoObligatorio.getString(context);
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Información del cuidador
                    _buildSectionTitle(
                      LocaleData.newCuidadorInfoCuidador.getString(context), 
                      Icons.family_restroom
                    ),
                    const SizedBox(height: 16),

                    // Tipo de cuidador
                    Container(
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
                      child: DropdownButtonFormField<TipodeCuidador>(
                        items: TipoCuidadorList.map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(
                            getTranslatedCaregiverType(tipo.TipoCuidadorTabla),
                          ),
                        )).toList(),
                        onChanged: (TipodeCuidador? value) {
                          setState(() {
                            CodTipoCuidador = value!.CodTipoCuidador;
                            if (value.TipoCuidadorTabla == 'Otros') {
                              _showOtherValuePopup(context);
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: LocaleData.newCuidadorTipo.getString(context),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          prefixIcon: Icon(Icons.family_restroom, size: 20, color: colorPrimario),
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
                        validator: (value) {
                          if (value == null) {
                            return LocaleData.newCuidadorSeleccioneTipo.getString(context);
                          }
                          return null;
                        },
                      ),
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
                                _btnActiveEmail && _btnActiveDateBirth) {
                              ContinuaButton(context);
                            }
                          }
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: Text(
                          LocaleData.newCuidadorCrear.getString(context),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            _btnActiveDateBirth = false;
            return LocaleData.campoObligatorio.getString(context);
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: LocaleData.newCuidadorFechaNacimiento.getString(context),
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
        invalidNumberMessage: LocaleData.newCuidadorTelefonoInvalido.getString(context),
        searchText: LocaleData.newCuidadorBuscar.getString(context),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          labelText: LocaleData.newCuidadorTelefono.getString(context),
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
          PhoneNumber = phone.number;
        },
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
              Text(LocaleData.newCuidadorOtros.getString(context)),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: LocaleData.newCuidadorEspecifiqueParentesco.getString(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _DesOtrosTipoCuidadorController.text = '($value)';
            },
          ),
          actions: [
            TextButton(
              child: Text(
                LocaleData.newCuidadorAceptar.getString(context),
                style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
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
            Text(LocaleData.newCuidadorExito.getString(context)),
          ],
        ),
        content: Text(LocaleData.newCuidadorCreado.getString(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CuidadoresViviendaScreen(
                    CodCasa: widget.vivienda.CodCasa,
                    vivienda: widget.vivienda,
                    role: widget.role,
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
              child: Text(
                LocaleData.newCuidadorAceptar.getString(context),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
            Text(LocaleData.newCuidadorError.getString(context)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.newCuidadorAceptar.getString(context),
              style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> ContinuaButton(BuildContext context) async {
    var Password = getRandomString(15);
    var newcuidadorviviendaOk = await DBPostgres().DBNewCuidadorVivienda(
      _NameController.text,
      _Surname1Controller.text,
      _Surname2Controller.text,
      _DateBirthController.text,
      PhoneNumber,
      _EmailController.text,
      _OrganitationController.text,
      CodTipoCuidador,
      Password,
      widget.vivienda.CodCasa,
      _DesOtrosTipoCuidadorController.text,
    );
    if (newcuidadorviviendaOk == true) {
      SendRegistConfirm(_EmailController.text, Password);
      _showSuccessDialog(context);
    } else if (newcuidadorviviendaOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, LocaleData.newCuidadorEmailRegistrado.getString(context));
    } else {
      _showErrorDialog(context, LocaleData.newCuidadorErrorCrear.getString(context));
    }
  }

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );

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
              Text(LocaleData.newCuidadorMenorEdad.getString(context)),
            ],
          ),
          content: Text(LocaleData.newCuidadorMenorEdadMsg.getString(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                LocaleData.newCuidadorCerrar.getString(context),
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

class TipodeCuidador {
  final int CodTipoCuidador;
  final String TipoCuidadorTabla;

  TipodeCuidador(this.CodTipoCuidador, this.TipoCuidadorTabla);
}