// To parse this JSON data, do
//
//     final creditsResponse = creditsResponseFromMap(jsonString);

import 'dart:convert';

CreditsResponse creditsResponseFromMap(String str) =>
    CreditsResponse.fromMap(json.decode(str));

String creditsResponseToMap(CreditsResponse data) => json.encode(data.toMap());

class CreditsResponse {
  int? id;
  List<Cast>? cast;
  List<Cast>? crew;

  CreditsResponse({
    this.id,
    this.cast,
    this.crew,
  });

  factory CreditsResponse.fromMap(Map<String, dynamic> json) => CreditsResponse(
        id: json["id"],
        cast: json["cast"] == null
            ? []
            : List<Cast>.from(json["cast"]!.map((x) => Cast.fromMap(x))),
        crew: json["crew"] == null
            ? []
            : List<Cast>.from(json["crew"]!.map((x) => Cast.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "cast":
            cast == null ? [] : List<dynamic>.from(cast!.map((x) => x.toMap())),
        "crew":
            crew == null ? [] : List<dynamic>.from(crew!.map((x) => x.toMap())),
      };
}

class Cast {
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  int? castId;
  String? character;
  String? creditId;
  int? order;
  String? department;
  String? job;

  Cast({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    this.department,
    this.job,
  });

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: json["department"],
        job: json["job"],
      );

  Map<String, dynamic> toMap() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": department,
        "job": job,
      };
}
