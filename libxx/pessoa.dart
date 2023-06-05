class Pessoa {
  final int? id;
  final String nome;
  final String sobrenome;
  final int idade;

  Pessoa({
    this.id,
    required this.nome,
    required this.sobrenome,
    required this.idade,
  });

  Map<String, dynamic> criarMap() {
    return {
      "id": id,
      "nome": nome,
      "sobrenome": sobrenome,
      "idade": idade,
    };
  }

  @override
  String toString() {
    return "Pessoa {id: $id, nome: $nome, sobrenome: $sobrenome, idade: $idade}";
  }
}
