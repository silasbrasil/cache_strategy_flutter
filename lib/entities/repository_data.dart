enum Source { API, CACHE }

class RepositoryData {
  final dynamic data;
  final Source source;
  DateTime expiresAt;
  DateTime updatedAt;

  RepositoryData(
    this.data, {
    this.source = Source.CACHE,
    DateTime expiresAt,
    DateTime updatedAt,
  }) {
    this.expiresAt = expiresAt ?? DateTime.now().add(Duration(minutes: 5));
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  factory RepositoryData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return RepositoryData(
      json['data'],
      expiresAt: DateTime.parse(json['expires_at']),
      updatedAt: DateTime.parse(json['update_at']),
    );
  }

  bool get isValid => DateTime.now().isBefore(expiresAt);

  bool get isEmpty =>
      data is List ? (data as List).isEmpty : (data as Map).isEmpty;

  bool get isNotEmpty =>
      data is List ? (data as List).isNotEmpty : (data as Map).isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'expires_at': expiresAt.toString(),
      'update_at': updatedAt.toString(),
    };
  }

  RepositoryData copyWith({
    dynamic data,
    Source source,
    DateTime expiresAt,
    DateTime updatedAt,
  }) {
    return RepositoryData(
      data ?? this.data,
      source: source ?? this.source,
      expiresAt: expiresAt ?? this.expiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
