import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [id, name, phone];
}
