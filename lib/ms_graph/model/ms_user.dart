// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MSUser {
  MSUser({
    required this.displayName,
    required this.jobTitle,
    required this.mail,
  });

  final String displayName;
  final String jobTitle;
  final String mail;

  factory MSUser.fromMap(Map<String, dynamic> map) {
    return MSUser(
      displayName: map['displayName'] as String,
      jobTitle: map['jobTitle'] as String,
      mail: map['mail'] as String,
    );
  }

  factory MSUser.fromJson(String source) {
    return MSUser.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
