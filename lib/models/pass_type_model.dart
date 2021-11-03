class PassType {
  final double cover;
  final double entry;
  final String type;
  final int? allowed;

  PassType.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String,
        cover = double.parse(json['cover'].toString()),
        entry = double.parse(json['entry'].toString()),
        allowed = json['allowed'] as int?;

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "cover": cover,
      "entry": entry,
      "allowed": allowed,
    };
  }
}
