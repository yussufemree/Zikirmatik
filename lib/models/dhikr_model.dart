import 'dart:convert';

class DhikrModel {
  final String id;
  final String title;
  final String arabic;
  final String meaning;
  final String virtue;
  final int target;
  int count;
  int totalCount;
  final bool isCustom;
  final String category;

  DhikrModel({
    required this.id,
    required this.title,
    required this.arabic,
    required this.meaning,
    required this.virtue,
    this.target = 33,
    this.count = 0,
    this.totalCount = 0,
    this.isCustom = false,
    this.category = 'Genel',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'arabic': arabic,
      'meaning': meaning,
      'virtue': virtue,
      'target': target,
      'count': count,
      'totalCount': totalCount,
      'isCustom': isCustom,
      'category': category,
    };
  }

  factory DhikrModel.fromMap(Map<String, dynamic> map) {
    return DhikrModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      arabic: map['arabic'] ?? '',
      meaning: map['meaning'] ?? '',
      virtue: map['virtue'] ?? '',
      target: (map['target'] as num?)?.toInt() ?? 33,
      count: (map['count'] as num?)?.toInt() ?? 0,
      totalCount: (map['totalCount'] as num?)?.toInt() ?? 0,
      isCustom: map['isCustom'] ?? false,
      category: map['category'] ?? 'Genel',
    );
  }

  String toJson() => json.encode(toMap());

  factory DhikrModel.fromJson(String source) =>
      DhikrModel.fromMap(json.decode(source));

  DhikrModel copyWith({
    String? id,
    String? title,
    String? arabic,
    String? meaning,
    String? virtue,
    int? target,
    int? count,
    int? totalCount,
    bool? isCustom,
    String? category,
  }) {
    return DhikrModel(
      id: id ?? this.id,
      title: title ?? this.title,
      arabic: arabic ?? this.arabic,
      meaning: meaning ?? this.meaning,
      virtue: virtue ?? this.virtue,
      target: target ?? this.target,
      count: count ?? this.count,
      totalCount: totalCount ?? this.totalCount,
      isCustom: isCustom ?? this.isCustom,
      category: category ?? this.category,
    );
  }
}
