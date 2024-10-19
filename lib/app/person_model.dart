import 'package:flutter/material.dart';

@immutable
class PersonModel {
  final String name;
  final int age;

  const PersonModel({required this.name, required this.age});

  factory PersonModel.fromJson({required Map<String, dynamic> json}) {
    final name = json['name'] as String? ?? '';

    final age = json['age'] as int? ?? 0;

    return PersonModel(
      name: name,
      age: age,
    );
  }
}
