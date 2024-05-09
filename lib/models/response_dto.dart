class ResponseDto {
  bool success = false;
  String message = '';

  ResponseDto();

  ResponseDto.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() => {
        'id': success,
        'name': message,
      };
}
