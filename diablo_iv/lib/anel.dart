class Anel {
  String descricao;
  int nivelPoder;

  Anel({
    required this.descricao,
    required this.nivelPoder,
  });

  factory Anel.fromJson(Map<String, dynamic> json) {
    return Anel(
      descricao: json['descricao'] ?? '',
      nivelPoder: json['nivelPoder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'nivelPoder': nivelPoder,
    };
  }
}
