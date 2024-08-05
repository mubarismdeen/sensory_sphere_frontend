class Address {
  String name;
  String ip;

  Address({required this.name, required this.ip});

  Map<String, dynamic> toJson() => {
        'name': name,
        'ip': ip,
      };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'],
      ip: json['ip'],
    );
  }
}
