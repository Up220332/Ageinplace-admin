import 'dart:convert';
import 'dart:math';

import 'package:ageinplace_admin/log-in/screen_LogIn.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../base_de_datos/postgres.dart';

// Definimos la variable global usuario que se usa en el código
List<Usuario> usuario = [];

class ModContrasegnaScreen extends StatefulWidget {
  const ModContrasegnaScreen({super.key});

  @override
  State<ModContrasegnaScreen> createState() => _ModContrasegnaScreenState();
}

class _ModContrasegnaScreenState extends State<ModContrasegnaScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _contrasegnaActualController =
      TextEditingController();
  final TextEditingController _contrasegnaNuevaController =
      TextEditingController();
  final TextEditingController _contrasegnaRepeatController =
      TextEditingController();
  
  bool _btnActiveConstrasegnaActual = false;
  bool _btnActiveNuevaContrasegna = false;
  bool _btnActiveRepeatContrasegna = false;
  
  late bool passwordVisibility = false;
  late bool passwordVisibility1 = false;
  late bool passwordVisibility2 = false;
  
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);
  final _formKey = GlobalKey<FormState>();
  
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  @override
  Widget build(BuildContext context) {
    final isSpanish = FlutterLocalization.instance.currentLocale?.languageCode == 'es';
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
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
          isSpanish ? 'Cambiar Contraseña' : 'Change Password',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 255, 255, 255),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: Image.asset('assets/images/launchScreen@3x.png').image,
              ),
            ),
          ),
          
          // Contenido principal
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.grey.shade50.withOpacity(0.95),
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
                      const SizedBox(height: 20),
                      
                      // Logo
                      Center(
                        child: Image.asset(
                          'assets/images/Logo1.png',
                          width: 100,
                          height: 90,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Center(
                        child: Text(
                          'Imp Tracker',
                          style: GoogleFonts.lato(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorPrimario,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
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
                              Icons.lock_outline,
                              color: colorPrimario,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isSpanish
                                    ? 'Introduzca su contraseña actual y a continuación su nueva contraseña'
                                    : 'Enter your current password and then your new password',
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

                      // Contraseña actual
                      _buildPasswordField(
                        controller: _contrasegnaActualController,
                        label: isSpanish ? 'Contraseña Actual' : 'Current Password',
                        icon: Icons.lock_outline,
                        visibility: passwordVisibility,
                        onVisibilityChanged: () => setState(() => passwordVisibility = !passwordVisibility),
                        onChanged: (value) => setState(() => _btnActiveConstrasegnaActual = value.isNotEmpty),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isSpanish ? 'Campo obligatorio' : 'Required field';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Nueva Contraseña
                      _buildPasswordField(
                        controller: _contrasegnaNuevaController,
                        label: isSpanish ? 'Nueva Contraseña' : 'New Password',
                        icon: Icons.lock_outline,
                        visibility: passwordVisibility1,
                        onVisibilityChanged: () => setState(() => passwordVisibility1 = !passwordVisibility1),
                        onChanged: (value) => setState(() => _btnActiveNuevaContrasegna = value.isNotEmpty),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isSpanish ? 'Campo obligatorio' : 'Required field';
                          }
                          if (value.length < 6) {
                            return isSpanish 
                                ? 'Mínimo 6 caracteres' 
                                : 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Repetir Contraseña
                      _buildPasswordField(
                        controller: _contrasegnaRepeatController,
                        label: isSpanish ? 'Repita Contraseña' : 'Repeat Password',
                        icon: Icons.lock_outline,
                        visibility: passwordVisibility2,
                        onVisibilityChanged: () => setState(() => passwordVisibility2 = !passwordVisibility2),
                        onChanged: (value) => setState(() => _btnActiveRepeatContrasegna = value.isNotEmpty),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isSpanish ? 'Campo obligatorio' : 'Required field';
                          }
                          if (value != _contrasegnaNuevaController.text) {
                            return isSpanish 
                                ? 'Las contraseñas no coinciden' 
                                : 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Botón de actualizar
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var passwordHashActual = sha256
                                  .convert(
                                    utf8.encode(_contrasegnaActualController.text),
                                  )
                                  .toString();
                              
                              if (usuario.isNotEmpty && usuario[0].Password == passwordHashActual) {
                                _enviarButton();
                              } else {
                                _mostrarDialogoError(
                                  context,
                                  isSpanish
                                      ? 'La contraseña actual no es correcta'
                                      : 'Current password is incorrect',
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            isSpanish ? 'Actualizar Contraseña' : 'Update Password',
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

                      const SizedBox(height: 20),

                      // Texto de ayuda
                      Center(
                        child: Text(
                          isSpanish
                              ? 'La contraseña debe tener al menos 6 caracteres'
                              : 'Password must be at least 6 characters',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
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
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool visibility,
    required VoidCallback onVisibilityChanged,
    required Function(String) onChanged,
    required String? Function(String?) validator,
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
        obscureText: !visibility,
        onChanged: onChanged,
        validator: validator,
        style: GoogleFonts.lato(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(icon, size: 20, color: colorPrimario),
          suffixIcon: InkWell(
            onTap: onVisibilityChanged,
            child: Icon(
              visibility
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: Colors.grey.shade500,
            ),
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
      ),
    );
  }

  void _mostrarDialogoError(BuildContext context, String mensaje) {
    final isSpanish = FlutterLocalization.instance.currentLocale?.languageCode == 'es';
    
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
            Text(isSpanish ? 'Error' : 'Error'),
          ],
        ),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colorPrimario,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isSpanish ? 'Aceptar' : 'OK',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoExito(BuildContext context) {
    final isSpanish = FlutterLocalization.instance.currentLocale?.languageCode == 'es';
    
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
            Text(isSpanish ? 'Éxito' : 'Success'),
          ],
        ),
        content: Text(
          isSpanish
              ? 'Contraseña actualizada correctamente'
              : 'Password updated successfully',
        ),
        actions: <Widget>[
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
                isSpanish ? 'Aceptar' : 'OK',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoUsuarioNoEncontrado(BuildContext context) {
    final isSpanish = FlutterLocalization.instance.currentLocale?.languageCode == 'es';
    
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
            Text(isSpanish ? 'Error' : 'Error'),
          ],
        ),
        content: Text(
          isSpanish
              ? 'Usuario no encontrado'
              : 'User not found',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LogInScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colorPrimario,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isSpanish ? 'Aceptar' : 'OK',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enviarButton() async {
    final isSpanish = FlutterLocalization.instance.currentLocale?.languageCode == 'es';
    
    var newuserOk = await DBPostgres().DBModPassword(
      usuario[0].Email,
      _contrasegnaNuevaController.text,
    );
    
    if (newuserOk == 'correcto') {
      _mostrarDialogoExito(context);
    } else if (newuserOk == 'incorrecto') {
      _mostrarDialogoUsuarioNoEncontrado(context);
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
}

// --- MODELOS DE DATOS NECESARIOS ---
class Usuario {
  final int CodUsuario;
  final String Email;
  final String Password;
  final String TipoUsuario;
  final DateTime? F_Confirmacion;
  final String? Token;
  final DateTime? F_Alta;
  final DateTime? F_Baja;
  final String? Nombre;
  final String? Apellido1;
  final String? Apellido2;
  final String? Telefono;
  final String? Organizacion;

  Usuario(
    this.CodUsuario,
    this.Email,
    this.Password,
    this.TipoUsuario,
    this.F_Confirmacion,
    this.Token,
    this.F_Alta,
    this.F_Baja,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.Telefono,
    this.Organizacion,
  );
}