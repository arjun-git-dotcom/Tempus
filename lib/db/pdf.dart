
import 'package:hive_flutter/hive_flutter.dart';
  part 'pdf.g.dart';

@HiveType(typeId: 2)
class PDFDocument {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;
  @HiveField(2)
  PDFDocument({required this.name, required this.path});
   
  }

