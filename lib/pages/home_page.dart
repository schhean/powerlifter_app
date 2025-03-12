import 'package:flutter/material.dart';
import 'infos_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/powerlifting.png',
              width: 500,  // Définit la largeur de l'image
              height: 200, // Définit la hauteur de l'image
            ),
            Text(
              'Powerlifting Guide',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
                color: Colors.white
              ),
            ),
            Text(
              "Votre guide pour développer votre force athlétique !",
              style: TextStyle(
                fontSize: 16,
                  color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Version 1.0',
              style: TextStyle(
                color: Colors.purple.shade600,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 25)),
          ],
        ),
      ),
    );
  }

}