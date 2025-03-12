import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerlifter_app/models/records.dart';
import 'package:powerlifter_app/database/database_records.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<Record> record = [];

  final _formKey = GlobalKey<FormState>();
  late var exerciceController = TextEditingController();
  String? currentExercice; // Permet de stocker temporairement le mouvement sélectionné.
  final chargeController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? currentDate;
  final commentaireController = TextEditingController();

  // Liste des mouvements
  final List<String> exercices = ['SQUAT', 'BENCH', 'DEADLIFT'];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    super.dispose();
    exerciceController.dispose();
    chargeController.dispose();
    dateController.dispose();
    commentaireController.dispose();
  }

  // Charger les records depuis la base de données
  void _loadRecords() async {
    final List<Record> loadRecord = await DatabaseRecords.instance.getRecord();
    setState(() {
      record = loadRecord;
    });

    List<List<String>> dataRecord = [];

    for (var record in loadRecord) {
      // Créer une liste avec les informations du record
      List<String> ligne = [
        record.exercice,
        record.charge.toString(),
        record.date,
        record.commentaire,
      ];

      // Ajouter la ligne à user
      dataRecord.add(ligne);
    }
    print(dataRecord);
  }

  // Fonction pour supprimer un record de la base de données et de la liste
  void _supprimerRecord(int id, int index) async {
    try {
      await DatabaseRecords.instance.deleteRecord(id); // Supprimer de la DB
      setState(() {
        record.removeAt(index); // Supprimer de la liste locale
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Record supprimé")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression")),
      );
    }
  }

  // Fonction pour afficher un message de confirmation avant suppression
  void _confirmerSuppression(BuildContext context, int? id, int index) {
    if (id != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmer la suppression"),
            content: Text("Voulez-vous vraiment supprimer ce record ?"),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Supprimer"),
                onPressed: () {
                  _supprimerRecord(id, index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: L'ID est manquant")),
      );
    }
  }

  String? _validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner un mouvement';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Fond sombre pour le Scaffold
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Titre
              Text(
                "Ajouter un record",
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),

              // Liste déroulante exercice
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: DropdownButtonFormField(
                  value: currentExercice,
                  hint: Text(
                    'Sélectionner votre mouvement',
                    style: TextStyle(color: Colors.white),
                  ),
                  items: [
                    DropdownMenuItem(value: 'SQUAT', child: Text("SQUAT")),
                    DropdownMenuItem(value: 'BENCH', child: Text("BENCH")),
                    DropdownMenuItem(value: "DEADLIFT", child: Text("DEADLIFT")),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Mouvement',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple.shade600, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      currentExercice = value;
                      exerciceController.text = value ?? '';
                    });
                  },
                  validator: _validateDropdown,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  dropdownColor: Colors.grey[800],
                ),
              ),

              // Input charge
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Charge',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Votre charge',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple.shade600, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer votre charge";
                    }
                    return null;
                  },
                  controller: chargeController,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),

              // Input date
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: DateTimeFormField(
                  initialValue: currentDate,
                  decoration: InputDecoration(
                    labelText: 'Date du record',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple.shade600, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  firstDate: DateTime.now().add(const Duration(days: 10)),
                  lastDate: DateTime.now().add(const Duration(days: 40)),
                  initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (DateTime? value) {
                    setState(() {
                      currentDate = value;
                      if (value != null) {
                        dateController.text = DateFormat('yyyy-MM-dd').format(value);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Veuillez entrer votre date de record";
                    }
                    return null;
                  },
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),

              // Input commentaire
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Commentaire',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Votre commentaire',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer votre commentaire";
                    }
                    return null;
                  },
                  controller: commentaireController,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),

              // Button valide
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final exercice = exerciceController.text;
                      final charge = double.tryParse(chargeController.text) ?? 0.0;
                      final date = dateController.text;
                      final commentaire = commentaireController.text;

                      // Création d'une instance de Record
                      final record = Record(
                        exercice: exercice,
                        charge: charge,
                        date: date,
                        commentaire: commentaire,
                      );

                      // Appel à la méthode de sauvegarde
                      try {
                        final dbConfig = DatabaseRecords.instance;
                        await dbConfig.insertRecord(record);

                        // Vider les champs après validation
                        setState(() {
                          currentExercice = null;
                          currentDate = null;
                        });
                        exerciceController.clear();
                        chargeController.clear();
                        dateController.clear();
                        commentaireController.clear();

                        // Mettre à jour la liste des utilisateurs
                        _loadRecords();
                      } catch (e) {
                        print("Erreur lors de l'enregistrement: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur lors de l'enregistrement!")),
                        );
                      }

                      FocusScope.of(context).requestFocus(FocusNode());
                      print("\n | Exercice : $exercice \n | Charge : $charge kg \n | Date : $date \n | Commentaire : $commentaire");
                    }
                  },
                  child: Text(
                    "Ajouter",
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

              // Liste des records
              Expanded(
                child: ListView.builder(
                  itemCount: record.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      child: ListTile(
                        title: Text(
                          '${record[index].exercice}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color:  Colors.purple.shade600,
                          ),
                        ),
                        subtitle: Text(
                          'Charge: ${record[index].charge} kg\nDate: ${record[index].date} \nCommentaire: ${record[index].commentaire}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmerSuppression(context, record[index].id, index);
                            _loadRecords();
                          },
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
