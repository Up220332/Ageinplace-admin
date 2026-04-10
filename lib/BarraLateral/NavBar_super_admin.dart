import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SuperAdmin/screen_Cuidadores.dart';
import '../SuperAdmin/screen_ModUserAdmin.dart';
import '../SuperAdmin/screen_Pacientes.dart';
import '../SuperAdmin/screen_TipoCuidador.dart';
import '../SuperAdmin/screen_TipoHabitacion.dart';
import '../SuperAdmin/screen_TipoSensor.dart';
import '../SuperAdmin/screen_TipoWearable.dart';
import '../SuperAdmin/screen_TodoSensores.dart';
import '../SuperAdmin/screen_TodoWearables.dart';
import '../SuperAdmin/screen_VariablesSanitaria.dart';
import '../SuperAdmin/screen_VariablesSociales.dart';
import '../SuperAdmin/screen_administradores.dart';
import '../SuperAdmin/screen_questions.dart';
import '../SuperAdmin/screen_viviendas.dart';
import '../localization/locales.dart';
import '../log-in/screen_LogIn.dart';

class NavBarSuperAdmin extends StatefulWidget {
  const NavBarSuperAdmin({super.key});

  @override
  _NavBarSuperAdminState createState() => _NavBarSuperAdminState();
}

class _NavBarSuperAdminState extends State<NavBarSuperAdmin> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale?.languageCode ?? 'es';

    _flutterLocalization.onTranslatedLanguage = _onTranslatedLanguage;
  }

  void _onTranslatedLanguage(Locale? locale) {
    if (mounted) {
      setState(() {
        _currentLocale = locale?.languageCode ?? 'es';
      });
    }
  }

  void _setLocale(String languageCode) {
    _flutterLocalization.translate(languageCode);
    setState(() {
      _currentLocale = languageCode;
    });
  }

  @override
  void dispose() {
    // NO poner null el listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSpanish = _currentLocale == 'es';

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header con gradiente
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorPrimario, colorPrimario.withOpacity(0.8)],
                ),
              ),
              child: SizedBox(
                height: 200,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: ClipRRect(
                          child: Image.asset(
                            'assets/images/Logo2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Imp Tracker',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          isSpanish ? 'Super Admin' : 'Super Admin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Gestión de Viviendas
            _buildMenuItem(
              icon: Icons.home,
              label: isSpanish ? 'Gestión de Viviendas' : 'Housing Management',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViviendasScreen(tipoUsuario: 'superadmin'),
                ),
              ),
            ),

            // Gestión de Administradores
            _buildMenuItem(
              icon: Icons.person,
              label: isSpanish ? 'Gestión de Administradores' : 'Admins Management',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminitradoresScreen(),
                ),
              ),
            ),

            // Gestión de Wearables
            _buildMenuItem(
              icon: Icons.watch,
              label: isSpanish ? 'Gestión de Wearables' : 'Wearables Management',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoWearablesScreen(),
                ),
              ),
            ),

            // Gestión de Sensores
            _buildMenuItem(
              icon: Icons.sensors,
              label: isSpanish ? 'Gestión de Sensores' : 'Sensors Management',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoSensoresScreen(),
                ),
              ),
            ),

            const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),

            // Gestión de Variables (ExpansionTile)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorPrimario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.article, color: colorPrimario, size: 20),
                ),
                title: Text(
                  isSpanish ? 'Gestión de Variables' : 'Variables Management',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                iconColor: colorPrimario,
                collapsedIconColor: colorPrimario,
                children: <Widget>[
                  // Gestión de preguntas
                  _buildSubMenuItem(
                    icon: Icons.help_outline,
                    label: isSpanish ? 'Gestión de Preguntas' : 'Questions Management',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenQuestions(),
                      ),
                    ),
                  ),
                  
                  // Variables Sanitarias
                  _buildSubMenuItem(
                    icon: Icons.health_and_safety,
                    label: isSpanish ? 'Variables Sanitarias' : 'Health Variables',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VariableSanitariaScreen(),
                      ),
                    ),
                  ),
                  
                  // Variables Sociales
                  _buildSubMenuItem(
                    icon: Icons.people,
                    label: isSpanish ? 'Variables Sociales' : 'Social Variables',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VariableSocialScreen(),
                      ),
                    ),
                  ),
                  
                  // Tipo de Cuidador
                  _buildSubMenuItem(
                    icon: Icons.person_outline,
                    label: isSpanish ? 'Tipo de Cuidador' : 'Caregiver Type',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TipoCuidadorScreen(),
                      ),
                    ),
                  ),
                  
                  // Tipo de Wearable
                  _buildSubMenuItem(
                    icon: Icons.watch,
                    label: isSpanish ? 'Tipo de Wearable' : 'Wearable Type',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TipoWearableScreen(),
                      ),
                    ),
                  ),
                  
                  // Tipo de Sensor
                  _buildSubMenuItem(
                    icon: Icons.sensors,
                    label: isSpanish ? 'Tipo de Sensor' : 'Sensor Type',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TipoSensorScreen(),
                      ),
                    ),
                  ),
                  
                  // Tipo de Habitación
                  _buildSubMenuItem(
                    icon: Icons.meeting_room,
                    label: isSpanish ? 'Tipo de Habitación' : 'Room Type',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TipoHabitacionScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de Cuidadores
            _buildMenuItem(
              icon: Icons.groups,
              label: isSpanish ? 'Lista de Cuidadores' : 'Caregivers List',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CuidadoresScreen(role: 'superadmin'),
                ),
              ),
            ),

            // Lista de Pacientes
            _buildMenuItem(
              icon: Icons.elderly,
              label: isSpanish ? 'Lista de Pacientes' : 'Patients List',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PacientesScreen(role: 'superadmin'),
                ),
              ),
            ),

            const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),

            // Configuración (menú desplegable)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorPrimario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.settings, color: colorPrimario, size: 20),
                ),
                title: Text(
                  isSpanish ? 'Configuración' : 'Settings',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                iconColor: colorPrimario,
                collapsedIconColor: colorPrimario,
                children: <Widget>[
                  // Modificar Datos
                  _buildSubMenuItem(
                    icon: Icons.edit,
                    label: isSpanish ? 'Modificar datos' : 'Edit data',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModUserAdminScreen(),
                      ),
                    ),
                  ),
                  
                  // Cambiar idioma
                  _buildSubMenuItem(
                    icon: Icons.language,
                    label: isSpanish ? 'Cambiar idioma' : 'Change language',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return StatefulBuilder(
                            builder: (context, setStateDialog) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.language, color: colorPrimario),
                                    const SizedBox(width: 10),
                                    Text(
                                      isSpanish ? 'Seleccionar idioma' : 'Select language',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: SizedBox(
                                  width: double.minPositive,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Español'),
                                        trailing: _currentLocale == 'es'
                                            ? Icon(
                                                Icons.check_circle,
                                                color: colorPrimario,
                                              )
                                            : null,
                                        onTap: () {
                                          _setLocale('es');
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                      const Divider(),
                                      ListTile(
                                        title: const Text('English'),
                                        trailing: _currentLocale == 'en'
                                            ? Icon(
                                                Icons.check_circle,
                                                color: colorPrimario,
                                              )
                                            : null,
                                        onTap: () {
                                          _setLocale('en');
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Cerrar sesión
            _buildMenuItem(
              icon: Icons.logout,
              label: isSpanish ? 'Cerrar sesión' : 'Logout',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.red),
                          const SizedBox(width: 10),
                          Text(
                            isSpanish ? 'Cerrar sesión' : 'Logout',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      content: Text(
                        isSpanish
                            ? '¿Estás seguro de que deseas cerrar sesión?'
                            : 'Are you sure you want to logout?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isSpanish ? 'Cancelar' : 'Cancel',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();
                            Navigator.of(dialogContext).pop();
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isSpanish ? 'Sí, cerrar sesión' : 'Yes, logout',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = const Color.fromARGB(255, 25, 144, 234),
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 18, color: colorPrimario),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
      contentPadding: const EdgeInsets.only(left: 50),
      onTap: onTap,
    );
  }
}