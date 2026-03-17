import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../base_de_datos/postgres.dart';
import '../SuperAdmin/screen_Pacientes.dart';

class ModPacienteScreen extends StatefulWidget {
  final String role;
  final Pacientes paciente;

  const ModPacienteScreen({
    super.key,
    required this.paciente,
    required this.role,
  });

  @override
  State<ModPacienteScreen> createState() => _ModPacienteScreenState();
}

class _ModPacienteScreenState extends State<ModPacienteScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _Surname1Controller = TextEditingController();
  final TextEditingController _Surname2Controller = TextEditingController();
  final TextEditingController _DateBirthController = TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _OrganitationController = TextEditingController();
  final TextEditingController _DesOtrosSanitariaController =
      TextEditingController();
  final TextEditingController _DesOtrosSocialController =
      TextEditingController();
  
  List<int> CodVarSanitariaList = [];
  List<int> CodVarSocialList = [];
  final listaVariablesSociales = <int>[];
  final listaVariablesSanitaria = <int>[];

  late String PhoneNumber = '';
  bool _btnActiveName = true;
  bool _btnActiveSurname1 = true;
  bool _btnActiveDateBirth = true;
  bool _btnActiveEmail = true;

  List<VariablesSociales> VariableSocialList = [];
  List<VariablesSanitarias> VariableSanitariaList = [];

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Modificar Paciente',
      'header': 'Modifique los datos del paciente',
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
      'variables_paciente': 'VARIABLES DEL PACIENTE',
      'variables_sociales': 'Variables Sociales',
      'variables_sanitarias': 'Variables Sanitarias',
      'guardar': 'Guardar Cambios',
      'campo_obligatorio': 'Campo obligatorio',
      'obligatorio': 'Obligatorio',
      'exito': 'Éxito',
      'modificado': 'Paciente modificado correctamente',
      'error': 'Error',
      'aceptar': 'Aceptar',
      'email_registrado': 'El correo electrónico ya está registrado',
      'error_modificar': 'Error al modificar el paciente',
      'patologia': 'Patología',
      'especifique_patologia': 'Especifique la patología',
      'variable_social': 'Variable Social',
      'especifique_variable': 'Especifique la variable social',
    },
    'en': {
      'titulo': 'Edit Patient',
      'header': 'Modify the patient data',
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
      'variables_paciente': 'PATIENT VARIABLES',
      'variables_sociales': 'Social Variables',
      'variables_sanitarias': 'Health Variables',
      'guardar': 'Save Changes',
      'campo_obligatorio': 'Required field',
      'obligatorio': 'Required',
      'exito': 'Success',
      'modificado': 'Patient modified successfully',
      'error': 'Error',
      'aceptar': 'Accept',
      'email_registrado': 'Email is already registered',
      'error_modificar': 'Error modifying patient',
      'patologia': 'Pathology',
      'especifique_patologia': 'Specify the pathology',
      'variable_social': 'Social Variable',
      'especifique_variable': 'Specify the social variable',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Map<String, String> translationsVarSocial = {
    "Autónomo": "Autonomous",
    "Dependiente grave": "Severely Dependent",
    "Dependiente leve": "Mildly Dependent",
    "Riesgo aislamiento": "Isolation Risk",
    "Tensiones económicas": "Economic Tensions",
    "Con red social de apoyo": "With Social Support Network",
    "Red social apoyo reducida": "Reduced Social Support Network",
    "Sin red social de apoyo": "Without Social Support Network",
    "Otros": "Others",
  };

  Map<String, String> translationsVarSanitaria = {
    "Adicciones": "Addictions",
    "Alzheimer": "Alzheimer",
    "Anemia": "Anemia",
    "Ansiedad": "Anxiety",
    "Artrosis": "Osteoarthritis",
    "Cáncer": "Cancer",
    "Demencia": "Dementia",
    "Depresion": "Depression",
    "Diabetes": "Diabetes",
    "Esquizofrenia": "Schizophrenia",
    "Fragilidad": "Frailty",
    "Hipertensión": "Hypertension",
    "Ictus": "Stroke",
    "Incontinencia Urinaria": "Urinary Incontinence",
    "Infarto": "Heart Attack",
    "Osteoporosis": "Osteoporosis",
    "Parkinson": "Parkinson's",
    "Problemas auditivos": "Hearing Problems",
    "Problemas visuales": "Visual Problems",
    "Sano": "Healthy",
    "Trastornos de sueño": "Sleep Disorders",
    "Trastornos mentales": "Mental Disorders",
    "Otros": "Others",
  };

  // Función para obtener el nombre traducido de la variable social
  String getTranslatedSocialVar(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsVarSocial[original] ?? original;
    }
    return original;
  }

  // Función para obtener el nombre traducido de la variable sanitaria
  String getTranslatedSanitariaVar(String original) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (currentLocale == 'en') {
      return translationsVarSanitaria[original] ?? original;
    }
    return original;
  }

  Future<String> getVariableSanitaria() async {
    var Dbdata = await DBPostgres().DBGetVariableSanitarias();
    setState(() {
      for (var p in Dbdata) {
        VariableSanitariaList.add(VariablesSanitarias(p[0], p[1]));
      }
    });
    return 'Successfully Fetched data';
  }

  Future<String> getVariableSocial() async {
    var Dbdata = await DBPostgres().DBGetVariableSocial();
    setState(() {
      for (var p in Dbdata) {
        VariableSocialList.add(VariablesSociales(p[0], p[1]));
      }
    });
    return 'Successfully Fetched data';
  }

  Future<String> getVariablesPaciente() async {
    var Dbdata = await DBPostgres().DBGetVariablePaciente(
      widget.paciente.CodUsuario,
    );
    setState(() {
      for (final row in Dbdata[0]) {
        final codVariableSocial = row[0] as int;
        listaVariablesSociales.add(codVariableSocial);
      }
      for (final row in Dbdata[1]) {
        final codVariableSanitaria = row[0] as int;
        listaVariablesSanitaria.add(codVariableSanitaria);
      }
    });
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getVariableSanitaria();
    getVariableSocial();
    getVariablesPaciente();
    _NameController.text = widget.paciente.Nombre;
    _Surname1Controller.text = widget.paciente.Apellido1;
    _Surname2Controller.text = widget.paciente.Apellido2;
    _DateBirthController.text = widget.paciente.FechaNacimiento;
    _PhoneNumberController.text = widget.paciente.Telefono;
    _EmailController.text = widget.paciente.Email;
    _OrganitationController.text = widget.paciente.Organizacion;
    CodVarSocialList = listaVariablesSociales;
    CodVarSanitariaList = listaVariablesSanitaria;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PacientesScreen(role: widget.role),
          ),
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: colorPrimario,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            t('titulo'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
                            Icons.elderly,
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

                    // Fecha de nacimiento
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

                    const SizedBox(height: 24),

                    // Variables del paciente
                    _buildSectionTitle(t('variables_paciente'), Icons.health_and_safety),
                    const SizedBox(height: 16),

                    // Variables Sociales
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
                      child: MultiSelectDialogField(
                        initialValue: CodVarSocialList.toList(),
                        items: VariableSocialList.map((item) {
                          return MultiSelectItem(
                            item.CodVariableSocial,
                            getTranslatedSocialVar(item.VariableSocial),
                          );
                        }).toList(),
                        title: Text(t('variables_sociales')),
                        selectedColor: colorPrimario,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        buttonText: Text(
                          t('variables_sociales'),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        buttonIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                        ),
                        onConfirm: (results) {
                          setState(() {
                            CodVarSocialList = results.cast<int>();
                            if (CodVarSocialList.contains(0)) {
                              _showOtrosSocialValuePopup(context);
                            }
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay.none(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Variables Sanitarias
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
                      child: MultiSelectDialogField(
                        listType: MultiSelectListType.LIST,
                        initialValue: CodVarSanitariaList.toList(),
                        items: VariableSanitariaList.map((item) {
                          return MultiSelectItem(
                            item.CodVariableSanitaria,
                            getTranslatedSanitariaVar(item.VariableSanitaria),
                          );
                        }).toList(),
                        title: Text(t('variables_sanitarias')),
                        selectedColor: colorPrimario,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        buttonText: Text(
                          t('variables_sanitarias'),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        buttonIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                        ),
                        onConfirm: (results) {
                          setState(() {
                            CodVarSanitariaList = results.cast<int>();
                            if (CodVarSanitariaList.contains(0)) {
                              _showOtrosSanitarioValuePopup(context);
                            }
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay.none(),
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
        searchText: t('buscar'),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          labelText: t('telefono'),
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
                  builder: (context) => PacientesScreen(role: widget.role),
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
    var newpacienteOk = await DBPostgres().DBModPaciente(
      widget.paciente.CodUsuario,
      _NameController.text,
      _Surname1Controller.text,
      _Surname2Controller.text,
      _DateBirthController.text,
      PhoneNumber,
      _EmailController.text,
      _OrganitationController.text,
      CodVarSanitariaList,
      CodVarSocialList,
      _DesOtrosSanitariaController.text,
      _DesOtrosSocialController.text,
    );
    if (newpacienteOk == true) {
      _showSuccessDialog();
    } else if (newpacienteOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(t('email_registrado'));
    } else {
      _showErrorDialog(t('error_modificar'));
    }
  }

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

    if (newDate != null) {
      setState(() {
        _DateBirthController.text = DateFormat('dd/MM/yyyy').format(newDate);
      });
    }
  }

  void _showOtrosSanitarioValuePopup(BuildContext context) {
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
              Text(t('patologia')),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: t('especifique_patologia'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _DesOtrosSanitariaController.text = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                t('aceptar'),
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

  void _showOtrosSocialValuePopup(BuildContext context) {
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
              Text(t('variable_social')),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: t('especifique_variable'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _DesOtrosSocialController.text = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                t('aceptar'),
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
}

class VariablesSociales {
  final int CodVariableSocial;
  final String VariableSocial;

  VariablesSociales(this.CodVariableSocial, this.VariableSocial);
}

class VariablesSanitarias {
  final int CodVariableSanitaria;
  final String VariableSanitaria;

  VariablesSanitarias(this.CodVariableSanitaria, this.VariableSanitaria);
}