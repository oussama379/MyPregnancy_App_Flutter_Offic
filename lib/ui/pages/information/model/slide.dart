import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Month {
  final String imageUrl;
  final String monthNb;
  final String description;

  Month({
    required this.imageUrl,
    required this.monthNb,
    required this.description,
  });


    Month.fromJson(Map<dynamic, dynamic> json)
        : imageUrl = json['image'] as String,
          monthNb = json['title'] as String,
          description = json['description1'] as String;

}

