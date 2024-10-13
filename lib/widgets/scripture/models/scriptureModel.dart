// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ScriptureModel {
  final String verse;
  final String text;
  ScriptureModel({
    required this.verse,
    required this.text,
  });

  ScriptureModel copyWith({
    String? verse,
    String? text,
  }) {
    return ScriptureModel(
      verse: verse ?? this.verse,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verse': verse,
      'text': text,
    };
  }

  factory ScriptureModel.fromMap(Map<String, dynamic> map) {
    return ScriptureModel(
      verse: map['verse'] as String,
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScriptureModel.fromJson(String source) =>
      ScriptureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ScriptureModel(verse: $verse, text: $text)';

  @override
  bool operator ==(covariant ScriptureModel other) {
    if (identical(this, other)) return true;

    return other.verse == verse && other.text == text;
  }

  @override
  int get hashCode => verse.hashCode ^ text.hashCode;
}
