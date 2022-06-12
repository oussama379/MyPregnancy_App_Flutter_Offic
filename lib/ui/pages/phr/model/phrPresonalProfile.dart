import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class PersonalProfile {
  final String adresse;
  final String age_mariage;
  final String date_naissance;
  final String email;
  final String image;
  final String instruction;
  final String nom;
  final String numero;
  final String prenom;
  final String profession;
  final String situation_familiale;
  final String taille;




  PersonalProfile(
      this.adresse,
      this.age_mariage,
      this.date_naissance,
      this.email,
      this.image,
      this.instruction,
      this.nom,
      this.numero,
      this.prenom,
      this.profession,
      this.situation_familiale,
      this.taille);

  factory PersonalProfile.fromJson(Map<dynamic, dynamic> json){
    if(json == null ) return PersonalProfile('','','','','','','','','','','','');
    else {
      final adresse = json['adresse'] as String;
      final age_mariage = json['age_mariage'] as String;
      final date_naissance = json['date_naissance'] as String;
      final email = json['email'] as String;
      final image = json['image'] as String;
      final instruction = json['instruction'] as String;
      final nom = json['nom'] as String;
      final numero = json['numero'] as String;
      final prenom = json['prenom'] as String;
      final profession = json['profession'] as String;
      final situation_familiale = json['situation_familiale'] as String;
      final taille = json['taille'] as String;
      return PersonalProfile(
          adresse,
          age_mariage,
          date_naissance,
          email,
          image,
          instruction,
          nom,
          numero,
          prenom,
          profession,
          situation_familiale,
          taille);
    }


  }

  @override
  String toString() {
    return 'PersonalProfile{adresse: $adresse, age_mariage: $age_mariage, date_naissance: $date_naissance, email: $email, image: $image, instruction: $instruction, nom: $nom, numero: $numero, prenom: $prenom, profession: $profession, situation_familiale: $situation_familiale, taille: $taille}';
  }
}