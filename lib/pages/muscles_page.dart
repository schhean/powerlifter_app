import 'package:flutter/material.dart';
import 'package:powerlifter_app/api/api_service.dart';

class MusclesPage extends StatefulWidget {
  const MusclesPage({super.key});

  @override
  State<MusclesPage> createState() => _MusclesPageState();
}

class _MusclesPageState extends State<MusclesPage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late var muscleController = TextEditingController();
  String? currentMuscle;
  final List<String> muscle = [
    'abdominals',
    'abductors',
    'adductors',
    'biceps',
    'calves',
    'chest',
    'forearms',
    'glutes',
    'hamstrings',
    'lats',
    'lower_back',
    'neck',
    'quadriceps',
    'traps',
    'triceps',
  ];

  List<dynamic> exercises = [];
  bool isLoading = false;
  String? errorMessage;

  // Fonction pour appeler l'API
  void _fetchExercises() async {
    if (currentMuscle == null) {
      setState(() {
        errorMessage = "Veuillez sélectionner un muscle.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      exercises = [];
      errorMessage = null;
    });

    try {
      final data = await apiService.fetchData(currentMuscle!);
      setState(() {
        exercises = data;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Erreur lors de la récupération des exercices : $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              // Dropdown affichant tous les muscles disponible
              Container(
                child: DropdownButtonFormField<String>(
                  value: currentMuscle,
                  hint: Text(
                    "Sélectionner votre muscle",
                    style: TextStyle(color: Colors.white),
                  ),
                  items: muscle.map((muscleName) {
                    return DropdownMenuItem<String>(
                      value: muscleName,
                      child: Text(muscleName, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Muscle',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple.shade600, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      currentMuscle = value;
                      errorMessage = null;
                    });
                    print('Muscle sélectionné : $currentMuscle');
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un muscle';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 20),

              // Button 'Rechercher les exercices' Valider
              ElevatedButton(
                onPressed: _fetchExercises,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                    color: Colors.purple.shade600
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Rechercher les exercices',
                  style: TextStyle(
                    color: Colors.purple.shade600,
                    fontFamily: 'Lexend',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

                ),
              ),

              SizedBox(height: 20),


              if (isLoading)
                Center(child: CircularProgressIndicator(color: Colors.purple))
              else if (errorMessage != null)
                Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (exercises.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.black38,
                          child: ListTile(
                            title: Text(
                              exercise['name'] ?? 'Nom non disponible',
                              style: TextStyle(
                                  color: Colors.purple.shade600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            subtitle: Text(
                              textAlign: TextAlign.justify,
                              exercise['instructions'] ?? 'Pas d\'instructions disponibles',
                              style: TextStyle(
                                  color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
