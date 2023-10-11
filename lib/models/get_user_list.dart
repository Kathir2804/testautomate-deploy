// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetUserList {
  String name;
  String id;
  String prefix;
  String email;

  GetUserList({
    required this.name,
    required this.id,
    required this.prefix,
    required this.email,
  });

  GetUserList copyWith({
    String? name,
    String? id,
    String? prefix,
    String? email,
  }) {
    return GetUserList(
      name: name ?? this.name,
      id: id ?? this.id,
      prefix: prefix ?? this.prefix,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'prefix': prefix,
      'email': email,
    };
  }

  factory GetUserList.fromMap(Map<String, dynamic> map) {
    return GetUserList(
      name: map['name'] as String,
      id: map['id'] as String,
      prefix: map['prefix'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUserList.fromJson(String source) =>
      GetUserList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetUserList(name: $name, id: $id, prefix: $prefix, email: $email)';
  }

  @override
  bool operator ==(covariant GetUserList other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.prefix == prefix &&
        other.email == email;
  }

  @override
  int get hashCode {
    return name.hashCode ^ id.hashCode ^ prefix.hashCode ^ email.hashCode;
  }
}
