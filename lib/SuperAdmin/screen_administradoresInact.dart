import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/E-MailSender/E-MailSend.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../SuperAdmin/screen_administradores.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

/// *****************************************************************************
/// Funcion que muestra todos los administradores inactivos en una lista.
///****************************************************************************
class AdminitradoresInactScreen extends StatefulWidget {
  const AdminitradoresInactScreen({super.key});

  @override
  State<AdminitradoresInactScreen> createState() =>
      _AdminitradoresInactScreenSate();
}

class _AdminitradoresInactScreenSate extends State<AdminitradoresInactScreen> {
  List<Admin> AdminList = [];
  List Filtro_Status = [];
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  Future<String> getData() async {
    var Dbdata = await DBPostgres().DBGetAdmin();
    String Estado;
    setState(() {
      for (var p in Dbdata) {
        if (p[9] == null) {
          Estado = 'Activo';
        } else {
          Estado = 'Inactivo';
        }
        AdminList.add(
          Admin(
            p[0],
            p[1],
            p[2],
            p[3],
            p[4],
            p[5],
            p[6],
            p[7],
            p[8],
            p[9],
            Estado,
          ),
        );
      }
    });
    Filtro_Status = AdminList.where(
      (Estado) => Estado.Estado == 'Inactivo',
    ).toList();
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    AdminList.sort((a, b) => a.F_ALTA.compareTo(b.F_ALTA));

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AdminitradoresScreen())
        );
        return false;
      },
      child: Scaffold(
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
            LocaleData.adminInactivosTitulo.getString(context),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        endDrawer: NavBarSuperAdmin(),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Filtro_Status.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          LocaleData.adminNoHayInactivos.getString(context),
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleData.adminInactivosDescripcion.getString(context),
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: Filtro_Status.length,
                    itemBuilder: (context, index) {
                      return _buildAdminCard(context, index);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, int index) {
    final admin = Filtro_Status[index];
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return Administradores(
                Nombre: admin.Nombre,
                Apellido1: admin.Apellido1,
                Apellido2: admin.Apellido2,
                Email: admin.Email,
                Telefono: admin.Telefono,
                FechaNacimiento: admin.FechaNacimiento,
                Organizacion: admin.Organizacion,
                CodUsuario: admin.CodUsuario,
                Estado: admin.Estado,
                F_ALTA: admin.F_ALTA,
                F_BAJA: admin.F_BAJA,
              );
            },
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar con iniciales (en rojo para inactivos)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.7),
                      Colors.red,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    '${admin.Nombre[0]}${admin.Apellido1[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Información del administrador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${admin.Nombre} ${admin.Apellido1} ${admin.Apellido2}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            admin.Email,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.business_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          admin.Organizacion,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Fecha y estado INACTIVO
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      LocaleData.adminInactivo.getString(context),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (admin.F_BAJA != null)
                    Text(
                      '${LocaleData.adminFechaBaja.getString(context)}: ${formatDate(admin.F_BAJA!, [dd, '/', mm, '/', yyyy])}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// *****************************************************************************
/// Modal para mostrar los datos del administrador inactivo.
///****************************************************************************
class Administradores extends StatelessWidget {
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String Email;
  final String Organizacion;
  final String FechaNacimiento;
  final int CodUsuario;
  final String Telefono;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Estado;

  const Administradores({
    super.key,
    required this.Nombre,
    required this.Apellido1,
    required this.Apellido2,
    required this.Email,
    required this.Organizacion,
    required this.FechaNacimiento,
    required this.CodUsuario,
    required this.Telefono,
    required this.F_ALTA,
    required this.F_BAJA,
    required this.Estado,
  });

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de arrastre
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Avatar grande (en rojo para inactivo)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.7),
                      Colors.red,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${Nombre[0]}${Apellido1[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nombre completo
            Text(
              '$Nombre $Apellido1 $Apellido2',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B3C),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información en tarjetas
            _buildInfoCard(
              context,
              icon: Icons.email,
              label: LocaleData.adminEmail.getString(context),
              value: Email,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.phone,
              label: LocaleData.adminTelefono.getString(context),
              value: Telefono,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.cake,
              label: LocaleData.adminFechaNacimiento.getString(context),
              value: FechaNacimiento,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.calendar_today,
              label: LocaleData.adminFechaAlta.getString(context),
              value: formatDate(F_ALTA, [dd, '/', mm, '/', yyyy]),
            ),
            
            const SizedBox(height: 12),
            
            if (F_BAJA != null)
              _buildInfoCard(
                context,
                icon: Icons.calendar_today_outlined,
                label: LocaleData.adminFechaBaja.getString(context),
                value: formatDate(F_BAJA!, [dd, '/', mm, '/', yyyy]),
              ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.business,
              label: LocaleData.adminOrganizacion.getString(context),
              value: Organizacion,
            ),
            
            const SizedBox(height: 12),
            
            // Estado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${LocaleData.adminEstado.getString(context)}:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleData.adminInactivo.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botón de activar
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (await DBPostgres().DBActDesActAdmin(CodUsuario, null) == 'Correcto') {
                    SendAlta(Email);
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminitradoresScreen(),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: Text(
                  LocaleData.adminActivarAdministrador.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorPrimario.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: colorPrimario),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A2B3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Admin {
  final int CodUsuario;
  final String Nombre;
  final String Apellido1;
  final String Apellido2;
  final String FechaNacimiento;
  final String Telefono;
  final String Email;
  final String Organizacion;
  final DateTime F_ALTA;
  final DateTime? F_BAJA;
  final String Estado;

  Admin(
    this.CodUsuario,
    this.Nombre,
    this.Apellido1,
    this.Apellido2,
    this.FechaNacimiento,
    this.Telefono,
    this.Email,
    this.Organizacion,
    this.F_ALTA,
    this.F_BAJA,
    this.Estado,
  );
}