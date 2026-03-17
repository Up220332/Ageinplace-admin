import 'package:ageinplace_admin/BarraLateral/NavBar_super_admin.dart';
import 'package:ageinplace_admin/SuperAdmin/screen_inactive_questions.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../base_de_datos/postgres.dart';

/// *****************************************************************************
/// Funcion que devuelve todas las preguntas que existen. Tambien permite añadir
/// nuevas preguntas y modificarlas.
///****************************************************************************

class ScreenQuestions extends StatefulWidget {
  const ScreenQuestions({super.key});

  @override
  State<ScreenQuestions> createState() => _ScreenQuestionsState();
}

class _ScreenQuestionsState extends State<ScreenQuestions> {
  List<Question> questionsList = [];
  final TextEditingController newQuestionController = TextEditingController();
  final TextEditingController _controllerQuestion = TextEditingController();
  late String _currentLocale;

  final colorPrimario = const Color.fromARGB(255, 25, 144, 234);

  // Mapa de traducciones
  final Map<String, Map<String, String>> translations = {
    'es': {
      'titulo': 'Preguntas',
      'aniadir_pregunta': 'Añadir pregunta',
      'preguntas_inactivas': 'Preguntas inactivas',
      'nueva_pregunta': 'Nueva pregunta',
      'pregunta': 'Pregunta',
      'agregar': 'Agregar',
      'error': 'Error',
      'campo_vacio': 'El campo de la pregunta no puede estar vacío.',
      'aceptar': 'Aceptar',
      'pregunta_aniadida': 'Pregunta añadida correctamente',
      'fecha_alta': 'Fecha de alta',
      'modificar_desactivar': 'Modificar o desactivar la pregunta',
      'modificar': 'Modificar',
      'desactivar': 'Desactivar',
      'pregunta_modificada': 'Pregunta modificada correctamente',
      'pregunta_desactivada': 'Pregunta desactivada correctamente',
      'cargando': 'Cargando...',
    },
    'en': {
      'titulo': 'Questions',
      'aniadir_pregunta': 'Add question',
      'preguntas_inactivas': 'Inactive questions',
      'nueva_pregunta': 'New question',
      'pregunta': 'Question',
      'agregar': 'Add',
      'error': 'Error',
      'campo_vacio': 'The question field cannot be empty.',
      'aceptar': 'Accept',
      'pregunta_aniadida': 'Question added successfully',
      'fecha_alta': 'Creation date',
      'modificar_desactivar': 'Modify or deactivate the question',
      'modificar': 'Modify',
      'desactivar': 'Deactivate',
      'pregunta_modificada': 'Question modified successfully',
      'pregunta_desactivada': 'Question deactivated successfully',
      'cargando': 'Loading...',
    }
  };

  // Función para obtener texto traducido
  String t(String key) {
    String currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    return translations[currentLocale]?[key] ?? translations['es']![key]!;
  }

  Future<String> getData() async {
    final data = await DBPostgres().DBGetQuestions();

    if (data is List) {
      setState(() {
        questionsList = data.map((row) {
          return Question(row[0], row[1], row[2], row[3]);
        }).toList();
      });
    } else {
      print('Error al obtener las preguntas: $data');
    }
    return 'Successfully Fetched data';
  }

  @override
  void initState() {
    super.initState();
    _currentLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String newLocale = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';
    if (_currentLocale != newLocale) {
      setState(() {
        _currentLocale = newLocale;
      });
    }
  }

  @override
  void dispose() {
    _controllerQuestion.dispose();
    newQuestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setStateDialog) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.add_circle_outline, color: colorPrimario),
                              const SizedBox(width: 10),
                              Text(t('aniadir_pregunta')),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t('nueva_pregunta'),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
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
                                child: TextFormField(
                                  controller: newQuestionController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: t('pregunta'),
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    prefixIcon: Icon(Icons.help_outline, size: 20, color: colorPrimario),
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
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final newText = newQuestionController.text.trim();
                                    if (newText.isNotEmpty) {
                                      await DBPostgres().DBAddQuestion(newText);
                                      newQuestionController.clear();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(t('pregunta_aniadida')),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                      await getData();
                                      setState(() {});
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
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
                                            content: Text(t('campo_vacio')),
                                            actions: [
                                              TextButton(
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
                                    backgroundColor: colorPrimario,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    t('agregar'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              backgroundColor: colorPrimario,
              label: Text(
                t('aniadir_pregunta'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreenInactiveQuestions(),
                ),
              ),
              backgroundColor: Colors.red,
              label: Text(
                t('preguntas_inactivas'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const Icon(Icons.visibility_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
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
        child: questionsList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      t('cargando'),
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: questionsList.length,
                  itemBuilder: (context, index) {
                    final question = questionsList[index];
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
            _controllerQuestion.text = question.desQuestion;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.edit, color: colorPrimario),
                      const SizedBox(width: 10),
                      Text(t('modificar_desactivar')),
                    ],
                  ),
                  content: Container(
                    constraints: const BoxConstraints(maxHeight: 350),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                          child: TextField(
                            maxLines: 3,
                            controller: _controllerQuestion,
                            decoration: InputDecoration(
                              labelText: t('pregunta'),
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              prefixIcon: Icon(Icons.help_outline, size: 20, color: colorPrimario),
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
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimario,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              await DBPostgres().DBUpdateQuestionDescription(
                                question.codQuestion,
                                _controllerQuestion.text,
                              );
                              await getData();
                              setState(() {});
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(t('pregunta_modificada')),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: Text(
                              t('modificar'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              await DBPostgres().DBDeactivateQuestion(
                                question.codQuestion,
                              );
                              setState(() {
                                questionsList.removeAt(index);
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(t('pregunta_desactivada')),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.block, color: Colors.white),
                            label: Text(
                              t('desactivar'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de pregunta
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorPrimario.withOpacity(0.8),
                        colorPrimario,
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            "${t('fecha_alta')}: ${formatDate(question.dischargeDateQuestion, [dd, '/', mm, '/', yyyy])}",
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
                
                // Icono de editar
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorPrimario.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: colorPrimario,
                    size: 20,
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
  final DateTime? dateLeavingQuestion;

  Question(
    this.codQuestion,
    this.desQuestion,
    this.dischargeDateQuestion,
    this.dateLeavingQuestion,
  );
}