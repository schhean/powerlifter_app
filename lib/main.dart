import 'package:flutter/material.dart';
import 'package:powerlifter_app/pages/records_page.dart';
import 'package:powerlifter_app/pages/home_page.dart';
import 'package:powerlifter_app/pages/infos_page.dart';
import 'package:powerlifter_app/pages/muscles_page.dart';
import 'package:powerlifter_app/pages/programme_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: [
            Text(
              "",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lexend',
              ),
            ),
            Text(
              "Qu'est ce que le powerlifting ?",
              style: TextStyle(
                fontFamily: 'Lexend',
                color: Colors.white,
              ),
            ),
            Text(
              "Mes records",
              style: TextStyle(
                fontFamily: 'Lexend',
                color: Colors.white,
              ),
            ),
            Text(
              "Exercices complémentaires",
              style: TextStyle(
                fontFamily: 'Lexend',
                color: Colors.white
              ),
            ),
            Text(
              "Mon programme",
              style: TextStyle(
                fontFamily: 'Lexend',
                color: Colors.white,
              ),
            ),
          ][_currentIndex],
        ),
        body: [HomePage(), InfosPage(), FormPage(), MusclesPage(), ProgrammePage()][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => setCurrentIndex(index),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.purple.shade600,
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.black87,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Description'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Records'),
            BottomNavigationBarItem(icon: Icon(Icons.accessibility_new), label: 'Muscles'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Programme'),
          ],
        ),
      ),
    );
  }
}
