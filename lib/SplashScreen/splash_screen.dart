import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ageinplace_admin/SuperAdmin/screen_viviendas.dart';
import 'package:ageinplace_admin/log-in/screen_LogIn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? rol = prefs.getString('rol');

    await Future.delayed(const Duration(seconds: 3));

    // Si está logueado y es un rol administrativo
    if (isLoggedIn && (rol == 'Admin' || rol == 'SuperAdmin')) {
      await _loadUserFromPrefs();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ViviendasScreen(tipoUsuario: rol!.toLowerCase()),
          ),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LogInScreen()),
      );
    }
  }

  Future<void> _loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? codUsuario = prefs.getInt('CodUsuario');
    String? rol = prefs.getString('rol');

    if (codUsuario != null && rol != null) {
      usuario.clear();
      usuario.add(
        Usuario(
          codUsuario,
          '', // Nombre
          '', // Apellido1
          '', // Apellido2
          '', // FechaNacimiento
          '', // Telefono
          '', // Email
          '', // Password
          '', // Organizacion
          rol,
          '', // PasswordValidator
        ),
      );
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Center(
            child: Image.asset(
              'assets/images/Logo1.png', 
              width: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.apps, size: 100, color: Color.fromARGB(255, 25, 144, 234));
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Imp Tracker',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 25, 144, 234),
            ),
          ),
        ],
      ),
    );
  }
}