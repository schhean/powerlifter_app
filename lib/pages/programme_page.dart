import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerlifter_app/models/programmes.dart';
import 'package:powerlifter_app/database/database_programmes.dart';

class ProgrammePage extends StatefulWidget {
  const ProgrammePage({super.key});

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {
  List<Programme> program = [];
  Map<String, dynamic>? latestProgram;
  final _formKey = GlobalKey<FormState>();

  final squatController = TextEditingController();
  final benchController = TextEditingController();
  final deadliftController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLatestProgram();
  }

  void dispose() {
    super.dispose();
    squatController.dispose();
    benchController.dispose();
    deadliftController.dispose();
  }

  void _loadLatestProgram() async {
    final Map<String, dynamic>? loadProgram =
        await DatabaseProgrammes.instance.getLastProgram();

    setState(() {
      latestProgram = loadProgram;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input SQUAT
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'PR SQUAT',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Votre charge',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.purple.shade600, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre 1 RM sur le SQUAT";
                        }
                        return null;
                      },
                      controller: squatController,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Input BENCH
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'PR BENCH',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Votre charge',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.purple.shade600, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre 1 RM sur le BENCH";
                        }
                        return null;
                      },
                      controller: benchController,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Input DEADLIFT
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'PR DEADLIFT',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Votre charge',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.purple.shade600, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre 1 RM sur le DEADLIFT";
                        }
                        return null;
                      },
                      controller: deadliftController,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Button Valide
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final squat = squatController.text;
                          final bench = benchController.text;
                          final deadlift = deadliftController.text;

                          // Création d'une instance de Program
                          final program = Programme(
                              squatPR: double.parse(squat),
                              benchPR: double.parse(bench),
                              deadliftPR: double.parse(deadlift));

                          // Appel à la méthode de sauvegarde
                          try {
                            final dbConfig = DatabaseProgrammes.instance;
                            await dbConfig.insertProgramme(program);

                            // Vider les champs après validation
                            squatController.clear();
                            benchController.clear();
                            deadliftController.clear();

                            // Remettre à jour le dernier programme
                            _loadLatestProgram();
                          } catch (e) {
                            print("Erreur lors de l'enregistrement: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Erreur lors de l'enregistrement!")),
                            );
                          }

                          FocusScope.of(context).requestFocus(FocusNode());
                          print(
                              "SQUAT : $squat \nBENCH : $bench \nDEADLIFT : $deadlift");
                        }
                      },
                      child: Text(
                        "Valider",
                        style: TextStyle(
                          color: Colors.purple.shade600,
                          fontFamily: 'Lexend',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 20)),

                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PR Actuels',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.purple.shade600,
                          ),
                        ),
                        SizedBox(height: 15),

                        // Affichage des PR actuels
                        Text(
                          'Squat : ${latestProgram?['squatPR']} kg',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Bench : ${latestProgram?['benchPR']} kg',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Deadlift : ${latestProgram?['deadliftPR']} kg',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 20)),

                  // Si aucun programme enregistré
                  Flexible(
                    child: latestProgram == null
                        ? Center(
                      child: Text(
                        "Aucun programme enregistré",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4), // Fond sombre semi-transparent
                        borderRadius: BorderRadius.circular(12), // Bordures arrondies
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Ombre pour donner de la profondeur
                            blurRadius: 8,
                            offset: Offset(0, 4), // Position de l'ombre
                          ),
                        ],
                      ),
                      child: ListView(
                        children: [
                          // Titre de la section
                          Text(
                            'Votre programme',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.purple.shade600,
                              fontFamily: 'Lexend',
                            ),
                          ),
                          SizedBox(height: 20),

                          // Semaine 1
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today, // Icône de calendrier
                                    color: Colors.purple.shade600, // Couleur de l'icône
                                    size: 24, // Taille de l'icône
                                  ),
                                  SizedBox(width: 10), // Espacement entre l'icône et le texte
                                  Text(
                                    "Semaine 1 : Volume modéré",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              )

                          ),
                          SizedBox(height: 15),
                          _buildExerciseRow('Squat', latestProgram?['squatPR'], 0.75, "4 séries de 6 répétitions à RPE 7-8"),
                          _buildExerciseRow('Développé couché', latestProgram?['benchPR'], 0.75, "4 séries de 6 répétitions à RPE 7-8"),
                          _buildExerciseRow('Soulevé de terre', latestProgram?['deadliftPR'], 0.75, " 3 séries de 5 répétitions à RPE 7-8"),
                          SizedBox(height: 5),
                          Text(
                            'Objectif : Développer la technique tout en travaillant avec un volume modéré. La charge doit être suffisamment lourde pour ressentir un effort important mais pas à une intensité maximale.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 30),

                          // Ligne de séparation
                          Container(
                            height: 1.0,
                            color: Colors.purple.shade600,
                            margin: EdgeInsets.symmetric(vertical: 15),
                          ),

                          // Semaine 2
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.purple.shade600,
                                    size: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(  // Permet au texte de prendre l'espace restant
                                    child: Text(
                                      "Semaine 2 : Augmentation du volume",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                      softWrap: true, // Permet au texte de passer à la ligne
                                      overflow: TextOverflow.ellipsis, // Ajoute "..." si nécessaire
                                    ),
                                  ),
                                ],
                              )
                          ),
                          SizedBox(height: 15),
                          _buildExerciseRow('Squat', latestProgram?['squatPR'], 0.80, "5 séries de 5 répétitions à RPE 7-8"),
                          _buildExerciseRow('Développé couché', latestProgram?['benchPR'], 0.80, "5 séries de 5 répétitions à RPE 7-8"),
                          _buildExerciseRow('Soulevé de terre', latestProgram?['deadliftPR'], 0.80, "4 séries de 5 répétitions à RPE 7-8"),
                          SizedBox(height: 5),
                          Text(
                            'Objectif : Augmenter légèrement le volume tout en maintenant une intensité de travail dans la fourchette de RPE 7-8 pour continuer à renforcer la technique et la force de base.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 30),

                          // Ligne de séparation
                          Container(
                            height: 1.0,
                            color: Colors.purple.shade600,
                            margin: EdgeInsets.symmetric(vertical: 15),
                          ),

                          // Semaine 3
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today, // Icône de calendrier
                                    color: Colors.purple.shade600, // Couleur de l'icône
                                    size: 24, // Taille de l'icône
                                  ),
                                  SizedBox(width: 10), // Espacement entre l'icône et le texte
                                  Text(
                                    "Semaine 3 : Intensité élevée",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              )

                          ),
                          SizedBox(height: 15),
                          _buildExerciseRow('Squat', latestProgram?['squatPR'], 0.85, "4 séries de 3 répétitions à RPE 8-9"),
                          _buildExerciseRow('Développé couché', latestProgram?['benchPR'], 0.85, "4 séries de 3 répétitions à RPE 8-9"),
                          _buildExerciseRow('Soulevé de terre', latestProgram?['deadliftPR'], 0.85, "3 séries de 3 répétitions à RPE 8-9"),
                          SizedBox(height: 5),
                          Text(
                            'Objectif : Augmenter l\'intensité en diminuant le volume. L\'objectif ici est de travailler plus près de votre limite maximale (mais sans la dépasser).',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 30),

                          // Ligne de séparation
                          Container(
                            height: 1.0,
                            color: Colors.purple.shade600,
                            margin: EdgeInsets.symmetric(vertical: 15),
                          ),

                          // Semaine 4
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Semaine 4 : Test de la force",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildExerciseRow('Squat', latestProgram?['squatPR'], 1.05, "1 série de 1 répétition à RPE 10 (maximum)"),
                          _buildExerciseRow('Développé couché', latestProgram?['benchPR'], 1.05, "1 série de 1 répétition à RPE 10 (maximum)"),
                          _buildExerciseRow('Soulevé de terre', latestProgram?['deadliftPR'], 1.05, "1 série de 1 répétition à RPE 10 (maximum)"),
                          SizedBox(height: 5),
                          Text(
                            'Objectif : Tester votre force maximale pour chaque mouvement après un mois de travail. Utilisez cette semaine pour évaluer vos progrès.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                ])),
      ),
    );
  }
}

// Container contenant l'exercice prenant en paramètre : String : nom de l'exercie, double : rpe du mouvement
Widget _buildExerciseRow(String exercise, dynamic maxPR, double rpeFactor, String rpeLabel) {
  double weight = (double.tryParse(maxPR.toString()) ?? 0) * rpeFactor;
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(Icons.fitness_center, color: Colors.white),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '$exercise: $rpeLabel\n'
                'Charge estimée: ${weight.toStringAsFixed(1)} kg',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

