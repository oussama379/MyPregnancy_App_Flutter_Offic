import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class MedicalProfile {
  final String nbr_enfant;
  final String medecin_traitant;
  final String maladies_chroniques;
  final String nbr_grossesse_prece;
  final String methode_contraception_utilise;
  final String antecedents_obstetricaux;
  final String antecedents_chirurgicaux;
  final String poids_av_gross;
  final String antecedents_gynecologiques;
  final String maladies_genetiques;
  final String groupe_sanguin;
  final String date_derniere_regle;
  final String date_prevue_accouchement;


  MedicalProfile(this.nbr_enfant, this.medecin_traitant, this.maladies_chroniques,
      this.nbr_grossesse_prece, this.methode_contraception_utilise,
      this.antecedents_obstetricaux, this.antecedents_chirurgicaux,
      this.poids_av_gross, this.antecedents_gynecologiques,
      this.maladies_genetiques, this.groupe_sanguin, this.date_derniere_regle,
      this.date_prevue_accouchement);

  factory MedicalProfile.fromJson(Map<dynamic, dynamic> json){
    if(json == null ) return MedicalProfile('','','','','','','','','','','','','',);
    else {
      final nbr_enfant = json['nbr_enfant'] as String;
      final medecin_traitant = json['medecin_traitant'] as String;
      final maladies_chroniques = json['maladies_chroniques'] as String;
      final nbr_grossesse_prece = json['nbr_grossesse_prece'] as String;
      final methode_contraception_utilise = json['methode_contraception_utilise'] as String;
      final antecedents_obstetricaux = json['antecedents_obstetricaux'] as String;
      final antecedents_chirurgicaux = json['antecedents_chirurgicaux'] as String;
      final poids_av_gross = json['poids_av_gross'] as String;
      final antecedents_gynecologiques = json['antecedents_gynecologiques'] as String;
      final maladies_genetiques = json['groupe_sanguin'] as String;
      final groupe_sanguin = json['groupe_sanguin'] as String;
      final date_derniere_regle = json['date_derniere_regle'] as String;
      final date_prevue_accouchement = json['date_prevue_accouchement'] as String;
      return MedicalProfile(nbr_enfant, medecin_traitant, maladies_chroniques, nbr_grossesse_prece, methode_contraception_utilise, antecedents_obstetricaux, antecedents_chirurgicaux, poids_av_gross, antecedents_gynecologiques, maladies_genetiques, groupe_sanguin, date_derniere_regle, date_prevue_accouchement);
    }

  }

  @override
  String toString() {
    return 'MedicalProfile{nbr_enfant: $nbr_enfant, medecin_traitant: $medecin_traitant, maladies_chroniques: $maladies_chroniques, nbr_grossesse_prece: $nbr_grossesse_prece, methode_contraception_utilise: $methode_contraception_utilise, antecedents_obstetricaux: $antecedents_obstetricaux, antecedents_chirurgicaux: $antecedents_chirurgicaux, poids_av_gross: $poids_av_gross, antecedents_gynecologiques: $antecedents_gynecologiques, maladies_genetiques: $maladies_genetiques, groupe_sanguin: $groupe_sanguin, date_derniere_regle: $date_derniere_regle, date_prevue_accouchement: $date_prevue_accouchement}';
  }
}