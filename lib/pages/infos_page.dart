import 'package:flutter/material.dart';

final List<String> imagePaths = [
  "assets/images/bench.jpg",
  "assets/images/squat.jpg",
  "assets/images/deadlift.jpg",
];
late List<Widget> _pages;

class InfosPage extends StatelessWidget {
  const InfosPage({super.key});

  @override
  Widget build(BuildContext context) {
      _pages = List.generate(
          imagePaths.length,
              (index) => ImagePlaceholder(
            imagePath: imagePaths[index],
          ));

      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.89),
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [

              // Partie carousel 
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.8,
                  child: PageView.builder(
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Partie description du powerlifting
              _buildInfoCard(
                "Le powerlifting, également appelé force athlétique, est un sport de force qui se concentre sur trois mouvements principaux : le squat, le développé couché et le soulevé de terre. L'objectif est de soulever le poids le plus lourd possible dans chacune de ces disciplines.",
              ),

              SizedBox(height: 20),

              // Partie Bench
              _buildExerciseInfo("Le développé couché", "Le développé couché est l'un des trois mouvements principaux du powerlifting. Cet exercice consiste à abaisser une barre jusqu'à la poitrine, puis à la pousser vers le haut jusqu'à l'extension complète des bras."),

              // Partie Deadlift
              _buildExerciseInfo("Le soulevé de terre", "Le soulevé de terre est un exercice fondamental en powerlifting. Il consiste à soulever une barre depuis le sol jusqu'à ce que le corps soit en position complètement droite."),

              // Partie Squat
              _buildExerciseInfo("Le squat", "Le squat est un exercice fondamental en powerlifting, considéré comme l'un des meilleurs mouvements pour développer la force globale. Cet exercice consiste à plier les jambes tout en maintenant une barre sur les épaules, puis à revenir en position debout."),
            ],
          ),
        ),
      );
    }

    // Card pour la description de la force athlétique
    Widget _buildInfoCard(String description) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2))],
        ),
        padding: EdgeInsets.all(16),
        child: Text(
          description,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 12,
            color: Colors.white,
            height: 1.8,
          ),
        ),
      );
    }

    // Card pour la description d'un mouvement
    Widget _buildExerciseInfo(String title, String description) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 12,
                color: Colors.white,
                height: 1.8,
              ),
            ),
          ],
        ),
      );
    }
  }

class ImagePlaceholder extends StatelessWidget {
  final String? imagePath;
  const ImagePlaceholder({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
    );
  }
}
