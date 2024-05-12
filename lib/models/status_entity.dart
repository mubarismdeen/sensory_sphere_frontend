class StatusEntity {
  int id = 0;
  String description = '';

  StatusEntity({this.id = 0, this.description = ''});

  StatusEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "0";
    description = json['description'] ?? '';
  }
}
