import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

/// *****************************************************************************
/// Screen que devuelve todos los sensores que existen y estan inactivos
///****************************************************************************

class ScreenInactiveQuestions extends StatefulWidget {
  const ScreenInactiveQuestions({super.key});

  @override
  State<ScreenInactiveQuestions> createState() =>
      _ScreenInactiveQuestionsState();
}

class _ScreenInactiveQuestionsState extends State<ScreenInactiveQuestions> {
  List<Question> inactiveQuestionsList = [];

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Preguntas inactivas',
      'no_hay': 'No hay preguntas inactivas',
      'pregunta_inactiva': 'Pregunta inactiva',
      'confirmar_reactivar': '¿Desea reactivar la pregunta?',
      'aceptar': 'Aceptar',
      'cancelar': 'Cancelar',
      'activada': 'Pregunta activada correctamente',
      'error_activar': 'Error al activar la pregunta',
      'fecha_baja': 'Fecha de baja',
      'cargando': 'Cargando...',
      'inactivo': 'Inactivo',
    },
    'en': {
      'titulo': 'Inactive Questions',
      'no_hay': 'No inactive questions',
      'pregunta_inactiva': 'Inactive Question',
      'confirmar_reactivar': 'Do you want to reactivate the question?',
      'aceptar': 'Accept',
      'cancelar': 'Cancel',
      'activada': 'Question activated successfully',
      'error_activar': 'Error activating question',
      'fecha_baja': 'Deactivation date',
      'cargando': 'Loading...',
      'inactivo': 'Inactive',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Future<String> getData() async {
    final data = await DBPostgres().DBGetInactiveQuestions();

    if (data is List) {
      setState(() {
        inactiveQuestionsList = data.map((row) {
          return Question(row[0], row[1], row[2], row[3]);
        }).toList();
      });
    } else {
      print('Error al obtener las preguntas inactivas: $data');
    }

    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          t('titulo'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
        child: inactiveQuestionsList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      t('no_hay'),
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: inactiveQuestionsList.length,
                  itemBuilder: (context, index) {
                    final question = inactiveQuestionsList[index];
                    return _buildQuestionCard(context, question, index);
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, Question question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.help_outline, color: colorPrimario),
                      const SizedBox(width: 10),
                      Text(t('pregunta_inactiva')),
                    ],
                  ),
                  content: Text(t('confirmar_reactivar')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t('cancelar'),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await DBPostgres().DBActivateQuestion(
                            question.codQuestion,
                          );
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t('activada')),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          setState(() {
                            inactiveQuestionsList.removeAt(index);
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${t('error_activar')}: $e'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t('aceptar'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de pregunta inactiva
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade400,
                        Colors.grey.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.desQuestion,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.event_busy, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            "${t('fecha_baja')}: ${formatDate(question.dateLeavingQuestion, [dd, '/', mm, '/', yyyy])}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Indicador de inactivo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        t('inactivo'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Question {
  final int codQuestion;
  final String desQuestion;
  final DateTime dischargeDateQuestion;
  final DateTime dateLeavingQuestion;

  Question(
    this.codQuestion,
    this.desQuestion,
    this.dischargeDateQuestion,
    this.dateLeavingQuestion,
  );
}