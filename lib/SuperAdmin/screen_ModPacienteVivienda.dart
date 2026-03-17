import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../base_de_datos/postgres.dart';
import '../localization/locales.dart';
import '../SuperAdmin/screen_PacientesVivienda.dart';
import '../SuperAdmin/screen_viviendas.dart';

class ModPacienteViviendaScreen extends StatefulWidget {
  final String role;
  final Vivienda vivienda;
  final Paciente paciente;

  const ModPacienteViviendaScreen({
    super.key,
    required this.vivienda,
    required this.paciente,
    required this.role,
  });

  @override
  State<ModPacienteViviendaScreen> createState() => _ModPacienteScreenSate();
}

class _ModPacienteScreenSate extends State<ModPacienteViviendaScreen> {
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
    _DesOtrosSanitariaController.text = widget.paciente.DesVarSanitaria;
    _DesOtrosSocialController.text = widget.paciente.DesVarSocial;
    CodVarSocialList = listaVariablesSociales;
    CodVarSanitariaList = listaVariablesSanitaria;
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
        key: scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 117, 105, 105),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: colorPrimario,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            LocaleData.modPacienteTitulo.getString(context),
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
                    _buildHeader(context),
                    
                    const SizedBox(height: 24),
                    
                    // Información personal
                    _buildSectionTitle(
                      LocaleData.modPacienteInfoPersonal.getString(context), 
                      Icons.person
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _NameController,
                      label: LocaleData.modPacienteNombre.getString(context),
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
                            label: LocaleData.modPacientePrimerApellido.getString(context),
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
                            label: LocaleData.modPacienteSegundoApellido.getString(context),
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
                      LocaleData.modPacienteInfoContacto.getString(context), 
                      Icons.contact_mail
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: _EmailController,
                      label: LocaleData.modPacienteEmail.getString(context),
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
                          return LocaleData.modPacienteEmailInvalido.getString(context);
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildPhoneField(context),
                    
                    const SizedBox(height: 12),
                    
                    _buildTextField(
                      controller: _OrganitationController,
                      label: LocaleData.modPacienteOrganizacion.getString(context),
                      icon: Icons.business,
                      onChanged: (value) {},
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Variables sociales y sanitarias
                    _buildSectionTitle(
                      LocaleData.modPacienteVariables.getString(context), 
                      Icons.health_and_safety
                    ),
                    const SizedBox(height: 16),
                    
                    _buildMultiSelectField(
                      context,
                      title: LocaleData.modPacienteVariablesSociales.getString(context),
                      items: VariableSocialList.map((item) {
                        return MultiSelectItem(
                          item.CodVariableSocial,
                          translationsVarSocial[item.VariableSocial] ?? item.VariableSocial,
                        );
                      }).toList(),
                      initialValue: CodVarSocialList,
                      onConfirm: (results) {
                        setState(() {
                          CodVarSocialList = results.cast<int>();
                          if (CodVarSocialList.contains(0)) {
                            _showOtrosSocialValuePopup(context);
                          }
                        });
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildMultiSelectField(
                      context,
                      title: LocaleData.modPacienteVariablesSanitarias.getString(context),
                      items: VariableSanitariaList.map((item) {
                        return MultiSelectItem(
                          item.CodVariableSanitaria,
                          translationsVarSanitaria[item.VariableSanitaria] ?? item.VariableSanitaria,
                        );
                      }).toList(),
                      initialValue: CodVarSanitariaList,
                      onConfirm: (results) {
                        setState(() {
                          CodVarSanitariaList = results.cast<int>();
                          if (CodVarSanitariaList.contains(0)) {
                            _showOtrosSanitarioValuePopup(context);
                          }
                        });
                      },
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
              LocaleData.modPacienteHeader.getString(context),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
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
          labelText: LocaleData.modPacienteFechaNacimiento.getString(context),
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
        invalidNumberMessage: LocaleData.modPacienteTelefonoInvalido.getString(context),
        searchText: LocaleData.modPacienteBuscar.getString(context),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          labelText: LocaleData.modPacienteTelefono.getString(context),
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

  Widget _buildMultiSelectField(
    BuildContext context, {
    required String title,
    required List<MultiSelectItem> items,
    required List<int> initialValue,
    required Function(List<dynamic>) onConfirm,
  }) {
    return Container(
      height: 65,
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
        initialValue: initialValue,
        items: items,
        title: Text(title),
        selectedColor: colorPrimario,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        buttonText: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        buttonIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey.shade600,
        ),
        onConfirm: onConfirm,
        chipDisplay: MultiSelectChipDisplay.none(),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ContinuaButton(context);
          }
        },
        icon: const Icon(Icons.save, color: Colors.white),
        label: Text(
          LocaleData.modPacienteGuardar.getString(context),
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
            Text(LocaleData.modPacienteError.getString(context)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleData.modPacienteAceptar.getString(context),
              style: TextStyle(color: colorPrimario, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
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
            Text(LocaleData.modPacienteExito.getString(context)),
          ],
        ),
        content: Text(LocaleData.modPacienteModificado.getString(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PacientesViviendaScreen(
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
                LocaleData.modPacienteAceptar.getString(context),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> ContinuaButton(BuildContext context) async {
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
      _showSuccessDialog(context);
    } else if (newpacienteOk.toString().contains('Ya existe la llave')) {
      _showErrorDialog(context, LocaleData.modPacienteEmailRegistrado.getString(context));
    } else {
      _showErrorDialog(context, LocaleData.modPacienteErrorModificar.getString(context));
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
              Text(LocaleData.modPacientePatologia.getString(context)),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: LocaleData.modPacienteEspecifiquePatologia.getString(context),
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
                LocaleData.modPacienteAceptar.getString(context),
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
              Text(LocaleData.modPacienteVariableSocial.getString(context)),
            ],
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: LocaleData.modPacienteEspecifiqueVariable.getString(context),
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
                LocaleData.modPacienteAceptar.getString(context),
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