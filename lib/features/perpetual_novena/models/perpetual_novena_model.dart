// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PerpetualNovenaModel {
  final String title;
  final List<dynamic> prayer;
  final String ourFather;
  final String hailMary;
  final String gloryBe;
  final List<dynamic> lastPrayer;
  PerpetualNovenaModel({
    required this.title,
    required this.prayer,
    required this.ourFather,
    required this.hailMary,
    required this.gloryBe,
    required this.lastPrayer,
  });

  PerpetualNovenaModel copyWith({
    String? title,
    List<dynamic>? prayer,
    String? ourFather,
    String? hailMary,
    String? gloryBe,
    List<dynamic>? lastPrayer,
  }) {
    return PerpetualNovenaModel(
      title: title ?? this.title,
      prayer: prayer ?? this.prayer,
      ourFather: ourFather ?? this.ourFather,
      hailMary: hailMary ?? this.hailMary,
      gloryBe: gloryBe ?? this.gloryBe,
      lastPrayer: lastPrayer ?? this.lastPrayer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'prayer': prayer,
      'ourFather': ourFather,
      'hailMary': hailMary,
      'gloryBe': gloryBe,
      'lastPrayer': lastPrayer,
    };
  }

  factory PerpetualNovenaModel.fromMap(Map<String, dynamic> map) {
    return PerpetualNovenaModel(
        title: map['title'] as String,
        prayer: List<dynamic>.from((map['prayer'] as List<dynamic>)),
        ourFather: map['ourFather'] as String,
        hailMary: map['hailMary'] as String,
        gloryBe: map['gloryBe'] as String,
        lastPrayer: List<dynamic>.from(
          (map['lastPrayer'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory PerpetualNovenaModel.fromJson(String source) =>
      PerpetualNovenaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PerpetualNovenaModel(title: $title, prayer: $prayer, ourFather: $ourFather, hailMary: $hailMary, gloryBe: $gloryBe, lastPrayer: $lastPrayer)';
  }

  @override
  bool operator ==(covariant PerpetualNovenaModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        listEquals(other.prayer, prayer) &&
        other.ourFather == ourFather &&
        other.hailMary == hailMary &&
        other.gloryBe == gloryBe &&
        listEquals(other.lastPrayer, lastPrayer);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        prayer.hashCode ^
        ourFather.hashCode ^
        hailMary.hashCode ^
        gloryBe.hashCode ^
        lastPrayer.hashCode;
  }
}
