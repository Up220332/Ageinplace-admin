import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/E-MailSender/E-MailSend.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_NewAdmin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_administradoresInact.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../SuperAdmin/screen_ModAdmin.dart';
import '../base_de_datos/postgres.dart';
import '../localization/locales.dart';

/// *****************************************************************************
/// Funcion que muestra todos los administradores activos en una lista.
///****************************************************************************
class AdminitradoresScreen extends StatefulWidget {
  const AdminitradoresScreen({super.key});

  @override
  State<AdminitradoresScreen> createState() => _AdminitradoresScreenSate();
}

class _AdminitradoresScreenSate extends State<AdminitradoresScreen> {
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
      (Estado) => Estado.Estado == 'Activo',
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

    return Scaffold(
      floatingActionButton: _buildFloatingActionButtons(context),
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
          LocaleData.adminTitulo.getString(context),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
                        LocaleData.adminNoHayActivos.getString(context),
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleData.adminAnade.getString(context),
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
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewAdminScreen()),
            ),
            label: Text(
              LocaleData.adminAgregar.getString(context),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            backgroundColor: colorPrimario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminitradoresInactScreen(),
              ),
            ),
            backgroundColor: Colors.red,
            label: Text(
              LocaleData.adminInactivos.getString(context),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.visibility_outlined, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
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
              return Administradores(admin: admin);
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
              // Avatar con iniciales
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPrimario.withOpacity(0.8),
                      colorPrimario,
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
              
              // Fecha y estado
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      LocaleData.adminActivo.getString(context),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDate(admin.F_ALTA, [dd, '/', mm, '/', yyyy]),
                    style: TextStyle(
                      fontSize: 12,
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
/// Modal para mostrar los datos del administrador.
///****************************************************************************
class Administradores extends StatelessWidget {
  final Admin admin;
  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  Administradores({super.key, required this.admin});

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
            
            // Avatar grande
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPrimario.withOpacity(0.8),
                      colorPrimario,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${admin.Nombre[0]}${admin.Apellido1[0]}',
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
              '${admin.Nombre} ${admin.Apellido1} ${admin.Apellido2}',
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
              value: admin.Email,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.phone,
              label: LocaleData.adminTelefono.getString(context),
              value: admin.Telefono,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.cake,
              label: LocaleData.adminFechaNacimiento.getString(context),
              value: admin.FechaNacimiento,
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.calendar_today,
              label: LocaleData.adminFechaAlta.getString(context),
              value: formatDate(admin.F_ALTA, [dd, '/', mm, '/', yyyy]),
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.business,
              label: LocaleData.adminOrganizacion.getString(context),
              value: admin.Organizacion,
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
                      color: (admin.Estado == 'Activo')
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      admin.Estado == 'Activo' ? Icons.check_circle : Icons.cancel,
                      color: admin.Estado == 'Activo' ? Colors.green : Colors.red,
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
                    admin.Estado == 'Activo' 
                        ? LocaleData.adminActivo.getString(context)
                        : LocaleData.adminInactivo.getString(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: admin.Estado == 'Activo' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: admin.Estado == 'Activo' 
                        ? LocaleData.adminDesactivar.getString(context)
                        : LocaleData.adminActivar.getString(context),
                    icon: admin.Estado == 'Activo' ? Icons.block : Icons.check_circle,
                    color: admin.Estado == 'Activo' ? Colors.red : Colors.green,
                    onPressed: () async {
                      switch (admin.Estado) {
                        case 'Activo':
                          if (await DBPostgres().DBActDesActAdmin(
                                admin.CodUsuario,
                                'CURRENT_TIMESTAMP',
                              ) ==
                              'Correcto') {
                            SendBaja(admin.Email);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminitradoresScreen(),
                                ),
                              );
                            }
                          }
                          break;
                        case 'Inactivo':
                          if (await DBPostgres().DBActDesActAdmin(
                                admin.CodUsuario,
                                null,
                              ) ==
                              'Correcto') {
                            SendAlta(admin.Email);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminitradoresScreen(),
                                ),
                              );
                            }
                          }
                          break;
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: LocaleData.adminModificar.getString(context),
                    icon: Icons.edit,
                    color: colorPrimario,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModAdminScreen(admin: admin),
                        ),
                      );
                    },
                  ),
                ),
              ],
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

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
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