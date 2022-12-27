import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
 part 'modeltask.g.dart';
@HiveType(typeId: 0)
class modeltask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String subtitle;

  @HiveField(3)
  DateTime createdattime;

  @HiveField(4)
  DateTime createdatdate;

  @HiveField(5)
  bool iscompleted;

  modeltask({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdattime,
    required this.createdatdate,
    required this.iscompleted,
  });

  //create new model task

  factory modeltask.create({
    required String? title,
    required String? subtitle,
    DateTime? createdattime,
    DateTime? createdatdate,
  }) =>
      modeltask(
        id: Uuid().v1(),
        title: title ?? "",
        subtitle: subtitle ?? "",
        createdattime: createdattime ?? DateTime.now(),
        createdatdate: createdatdate ?? DateTime.now(),
        iscompleted: false,
      );
}
